
`include "defines.sv"
`include "define.v"

class alu_reference_model;

  mailbox #(alu_transaction) mbx_dr;
  mailbox #(alu_transaction) mbx_rs;
  virtual alu_if.REF vif;

  function new(mailbox #(alu_transaction) mbx_dr, mailbox #(alu_transaction) mbx_rs, virtual alu_if.REF vif);
    this.mbx_dr = mbx_dr;
    this.mbx_rs = mbx_rs;
    this.vif = vif;
  endfunction

  task start();
    alu_transaction ref_trans;
    //ref_trans = new();

    for (int i = 0; i < `no_of_trans; i++) begin
     ref_trans = new();

      mbx_dr.get(ref_trans);

      // Set all outputs to high impedance
      ref_trans.RES = {(`OP_WIDTH+1){1'bz}};
      ref_trans.COUT = 'bz;
      ref_trans.OFLOW = 'bz;
      ref_trans.G = 'bz;
      ref_trans.E = 'bz;
      ref_trans.L = 'bz;
      ref_trans.ERR = 'bz;

      // Get transaction
      //mbx_dr.get(ref_trans);

      // Wait for operands if needed (timeout after 16 cycles)
      for (int timeout = 0; timeout < 16; timeout++) begin
        if (ref_trans.INP_VALID == 0) begin
          ref_trans.ERR = 1'b1;
          break;
        end

        // Check if we have enough operands for the operation
        if ((ref_trans.MODE && (ref_trans.CMD == 4 || ref_trans.CMD == 5) && ref_trans.INP_VALID[0]) ||  // INC_A, DEC_A need OPA
            (ref_trans.MODE && (ref_trans.CMD == 6 || ref_trans.CMD == 7) && ref_trans.INP_VALID[1]) ||  // INC_B, DEC_B need OPB
            (!ref_trans.MODE && (ref_trans.CMD == 6 || ref_trans.CMD == 8 || ref_trans.CMD == 9) && ref_trans.INP_VALID[0]) ||  // NOT_A, SHR1_A, SHL1_A need OPA
            (!ref_trans.MODE && (ref_trans.CMD == 7 || ref_trans.CMD == 10 || ref_trans.CMD == 11) && ref_trans.INP_VALID[1]) || // NOT_B, SHR1_B, SHL1_B need OPB
            (ref_trans.INP_VALID == 3)) begin  // All other operations need both
          break;  // We have enough operands
        end

        if (timeout == 15) begin
          ref_trans.ERR = 1'b1;  // Timeout error
          break;
        end

//         mbx_dr.get(ref_trans);  // Get next transaction
      end

      // Handle reset and clock enable
      if (vif.REF_SB.RST == 1'b1) begin
        ref_trans.RES = {(`OP_WIDTH+1){1'bz}};
        ref_trans.COUT = 'bz;
        ref_trans.ERR = 'bz;
        ref_trans.OFLOW = 'bz;
        ref_trans.G = 'bz;
        ref_trans.E = 'bz;
        ref_trans.L = 'bz;
      end
      else if (ref_trans.CE == 1'b0) begin
        ref_trans.RES = {(`OP_WIDTH+1){1'bz}};
        ref_trans.COUT = 'bz;
        ref_trans.ERR = 'bz;
        ref_trans.OFLOW = 'bz;
        ref_trans.G = 'bz;
        ref_trans.E = 'bz;
        ref_trans.L = 'bz;
      end
      else begin
        // Only do operations if no error from operand checking
        if (ref_trans.ERR !== 1'b1) begin
          if (ref_trans.MODE) begin  // Arithmetic
            case (ref_trans.CMD)
              0: begin ref_trans.RES = ref_trans.OPA + ref_trans.OPB; ref_trans.COUT = ref_trans.RES[`OP_WIDTH];
              $display("[REFERENCE MODEL] @%0t: Computed RES=%0d OFLOW=%0b G=%0b L=%0b E=%0b",
                 $time, ref_trans.RES, ref_trans.OFLOW,
                 ref_trans.G, ref_trans.L, ref_trans.E);end

              1: begin ref_trans.RES = ref_trans.OPA - ref_trans.OPB; ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB); end

              2: begin ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN; ref_trans.COUT = ref_trans.RES[`OP_WIDTH]; end

              3: begin ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN; ref_trans.OFLOW = (ref_trans.OPA < (ref_trans.OPB + ref_trans.CIN)); end

              4: begin ref_trans.RES = ref_trans.OPA + 1; ref_trans.COUT = ref_trans.RES[`OP_WIDTH]; end

              5: begin ref_trans.RES = ref_trans.OPA - 1; ref_trans.OFLOW = (ref_trans.OPA == 0); end

              6: begin ref_trans.RES = ref_trans.OPB + 1; ref_trans.COUT = ref_trans.RES[`OP_WIDTH]; end

              7: begin ref_trans.RES = ref_trans.OPB - 1; ref_trans.OFLOW = (ref_trans.OPB == 0); end

              8: begin ref_trans.RES = 0; ref_trans.E = (ref_trans.OPA == ref_trans.OPB); ref_trans.G = (ref_trans.OPA > ref_trans.OPB); ref_trans.L = (ref_trans.OPA < ref_trans.OPB); end

              9: begin
                ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
                $display("[REFERENCE MODEL] @%0t: Computed RES=%0d OFLOW=%0b G=%0b L=%0b E=%0b",
                 $time, ref_trans.RES, ref_trans.OFLOW,
                 ref_trans.G, ref_trans.L, ref_trans.E);
                 end

              10: ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB;

              default: ref_trans.ERR = 1'b1;
            endcase

          end else begin  // Logical
            case (ref_trans.CMD)
              0: ref_trans.RES = {1'b0,ref_trans.OPA & ref_trans.OPB};

              1: ref_trans.RES = {1'b0,~(ref_trans.OPA & ref_trans.OPB)};

              2: ref_trans.RES = {1'b0,ref_trans.OPA | ref_trans.OPB};

              3: ref_trans.RES = {1'b0,~(ref_trans.OPA | ref_trans.OPB)};

              4: ref_trans.RES = {1'b0,ref_trans.OPA ^ ref_trans.OPB};

              5: ref_trans.RES = {1'b0,~(ref_trans.OPA ^ ref_trans.OPB)};

              6: ref_trans.RES = {1'b0,~ref_trans.OPA};

              7: ref_trans.RES = {1'b0,~ref_trans.OPB};

              8: ref_trans.RES = {1'b0,ref_trans.OPA >> 1};

              9: ref_trans.RES = {1'b0,ref_trans.OPA << 1};

              10: ref_trans.RES = {1'b0,ref_trans.OPB >> 1};

              11: ref_trans.RES = {1'b0,ref_trans.OPB << 1};

              12: begin
                ref_trans.RES = (ref_trans.OPA << ref_trans.OPB[`ROR_WIDTH-1:0]) | (ref_trans.OPA >> (`OP_WIDTH - ref_trans.OPB[`ROR_WIDTH-1:0]));
                if (|ref_trans.OPB[7:4]) ref_trans.ERR = 1'b1;
              end

              13: begin
                ref_trans.RES = (ref_trans.OPA >> ref_trans.OPB[`ROR_WIDTH-1:0]) | (ref_trans.OPA << (`OP_WIDTH - ref_trans.OPB[`ROR_WIDTH-1:0]));
                if (|ref_trans.OPB[7:4]) ref_trans.ERR = 1'b1;
              end

              default: ref_trans.ERR = 1'b1;
            endcase
          end
        end
      end

      // Wait appropriate cycles and send result
      if (ref_trans.MODE && (ref_trans.CMD == 9 || ref_trans.CMD == 10)) begin
        repeat(1) @(vif.ref_cb);
      end else begin
        repeat(1) @(vif.ref_cb);
      end
      $display("[REFERENCE -->> SB] @%0t: Computed RES=%0d OFLOW=%0b G=%0b L=%0b E=%0b",
                 $time, ref_trans.RES, ref_trans.OFLOW,
                 ref_trans.G, ref_trans.L, ref_trans.E);
      mbx_rs.put(ref_trans);
    end
  endtask

endclass
