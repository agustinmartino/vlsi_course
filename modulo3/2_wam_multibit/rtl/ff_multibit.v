module ff_multibit #(
  NB = 8
) 
(
  input  [NB - 1 : 0] i_data,
  input               i_clock,
  output [NB - 1 : 0] o_data
);
  
  reg  [NB - 1 : 0] data_reg;
  wire [NB - 1 : 0] data_delay;
  
  genvar i;

  generate
    for (i = 0; i<NB; i = i+1)
    begin
      random_delay_bits #(
        .NB_IN(1),
        .MIN_DELAY(1),
        .MAX_DELAY(3)
      ) 
      u_delay (
        .i_data(i_data[i]),
        .o_data(data_delay[i])
      );
    end
  endgenerate
  
  
  always @(posedge i_clock)
  begin
    data_reg <= data_delay;
  end

  
  assign o_data = data_reg;
  
endmodule