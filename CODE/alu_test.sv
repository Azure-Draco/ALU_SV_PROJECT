

class alu_test;
  virtual alu_if drv_vif;
  virtual alu_if mon_vif;
  virtual alu_if ref_vif;
  alu_environment env;

  function new(virtual alu_if drv_vif,
               virtual alu_if mon_vif,
               virtual alu_if ref_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
    this.ref_vif=ref_vif;
  endfunction

  task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build();
    env.start();
  endtask
endclass

//-------------------------------------------------------------------------------------------------

class test1 extends alu_test;
 MODE_CHECK1  trans1;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("MODE_CHECK1");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans1 = new();
    env.gen.blueprint= trans1;
    end
    env.start;
  endtask
endclass


class test2 extends alu_test;
 MODE_CHECK0 trans2;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("MODE_CHECK0");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans2 = new();
    env.gen.blueprint= trans2;
    end
    env.start;
  endtask
endclass


class test3 extends alu_test;
 CMD_MUL_ONLY_CHECK trans3;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("CMD_MUL_ONLY_CHECK");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans3 = new();
    env.gen.blueprint= trans3;
    end
    env.start;
  endtask
endclass

class test4 extends alu_test;
 CE_LOW trans4;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("CE_LOW");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans4 = new();
    env.gen.blueprint= trans4;
    end
    env.start;
  endtask
endclass

class test5 extends alu_test;
 INP_VALID_0 trans5;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("INP_VALID_0");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans5 = new();
    env.gen.blueprint= trans5;
    end
    env.start;
  endtask
endclass

class test6 extends alu_test;
 INP_VALID_1 trans6;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("INP_VALID_1");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans6 = new();
    env.gen.blueprint= trans6;
    end
    env.start;
  endtask
endclass


class test7 extends alu_test;
 INP_VALID_2 trans7;
  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    $display("INP_VALID_2");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
    trans7 = new();
    env.gen.blueprint= trans7;
    end
    env.start;
  endtask
endclass



//*****************************************************************************************************************************************
class test_regression extends alu_test;

 arith_0 trans8;
 arith_1 trans9;
 arith_2 trans10;
 arith_3 trans11;
 arith_4 trans12;
 arith_5 trans13;
 arith_6 trans14;
 arith_7 trans15;
 arith_8 trans16;
 arith_9 trans17;
 arith_10 trans18;

 logic_0 trans19;
 logic_1 trans20;
 logic_2 trans21;
 logic_3 trans22;
 logic_4 trans23;
 logic_5 trans24;
 logic_6 trans25;
 logic_7 trans26;
 logic_8 trans27;
 logic_9 trans28;
 logic_10 trans29;
 logic_11 trans30;
 logic_12 trans31;
 logic_13 trans32;




  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    //$display("child test");
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;

///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans8 = new();
    env.gen.blueprint= trans8;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans9 = new();
    env.gen.blueprint= trans9;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans10 = new();
    env.gen.blueprint= trans10;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans11 = new();
    env.gen.blueprint= trans11;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans12 = new();
    env.gen.blueprint= trans12;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans13 = new();
    env.gen.blueprint= trans13;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans14 = new();
    env.gen.blueprint= trans14;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans15 = new();
    env.gen.blueprint= trans15;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans16 = new();
    env.gen.blueprint= trans16;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans17 = new();
    env.gen.blueprint= trans17;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans18 = new();
    env.gen.blueprint= trans18;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans19 = new();
    env.gen.blueprint= trans19;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans20 = new();
    env.gen.blueprint= trans20;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans21 = new();
    env.gen.blueprint= trans21;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans22 = new();
    env.gen.blueprint= trans22;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans23 = new();
    env.gen.blueprint= trans23;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans24 = new();
    env.gen.blueprint= trans24;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans25 = new();
    env.gen.blueprint= trans25;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans26 = new();
    env.gen.blueprint= trans26;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans27 = new();
    env.gen.blueprint= trans27;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans28 = new();
    env.gen.blueprint= trans28;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans29 = new();
    env.gen.blueprint= trans29;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans30 = new();
    env.gen.blueprint= trans30;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans31 = new();
    env.gen.blueprint= trans31;
    end
    env.start;
//////////////////////////////////////////////////////

///////////////////////////////////////////////////////
    begin
    trans32 = new();
    env.gen.blueprint= trans32;
    end
    env.start;
//////////////////////////////////////////////////////

 endtask
endclass
