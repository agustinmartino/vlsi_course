module fifo #(
  parameter NB_DATA = 4,
  parameter DEPTH = 8
)
(
  input  [NB_DATA-1:0] i_data,
  input                i_reset,
  input                i_rclk,
  input                i_wclk,
  output [NB_DATA-1:0] o_data,
  output               o_full,
  output               o_empty
);

localparam NB_POINTER = $clog2(DEPTH);

reg  [NB_POINTER-1 : 0] wptr;
wire [NB_POINTER-1 : 0] wptr_gray;
wire [NB_POINTER-1 : 0] wptr_rdom;
wire [NB_POINTER-1 : 0] wptr_rdom_bin;
reg  [NB_POINTER-1 : 0] rptr;
reg  [NB_POINTER-1 : 0] rptr_gray;
reg  [NB_POINTER-1 : 0] rptr_wdom;
reg  [NB_POINTER-1 : 0] rptr_wdom_bin;

reg empty;
reg full;

wire wdom_reset;
wire rdom_reset;

reg [NB_DATA-1:0] fifo_data [DEPTH-1:0];

sync u_rdom_reset_sync (
  .i_data(i_reset),
  .i_clock(i_rclk),
  .o_data(rdom_reset)
);

sync u_wdom_reset_sync (
  .i_data(i_reset),
  .i_clock(i_wclk),
  .o_data(wdom_reset)
);

bin2gray #(
  .SIZE(NB_POINTER)
)
u_bin2gray_wptr
(
  .bin (wptr),
  .gray(wptr_gray)
);

genvar w;
generate
for(w = 0; w<NB_POINTER; w=w+1)
begin
  sync u_wptr_sync (
    .i_data(wptr_gray[w]),
    .i_clock(i_rclk),
    .o_data(wptr_rdom[w])
  );
end
endgenerate

gray2bin #(
  .SIZE(NB_POINTER)
)
u_gray2bin_wptr
(
  .gray(wptr_rdom),
  .bin(wptr_rdom_bin)
);


always @(posedge i_rclk)
begin
  if(rdom_reset)
    empty = 1'b0;
  else if(wptr_rdom_bin == rptr)
    empty = 1'b1;
end

assign o_empty = empty;

bin2gray #(
  .SIZE(NB_POINTER)
)
u_bin2gray_rptr
(
  .bin (rptr),
  .gray(rptr_gray)
);

genvar r;
generate
for(r = 0; r<NB_POINTER; r=r+1)
begin
  sync u_rptr_sync (
    .i_data(rptr_gray[r]),
    .i_clock(i_wclk),
    .o_data(rptr_wdom[r])
  );
end
endgenerate

gray2bin #(
  .SIZE(NB_POINTER)
)
u_gray2bin_rptr
(
  .gray(rptr_wdom),
  .bin(rptr_wdom_bin)
);

always @(posedge i_wclk)
begin
  if(wdom_reset)
    full = 1'b0;
  else if(rptr_wdom_bin == wptr)
    full = 1'b1;
end

assign o_full = full;

always @(posedge i_wclk)
begin
  if(wdom_reset)
  begin
    wptr <= {NB_POINTER {1'b0}};
  end
  else
  begin
    wptr <= wptr + 1'b1;
  end
end

always @(posedge i_wclk)
begin
  fifo_data[wptr] <= i_data;
end

always @(posedge i_rclk)
begin
  if(rdom_reset)
  begin
    rptr <= {1'b0, {NB_POINTER-1 {1'b1}}};
  end
  else
  begin
    rptr <= rptr + 1'b1;
  end
end

assign o_data = fifo_data[rptr];

endmodule
