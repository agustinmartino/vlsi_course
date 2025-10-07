module rctl 
(
output logic rrdy, rptr,
input logic rget,rq2_wptr,
input logic rclk, rrst_n
);

typedef enum {xxx, VALID} status_e;
status_e status;

assign status = status_e'(rrdy);
assign rinc = rrdy & rget;
assign rrdy = (rq2_wptr ^ rptr);

always_ff @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rptr <= '0;
    else rptr <= rptr ^ rinc;
    
endmodule
