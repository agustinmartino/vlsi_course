module bit_sync (
  input  i_data,
  input  i_clock,
  output o_data
);
  
  wire delayed_bit;
  reg  data_dm;  //Data Metastable
  reg  data_ms;  //Metastability Settled

  random_delay_bits #(
    .NB_IN(1),
    .MIN_DELAY(1),
    .MAX_DELAY(15)
  ) 
  u_delay (
    .i_data(i_data),
    .o_data(delayed_bit)
  );

  always @(posedge i_clock)
  begin
    data_dm <= delayed_bit;
    data_ms <= data_dm;
  end

  
  assign o_data = data_ms;
  
endmodule