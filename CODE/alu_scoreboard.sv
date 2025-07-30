

`include "defines.sv"
class alu_scoreboard;

   alu_transaction ref2sb_trans,mon2sb_trans;
  mailbox #(alu_transaction) mbx_rs;
  mailbox #(alu_transaction) mbx_ms;

//    int MATCH = 0 ,MISMATCH = 0;


   // Individual field counters
   int RES_match = 0, RES_mismatch = 0;
   int ERR_match = 0, ERR_mismatch = 0;
   int COUT_match = 0, COUT_mismatch = 0;
   int OFLOW_match = 0, OFLOW_mismatch = 0;
   int G_match = 0, G_mismatch = 0;
   int L_match = 0, L_mismatch = 0;
   int E_match = 0, E_mismatch = 0;

   // Overall counters
   int overall_match = 0, overall_mismatch = 0;
   int total_transactions = 0;


  function new(mailbox #(alu_transaction) mbx_rs,
               mailbox #(alu_transaction) mbx_ms);
    this.mbx_rs=mbx_rs;
    this.mbx_ms=mbx_ms;
  endfunction

  task start();
    for(int i=0; i<`no_of_trans ; i++)
      begin
//         ref2sb_trans=new();
//         mon2sb_trans=new();
        fork
          begin
           #0 mbx_rs.get(ref2sb_trans);

            $display("[SCOREBOARD MODEL] @%0t:############ SCOREBOARD REF RES=%0d, ###############",$time,ref2sb_trans.RES);


           #0 mbx_ms.get(mon2sb_trans);

            $display("[SCOREBOARD MODEL] @%0t:!!!!!!!!!!!!! SCOREBOARD MON RES=%0d, !!!!!!!!!!!!!!",$time,mon2sb_trans.RES,$time);

          end
       join
        total_transactions++;
        compare_report();
      end
  endtask



   task compare_report();
     bit all_fields_match = 1'b1;

     fork
       // Compare RES field
       begin
         if(mon2sb_trans.RES === ref2sb_trans.RES) begin
           RES_match++;
           $display("Result Match Successful @%0t: Monitor RES=%0d, Reference model RES=%0d",
                 $time, mon2sb_trans.RES, ref2sb_trans.RES);
         end else begin
           RES_mismatch++;
           all_fields_match = 1'b0;
           $display("Result Match Unsuccessful @%0t: Monitor RES=%0d, Reference model RES=%0d",
                  $time, mon2sb_trans.RES, ref2sb_trans.RES);
         end
       end

       // Compare ERR field
       begin
         if(mon2sb_trans.ERR === ref2sb_trans.ERR) begin
           ERR_match++;
           $display("Error Match Successful @%0t: Monitor ERR=%0d, Reference model ERR=%0d",
                   $time,mon2sb_trans.ERR, ref2sb_trans.ERR);
         end else begin
           ERR_mismatch++;
           all_fields_match = 1'b0;
           $display("Error Match Unsuccessful @%0t: Monitor ERR=%0d, Reference model ERR=%0d",
                  $time, mon2sb_trans.ERR, ref2sb_trans.ERR);
         end
       end

       // Compare COUT field
       begin
         if(mon2sb_trans.COUT === ref2sb_trans.COUT) begin
           COUT_match++;
           $display("Carry out Match Successful @%0t: Monitor COUT=%0d, Reference model COUT=%0d",
                   $time,mon2sb_trans.COUT, ref2sb_trans.COUT);
         end else begin
           COUT_mismatch++;
           all_fields_match = 1'b0;
           $display("Carry out Match Unsuccessful @%0t: Monitor COUT=%0d, Reference model COUT=%0d",
                   $time,mon2sb_trans.COUT, ref2sb_trans.COUT);
         end
       end

       // Compare OFLOW field
       begin
         if(mon2sb_trans.OFLOW === ref2sb_trans.OFLOW) begin
           OFLOW_match++;
           $display("Overflow Match Successful @%0t: Monitor OFLOW=%0d, Reference model OFLOW=%0d",
                   $time,mon2sb_trans.OFLOW, ref2sb_trans.OFLOW);
         end else begin
           OFLOW_mismatch++;
           all_fields_match = 1'b0;
           $display("Overflow Match Unsuccessful @%0t: Monitor OFLOW=%0d, Reference model OFLOW=%0d",
                  $time, mon2sb_trans.OFLOW, ref2sb_trans.OFLOW);
         end
       end

       // Compare G field
       begin
         if(mon2sb_trans.G === ref2sb_trans.G) begin
           G_match++;
           $display("Greater Match Successful @%0t: Monitor G=%0d, Reference model G=%0d",
                  $time, mon2sb_trans.G, ref2sb_trans.G);
         end else begin
           G_mismatch++;
           all_fields_match = 1'b0;
           $display("Greater Match Unsuccessful @%0t: Monitor G=%0d, Reference model G=%0d",
                   $time,mon2sb_trans.G, ref2sb_trans.G);
         end
       end

       // Compare L field
       begin
         if(mon2sb_trans.L === ref2sb_trans.L) begin
           L_match++;
           $display("Lesser Match Successful @%0t: Monitor L=%0d, Reference model L=%0d",
                  $time, mon2sb_trans.L, ref2sb_trans.L);
         end else begin
           L_mismatch++;
           all_fields_match = 1'b0;
           $display("Lesser Match Unsuccessful @%0t: Monitor L=%0d, Reference model L=%0d",
                   $time,mon2sb_trans.L, ref2sb_trans.L);
         end
       end

       // Compare E field
       begin
         if(mon2sb_trans.E === ref2sb_trans.E) begin
           E_match++;
           $display("Equal Match Successful @%0t: Monitor E=%0d, Reference model E=%0d",
                   $time,mon2sb_trans.E, ref2sb_trans.E);
         end else begin
           E_mismatch++;
           all_fields_match = 1'b0;
           $display("Equal Match Unsuccessful @%0t: Monitor E=%0d, Reference model E=%0d",
                  $time, mon2sb_trans.E, ref2sb_trans.E);
         end
       end
     join

     // Overall comparison
     if (all_fields_match) begin
       overall_match++;
       $display("Overall Match Successful %0d at time %0t", overall_match, $time);
     end else begin
       overall_mismatch++;
       $display("Overall Match Unsuccessful %0d at time %0t", overall_mismatch, $time);
     end

     $display("----------------------------------------");
   endtask

   task print_summary();
     $display("\n=== SCOREBOARD SUMMARY ===");
     $display("Total Transactions: %0d", total_transactions);
     $display("Overall Matches: %0d", overall_match);
     $display("Overall Mismatches: %0d", overall_mismatch);
     $display("Success Rate: %.2f%%", (real'(overall_match) / real'(total_transactions)) * 100.0);

     $display("\n--- Field-wise Statistics ---");
     $display("TIME: @%0t",$time);
     $display("RES  - Match: %0d, Mismatch: %0d", RES_match, RES_mismatch);
     $display("ERR  - Match: %0d, Mismatch: %0d", ERR_match, ERR_mismatch);
     $display("COUT - Match: %0d, Mismatch: %0d", COUT_match, COUT_mismatch);
     $display("OFLOW- Match: %0d, Mismatch: %0d", OFLOW_match, OFLOW_mismatch);
     $display("G    - Match: %0d, Mismatch: %0d", G_match, G_mismatch);
     $display("L    - Match: %0d, Mismatch: %0d", L_match, L_mismatch);
     $display("E    - Match: %0d, Mismatch: %0d", E_match, E_mismatch);
     $display("==========================\n");
   endtask

endclass
