
`include "alu_pkg.sv"
`include "alu.sv"
`include "alu_if.sv"
`include "defines.sv"


module top( );
     import alu_pkg ::*;
    bit CLK=0;
    bit RST=0;

  initial
    begin
     forever #5 CLK=~CLK;
    end

  initial begin
    RST = 1;
    repeat(2) @(posedge CLK);
    RST = 0;
  end

  alu_if intrf(CLK,RST);

  ALU_DESIGN  #( .DW(`OP_WIDTH), .CW(`CMD_WIDTH) )
        DUV (  .OPA(intrf.OPA),
         .OPB(intrf.OPB),
         .INP_VALID(intrf.INP_VALID),
         .CIN(intrf.CIN),
         .CLK(intrf.CLK),
         .RST(intrf.RST),
         .CMD(intrf.CMD),
         .CE(intrf.CE),
         .MODE(intrf.MODE),
         .COUT(intrf.COUT),
         .OFLOW(intrf.OFLOW),
         .RES(intrf.RES),
         .G(intrf.G),
         .E(intrf.E),
         .L(intrf.L),
         .ERR(intrf.ERR) );

  //Instantiating the Test
//    alu_test tb = new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test1 tb1= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test2 tb2= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test3 tb3= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test4 tb4= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test5 tb5= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test6 tb6= new(intrf.DRV,intrf.MON,intrf.REF_SB);
       test7 tb7= new(intrf.DRV,intrf.MON,intrf.REF_SB);
    //   test8 tb8= new(intrf.DRV,intrf.MON,intrf.REF_SB);

    test_regression tb_regression= new(intrf.DRV,intrf.MON,intrf.REF_SB);

//Calling the test's run task which starts the execution of the testbench architecture
  initial
   begin

   //tb.run();
   tb1.run();
   tb2.run();
   tb3.run();
   tb4.run();
   tb5.run();
   tb6.run();
   tb7.run();
   //tb8.run();
   tb_regression.run();


    $finish();
   end
endmodule
