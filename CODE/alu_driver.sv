
`include "defines.sv"

class alu_driver;
   alu_transaction drv_trans;
   alu_transaction temp_tr;
   mailbox #(alu_transaction) mbx_gd;
   mailbox #(alu_transaction) mbx_dr;
   virtual alu_if.DRV vif;

   bit found_valid_11 = 1'b0;


  covergroup DRV_cg;
        INPUT_VALID : coverpoint drv_trans.INP_VALID { bins valid_opa = {2'b01};
                                                       bins valid_opb = {2'b10};
                                                           bins valid_both = {2'b11};
                                                       bins invalid = {2'b00};
                                                         }
        COMMAND : coverpoint drv_trans.CMD { bins arithmetic[] = {[0:10]};
                                                 bins logical[] = {[0:13]};
                                             bins arithmetic_invalid[] = {[11:15]};
                                                 bins logical_invalid[] = {14,15};
                                            }
        MODE : coverpoint drv_trans.MODE { bins arithmetic = {1};
                                           bins logical = {0};
                                             }
        CLOCK_ENABLE : coverpoint drv_trans.CE { bins clock_enable_valid = {1};
                                                     bins clock_enable_invalid = {0};
                                               }
                 OPERAND_A : coverpoint drv_trans.OPA { bins opa[]={[0:(2**`OP_WIDTH)-1]};}
                 OPERAND_B : coverpoint drv_trans.OPB { bins opb[]={[0:(2**`OP_WIDTH)-1]};}
             CARRY_IN : coverpoint drv_trans.CIN { bins cin_high = {1};
                                                  bins cin_low = {0};
                                            }
        MODE_X_CMD : cross MODE,COMMAND;
        OPA_X_OPB : cross OPERAND_A, OPERAND_B;
        INP_VALID_X_CMD : cross COMMAND, INPUT_VALID;
        MODE_X_INP_VALID : cross MODE, INPUT_VALID;
 endgroup


   function new(mailbox #(alu_transaction) mbx_gd,
               mailbox #(alu_transaction) mbx_dr,
               virtual alu_if.DRV vif);

    this.mbx_gd = mbx_gd;
    this.mbx_dr = mbx_dr;
    this.vif = vif;
    DRV_cg = new();
   endfunction

   function void drive_VI();
    vif.drv_cb.CE        <= drv_trans.CE;
    vif.drv_cb.CIN       <= drv_trans.CIN;
    vif.drv_cb.INP_VALID <= drv_trans.INP_VALID;
    vif.drv_cb.MODE      <= drv_trans.MODE;
    vif.drv_cb.CMD       <= drv_trans.CMD;
    vif.drv_cb.OPA       <= drv_trans.OPA;
    vif.drv_cb.OPB       <= drv_trans.OPB;

    $display("[DRIVER MODEL VI ] @%0t:DRIVER DRIVING DATA TO THE INTERFACE CE=%d,CIN=%d,INP_VALID=%d,MODE=%d,CMD=%d,OPA=%d,OPB=%d",
             $time, drv_trans.CE, drv_trans.CIN, drv_trans.INP_VALID, drv_trans.MODE, drv_trans.CMD, drv_trans.OPA, drv_trans.OPB);
   endfunction

   function void drive_temp_VI();
    vif.drv_cb.CE        <= temp_tr.CE;
    vif.drv_cb.CIN       <= temp_tr.CIN;
    vif.drv_cb.INP_VALID <= temp_tr.INP_VALID;
    vif.drv_cb.MODE      <= temp_tr.MODE;
    vif.drv_cb.CMD       <= temp_tr.CMD;
    vif.drv_cb.OPA       <= temp_tr.OPA;
    vif.drv_cb.OPB       <= temp_tr.OPB;

    $display("[DRIVER MODEL inside wait 16 ] @%0t:DRIVER DRIVING DATA TO THE INTERFACE CE=%d,CIN=%d,INP_VALID=%d,MODE=%d,CMD=%d,OPA=%d,OPB=%d",
             $time, temp_tr.CE, temp_tr.CIN, temp_tr.INP_VALID, temp_tr.MODE, temp_tr.CMD, temp_tr.OPA, temp_tr.OPB);
   endfunction

   task timing();
    if (drv_trans.MODE && (drv_trans.CMD inside {'d9, 'd10})) begin
      repeat(2) @(vif.drv_cb);
    end
    else begin
      @(vif.drv_cb);
    end
   endtask

   task start();
    repeat(4) @(vif.drv_cb);

    for (int i = 0; i < `no_of_trans; i++) begin
      drv_trans = new();
      mbx_gd.get(drv_trans);

      // Reset found_valid_11 flag for each new transaction
      found_valid_11 = 1'b0;

      if (drv_trans.INP_VALID == 2'b11 || drv_trans.INP_VALID == 2'b00) begin
        drive_VI();
        timing();
        mbx_dr.put(drv_trans);
        DRV_cg.sample();
        $display("DRIVER INPUT FUNCTIONAL COVERAGE =%.2f ",DRV_cg.get_coverage());
      end

      else if (((drv_trans.INP_VALID == 2'b01) && (drv_trans.MODE == 1) && (drv_trans.CMD inside {4, 6})) ||
               ((drv_trans.INP_VALID == 2'b10) && (drv_trans.MODE == 1) && (drv_trans.CMD inside {5, 7})) ||
               ((drv_trans.INP_VALID == 2'b01) && (drv_trans.MODE == 0) && (drv_trans.CMD inside {6, 8, 9})) ||
               ((drv_trans.INP_VALID == 2'b10) && (drv_trans.MODE == 0) && (drv_trans.CMD inside {7, 10, 11}))) begin
        drive_VI();
        timing();
        mbx_dr.put(drv_trans);
        DRV_cg.sample();
        $display("DRIVER INPUT FUNCTIONAL COVERAGE =%.2f ",DRV_cg.get_coverage());
      end

      else begin
        // Drive original transaction first
        drive_VI();
        timing();
//         $display("[Driver: @0t]ref putting 1st",$time);
        mbx_dr.put(drv_trans);
        DRV_cg.sample();
        $display("DRIVER INPUT FUNCTIONAL COVERAGE =%.2f ",DRV_cg.get_coverage());

        // Now start the wait sequence
        for (int clk_count = 0; clk_count < 16 && !found_valid_11; clk_count++) begin
          temp_tr = new();
          temp_tr.CMD.rand_mode(0);
          temp_tr.MODE.rand_mode(0);
          temp_tr.CMD = drv_trans.CMD;
          temp_tr.MODE = drv_trans.MODE;
          void'(temp_tr.randomize());

          repeat(2) @(vif.drv_cb);
          drive_temp_VI();
//           $display("[Driver: @0t]ref putting 2nd",$time);
          mbx_dr.put(temp_tr);
          DRV_cg.sample();
          $display("DRIVER INPUT FUNCTIONAL COVERAGE =%.2f ",DRV_cg.get_coverage());

          if (temp_tr.INP_VALID == 2'b11) begin
            found_valid_11 = 1'b1;
            $display("FOUND INP_VALID == 11 AT CYCLE %0d", clk_count + 1);
            break;
          end
        end

        if (!found_valid_11) begin
          $display("DID NOT FIND INP_VALID == 11 WITHIN 16 CLOCK CYCLES");
        end
      end
    end
    repeat(2)@(vif.drv_cb);
    $display("-----------DRIVER INPUT COVERAGE------------ \n");
    $display("TOTAL = %.2f \n",DRV_cg.get_coverage());
    $display("-------------------------------------------- ");

   endtask

endclass
