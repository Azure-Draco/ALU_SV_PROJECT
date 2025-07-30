
`include "defines.sv"
class alu_generator;
  alu_transaction  blueprint;
  mailbox #(alu_transaction)mbx_gd;

  function new(mailbox #(alu_transaction)mbx_gd);
    this.mbx_gd=mbx_gd;
    blueprint=new();
  endfunction

  task start();
    for(int i=0;i<`no_of_trans;i++)
      begin
        void'(blueprint.randomize());
        mbx_gd.put(blueprint.copy());

        $display("[GENERATOR MODEL] @%0t:Randomized transaction CE=%d,CIN=%d,INP_VALID=%d,MODE=%d,CMD=%d,OPA=%d,OPB=%d",$time,blueprint.CE,blueprint.CIN,blueprint.INP_VALID,blueprint.MODE,blueprint.CMD,blueprint.OPA,blueprint.OPB);
      end
  endtask
endclass
