module ff (
  input i_data,
  input i_clock_a,
  input i_clock_b,
  output o_data
);
  
  
  reg data_reg_a;
  reg data_reg_b;
  wire data_delay;

  always @(posedge i_clock_a)
    begin
      data_reg_a <= i_data;
    end
  
  random_delay_bits #(
    .NB_IN(1),
    .MIN_DELAY(5),
    .MAX_DELAY(5)
  ) 
  u_delay (
    .i_data(data_reg_a),
    .o_data(data_delay)
  );
  
  
  always @(posedge i_clock_b)
    begin
      data_reg_b <= data_delay;
    end

  
  assign o_data = data_reg_b;
  
endmodule