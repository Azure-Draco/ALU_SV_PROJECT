
`include "defines.sv"
class alu_transaction;

//   logic [1:0] INP_VALID = 'b11;
//    logic CE=1;
//    logic MODE=1;
//   logic [`CMD_WIDTH-1:0] CMD=9;

  rand logic [1:0] INP_VALID;
  rand logic CE;
  rand logic MODE;
  randc logic [`CMD_WIDTH-1:0] CMD;
  rand logic CIN;
  rand logic [`OP_WIDTH-1:0] OPA,OPB;


  logic ERR;
  logic [`OP_WIDTH +1 :0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;

  constraint signals   { CE == 1; }

//   constraint mul_test{ MODE == 1 ; CMD == 9; CE == 1;INP_VALID == 3;}

  //   constraint CE_1{CE==1;}


//   constraint valid_CMD{if(MODE==1)
//                              CMD inside {5};
//                        else
//                              CMD inside {[0:13]};
//                       }

//   constraint valid_INP_VALID{INP_VALID inside {3};
//                             CE == 1;}
//   constraint valid_MODE{MODE inside {1};}


 virtual function alu_transaction copy();
  copy = new();
  copy.INP_VALID=this.INP_VALID;
  copy.CE=this.CE;
  copy.MODE=this.MODE;
  copy.CIN=this.CIN;
  copy.CMD=this.CMD;
  copy.OPA=this.OPA;
  copy.OPB=this.OPB;
  return copy;
  endfunction
endclass


//---------------------------------------------------------------------------------------------------------
//MODE CHECK 1 Arithmetic

class MODE_CHECK1 extends alu_transaction;
            constraint valid_CMD{if(MODE==1)
          CMD inside {[0:8]};
                       else
                         CMD inside {[0:13]};}

  constraint valid_INP_VALID{INP_VALID inside {3};
                            CE == 1;}
  constraint valid_MODE{MODE inside {1};}

        virtual function alu_transaction copy();
        MODE_CHECK1 copy1;
        copy1 = new();
        copy1.INP_VALID = this.INP_VALID;
        copy1.MODE = this.MODE;
        copy1.CMD = this.CMD;
        copy1.CE = this.CE;
        copy1.OPA = this.OPA;
        copy1.OPB = this.OPB;
        copy1.CIN = this.CIN;
        return copy1;
    endfunction
endclass

//MODE CHECK 0 Logical
class MODE_CHECK0 extends alu_transaction;
  constraint valid_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};
    else
      CMD inside {[0:8]};
  }

  constraint valid_INP_VALID {
    INP_VALID inside {3};
    CE == 1;
  }

  constraint valid_MODE {
    MODE inside {0};
  }

  virtual function alu_transaction copy();
    MODE_CHECK0 copy0;
    copy0 = new();
    copy0.INP_VALID = this.INP_VALID;
    copy0.MODE = this.MODE;
    copy0.CMD = this.CMD;
    copy0.CE = this.CE;
    copy0.OPA = this.OPA;
    copy0.OPB = this.OPB;
    copy0.CIN = this.CIN;
    return copy0;
  endfunction
endclass



// MUL only
class CMD_MUL_ONLY_CHECK extends alu_transaction;
  constraint MUL_CMD_ONLY {
    CMD inside {9, 10};
  }

  constraint MODE_ARITHMETIC {
    MODE == 1;
  }

  constraint VALID_INP {
    INP_VALID == 3;
    CE == 1;
  }

  virtual function alu_transaction copy();
    CMD_MUL_ONLY_CHECK copy_mul;
    copy_mul = new();
    copy_mul.INP_VALID = this.INP_VALID;
    copy_mul.MODE = this.MODE;
    copy_mul.CMD = this.CMD;
    copy_mul.CE = this.CE;
    copy_mul.OPA = this.OPA;
    copy_mul.OPB = this.OPB;
    copy_mul.CIN = this.CIN;
    return copy_mul;
  endfunction
endclass




//CE LOW
class CE_LOW extends alu_transaction;

  // Constraint: CE must be 0
  constraint CE_ZER {
    CE == 0;
  }

  // Constraint: CMD between 0 and 13
  constraint VALID_CMD {
    if (MODE == 0)
      CMD inside {[0:13]};
    else
      CMD inside {[0:8]};
  }



  constraint VALID_INP {
    INP_VALID inside {3};
  }


  constraint mode_range {
    MODE inside {0, 1};
  }


  virtual function alu_transaction copy();
    CE_LOW c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction

endclass

//INP_VALID 00
class INP_VALID_0 extends alu_transaction;

  constraint INP_INVALID_00 {
    INP_VALID == 0;
  }

  virtual function alu_transaction copy();
    INP_VALID_0 c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction

endclass


//INP_VALID = 01
class INP_VALID_1 extends alu_transaction;

  constraint INP_VALID_01 {
    INP_VALID == 1;
  }

  virtual function alu_transaction copy();
    INP_VALID_1 c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction

endclass

// INP_VALID = 10
class INP_VALID_2 extends alu_transaction;

  constraint INP_VALID_10 {
    INP_VALID == 2;
  }

  virtual function alu_transaction copy();
    INP_VALID_2 c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.CE        = this.CE;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    return c;
  endfunction

endclass



class arith_0 extends alu_transaction;

  constraint logical_com { CMD == 0 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_0 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class arith_1 extends alu_transaction;

  constraint logical_com { CMD == 1 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_1 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_2 extends alu_transaction;

  constraint logical_com { CMD == 2 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_2 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_3 extends alu_transaction;

  constraint logical_com { CMD == 3 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_3 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_4 extends alu_transaction;

  constraint logical_com { CMD == 4 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_4 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_5 extends alu_transaction;

  constraint logical_com { CMD == 5 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_5 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_6 extends alu_transaction;

  constraint logical_com { CMD == 6 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_6 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_7 extends alu_transaction;

  constraint logical_com { CMD == 7 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_7 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_8 extends alu_transaction;

  constraint logical_com { CMD == 8 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_8 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_9 extends alu_transaction;

  constraint logical_com { CMD == 9 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_9 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

class arith_10 extends alu_transaction;

  constraint com { CMD == 10 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    arith_10 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass

//--------------------LOGICAL--------------------------------

class logic_0 extends alu_transaction;

  constraint logical_com { CMD == 0 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_0 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass



class logic_1 extends alu_transaction;

  constraint logical_com { CMD == 1 ; }
  constraint MODE_val  { MODE == 1; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_1 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_2 extends alu_transaction;

  constraint logical_com { CMD == 2 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_2 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_3 extends alu_transaction;

  constraint logical_com { CMD == 3 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_3 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_4 extends alu_transaction;

  constraint logical_com { CMD == 4 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_4 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_5 extends alu_transaction;

  constraint logical_com { CMD == 5 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_5 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_6 extends alu_transaction;

  constraint logical_com { CMD == 6 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_6 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_7 extends alu_transaction;

  constraint logical_com { CMD == 7 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_7 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_8 extends alu_transaction;

  constraint logical_com { CMD == 8 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_8 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_9 extends alu_transaction;

  constraint logical_com { CMD == 9 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_9 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_10 extends alu_transaction;

  constraint logical_com { CMD == 10 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_10 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_11 extends alu_transaction;

  constraint logical_com { CMD == 11 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_11 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_12 extends alu_transaction;

  constraint logical_com { CMD == 12 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_12 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass


class logic_13 extends alu_transaction;

  constraint logical_com { CMD == 13 ; }
  constraint MODE_val  { MODE == 0; }
  constraint inp_val   { INP_VALID == 3; CE == 1; }

  virtual function alu_transaction copy();
    logic_13 c;
    c = new();
    c.INP_VALID = this.INP_VALID;
    c.MODE      = this.MODE;
    c.CMD       = this.CMD;
    c.OPA       = this.OPA;
    c.OPB       = this.OPB;
    c.CIN       = this.CIN;
    c.CE        = this.CE;

    return c;
  endfunction
endclass
