module counter #(
  parameter WIDTH = 4
)
(
  output logic [WIDTH-1:0] rcount,
  input  logic [WIDTH-1:0] wcount,
  input                    rclk,
  input                    wclk
  
);

logic [WIDTH-1:0] count_gray;
logic [WIDTH-1:0] count_delay;
logic [WIDTH-1:0] count_dm;
logic [WIDTH-1:0] count_ms;

bin2gray #(
  .SIZE(WIDTH)
)
u_bin2gray
(
  .bin(wcount),
  .gray(count_gray)
);

genvar i;

  generate
  for (i = 0; i<WIDTH; i = i+1)
  begin
    random_delay_bits #(
      .NB_IN(1),
      .MIN_DELAY(1),
      .MAX_DELAY(3)
    ) 
    u_delay (
      .i_data(count_gray[i]),
      .o_data(count_delay[i])
    );
  end
endgenerate

always @(posedge rclk)
begin
  count_dm <= count_delay;
  count_ms <= count_dm;
end

gray2bin #(
  .SIZE(WIDTH)
)
u_gray2bin
(
  .gray(count_ms),
  .bin(rcount)
);
    
endmodule