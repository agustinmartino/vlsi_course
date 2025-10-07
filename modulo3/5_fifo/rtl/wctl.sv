module wctl (
 output logic wrdy, wptr, we,
 input logic wput, wq2_rptr,
 input logic wclk, wrst_n);

 assign we = wrdy & wput;
 assign wrdy = ~(wq2_rptr ^ wptr);

 always_ff @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wptr <= '0;
    else wptr <= wptr ^ we;
    
endmodule