
`include "defines.sv"
`include "define.v"
interface alu_if(input logic CLK,RST);

  logic [1:0] INP_VALID;
  logic CE;
  logic MODE;
  logic CIN;
  logic [`CMD_WIDTH-1:0] CMD;
  logic [`OP_WIDTH-1:0] OPA,OPB;


  logic ERR;
  logic [2*`OP_WIDTH:0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;



  clocking drv_cb@(posedge CLK);
    default input #0 output #0;
    output CE,CIN,INP_VALID,MODE,CMD,OPA,OPB;
    input RST;
  endclocking

  clocking mon_cb@(posedge CLK);
    default input #0 output #0;
    input ERR,RES,OFLOW,COUT,G,L,E,RST,CMD,MODE;
  endclocking

  clocking ref_cb@(posedge CLK);
    default input #0 output #0;
  endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF_SB(clocking ref_cb);

  //1. Reset
  property ppt_reset;
          @(posedge CLK) RST |=> ##1 (RES == 9'bzzzzzzzz && ERR == 1'bz && E == 1'bz && G == 1'bz && L == 1'bz && COUT == 1'bz && OFLOW == 1'bz)
  endproperty
  assert property(ppt_reset)
    $display("RST assertion PASSED at time %0t", $time);
  else
    $info("RST assertion FAILED @ time %0t", $time);


  //2. 16- cycle TIMEOUT assertion
  property ppt_timeout_arithmetic;
    @(posedge CLK) disable iff(RST) (CE && (CMD == `ADD || CMD == `SUB || CMD == `ADD_CIN || CMD == `SUB_CIN || CMD == `MULT_SHIFT || CMD == `MULT_INC) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
  endproperty
    assert property(ppt_timeout_arithmetic)
  else $error("Timeout assertion failed at time %0t", $time);

      property ppt_timeout_logical;
        @(posedge CLK) disable iff(RST) (CE && (CMD == `AND || CMD == `OR || CMD == `NAND || CMD == `XOR || CMD == `XNOR || CMD == `NOR || CMD == `SHR1_A || CMD == `SHR1_B || CMD == `SHL1_A || CMD == `SHL1_B || CMD == `ROR_A_B  || CMD == `ROL_A_B) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
  endproperty
                                           assert property(ppt_timeout_logical)
  else $error("Timeout assertion failed at time %0t", $time);



  //3. ROR/ROL error
      assert property (@(posedge CLK) disable iff(RST) (CE && MODE && (CMD == `ROR_A_B || CMD == `ROL_A_B) && $countones(OPB) > `ROR_WIDTH + 1) |=> ##[1:3] ERR )
  else $info("NO ERROR FLAG RAISED");



  //4. CMD out of range
      assert property (@(posedge CLK) (MODE && CMD > 10) |=> ERR)
    else $info("CMD INVALID ERR NOT RAISED");


  //5. CMD out of range logical
        assert property (@(posedge CLK) (!MODE && CMD > 13) |=> ERR)
  else $info("CMD INVALID ERR NOT RAISED");


  //6.INP_VALID  assertion
  //property ppt_valid_inp_valid;
   // @(posedge clk) disable iff(RST) INP_VALID inside {2'b00, 2'b01, 2'b10, 2'b11};
  //endproperty
  //assert property(ppt_valid_inp_valid)
  //else $info("Invalid INP_VALID value: %b at time %0t", INP_VALID, $time);


  // 7. INP_VALID 00 case
          assert property (@(posedge CLK) (INP_VALID == 2'b00) |=> ERR )
  else $info("ERROR NOT raised");


  //8. CE assertion
  property ppt_clock_enable;
    @(posedge CLK) disable iff(RST) !CE |-> ##1 ($stable(RES) && $stable(COUT) && $stable(OFLOW) && $stable(G) && $stable(L) && $stable(E) && $stable(ERR));
  endproperty


  assert property(ppt_clock_enable)
  else $info("Clock enable assertion failed at time %0t", $time);

endinterface
