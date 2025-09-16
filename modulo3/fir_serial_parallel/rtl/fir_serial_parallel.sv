module fir_serial_parallel #(
  NB_IN = 8,
  NB_COEFFS = 8,
  N_COEFFS = 8,
  PARALLELISM = 2,
  NB_OUT = NB_IN + NB_COEFFS + $clog2(N_COEFFS)
)
( 
  input signed [NB_IN -1 : 0] i_data,
  input signed [NB_COEFFS -1 : 0] i_coeffs [N_COEFFS-1 : 0],
  input i_reset,
  input i_clock,
  output signed [NB_OUT-1 : 0] o_data
);
      
  //Clock divider
  reg gen_clock;
  always @(posedge i_clock or posedge i_reset) 
  begin
    if (i_reset)
        gen_clock = i_clock;
    else
        gen_clock = ~gen_clock;  // invierte el estado cada flanco de subida
  end
  
  reg signed [NB_IN  -1 : 0] buffer_in  [PARALLELISM -1 : 0];
  wire signed [NB_OUT -1 : 0] buffer_out [PARALLELISM -1 : 0];
  reg counter;
  
  always @(posedge i_clock or posedge i_reset) 
  begin
	if (i_reset)
    begin
      counter <= 1'b0;
    end
    else
    begin 
      buffer_in[counter] <= i_data;
      counter <= counter + 1'b1;
    end
  end
  
  fir_parallel u_fir_parallel(
    .i_data(buffer_in),
    .i_coeffs(i_coeffs),
    .i_clock(gen_clock),
    .o_data(buffer_out)
  );
  
  assign o_data = buffer_out[counter];
  
endmodule