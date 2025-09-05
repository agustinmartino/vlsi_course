module fir_serial #(
  NB_IN = 8,
  NB_COEFFS = 8,
  N_COEFFS = 8,
  NB_OUT = NB_IN + NB_COEFFS + $clog2(N_COEFFS)
)
( 
  input signed [NB_IN -1 : 0] i_data,
  input [NB_COEFFS*N_COEFFS -1 : 0] i_coeffs,
  input i_clock,
  output signed [NB_OUT-1 : 0] o_data
);

  localparam NB_PROD = NB_IN + NB_COEFFS;
  
  reg signed [NB_IN -1 : 0] shift_reg [N_COEFFS-1 -1 : 0];
  
  reg signed [NB_OUT -1 : 0] data_sum;
  
  reg signed [NB_PROD -1 : 0] prod;
  
  integer i;
  
  always @(posedge i_clock)
  begin
    
    shift_reg[0] <= $signed(i_data);
        
    for(i=1; i<N_COEFFS-1; i=i+1)
    begin: shift_reg_for
      shift_reg[i] <= shift_reg[i-1];
    end
    
  end
  
  integer j;
  
  always@(*)
  begin
    data_sum = i_data*$signed(i_coeffs[NB_COEFFS-1 : 0]);
    for(j=1; j<N_COEFFS; j=j+1)
    begin: data_accum
      prod = shift_reg[j-1]*$signed(i_coeffs[(j+1)*NB_COEFFS -1-: NB_COEFFS]);
      data_sum = data_sum + prod;
    end
  end
  
  assign o_data = data_sum;
  
endmodule