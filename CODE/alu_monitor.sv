
`include "defines.sv"
class alu_monitor;
  alu_transaction mon_trans;
  mailbox #(alu_transaction) mbx_ms;
  virtual alu_if.MON vif;


 covergroup MON_output_cg;
                coverpoint mon_trans.RES { bins result[]={[0:(2**`OP_WIDTH)-1]};}
                coverpoint mon_trans.COUT{ bins cout_active = {1};
                                           bins cout_inactive = {0};
                                                                 }
                coverpoint mon_trans.OFLOW { bins oflow_active = {1};
                                             bins oflow_inactive = {0};
                                                                   }
                coverpoint mon_trans.ERR { bins error_active = {1};
                                           bins error_inactive = {0};
                                                                 }
                coverpoint mon_trans.G { bins greater_active = {1};
                                         bins greater_inactive = {0};
                                                                 }
                coverpoint mon_trans.E { bins equal_active = {1};
                                         bins equal_inactive = {0};
                                                                 }
                coverpoint mon_trans.L { bins lesser_active = {1};
                                         bins lesser_inactive = {0};
                                                                 }
 endgroup


  function new( virtual alu_if.MON vif,
                mailbox #(alu_transaction) mbx_ms);
    this.vif=vif;
    this.mbx_ms=mbx_ms;
    MON_output_cg = new();
  endfunction

  task start();
//     mon_trans = new();
    repeat(5) @(vif.mon_cb);
    for(int i=0;i<`no_of_trans;i++)
      begin
        mon_trans=new();

        // Check if command is 9 or 10 for timing decision
        if ( vif.mon_cb.MODE && vif.mon_cb.CMD inside {'d9, 'd10} ) begin
          repeat(2) @(vif.mon_cb);
        end
        else begin
          repeat(1) @(vif.mon_cb);
        end

        #0;
        begin
          mon_trans.ERR=vif.mon_cb.ERR;
          mon_trans.RES=vif.mon_cb.RES;
          mon_trans.OFLOW=vif.mon_cb.OFLOW;
          mon_trans.COUT=vif.mon_cb.COUT;
          mon_trans.G=vif.mon_cb.G;
          mon_trans.L=vif.mon_cb.L;
          mon_trans.E=vif.mon_cb.E;
        end

        $display("[MONITOR MODEL] @%0t:MONITOR PASSING THE DATA TO SCOREBOARD    ERR=%d,RES=%d,OFLOW=%d,COUT=%d,G=%d,L=%d,E=%d",$time,mon_trans.ERR,mon_trans.RES,mon_trans.OFLOW,mon_trans.COUT,mon_trans.G,mon_trans.L,mon_trans.E);

        mbx_ms.put(mon_trans);

        MON_output_cg.sample();
        $display("MONITOR OUTPUT FUNCTIONAL COVERAGE = %.2f", MON_output_cg.get_coverage());
      end
    repeat(2)@(vif.mon_cb);
    $display("---------MONITOR OUTPUT COVERAGE------------\n ");
    $display("TOTAL = %.2f \n",MON_output_cg.get_coverage());
    $display("-------------------------------------------- ");



endtask
endclass
