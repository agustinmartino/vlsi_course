module fir_pipe #(
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
  
  reg signed [NB_IN -1 : 0] shift_reg_pipe;
  
  reg signed [NB_OUT -1 : 0] data_sum;
  
  reg signed [NB_OUT -1 : 0] data_sum_pipe;
  
  reg signed [NB_PROD -1 : 0] prod;
  
  integer i;
  
  always @(posedge i_clock)
  begin
    
    shift_reg[0] <= $signed(i_data);
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
    shift_reg_pipe <= shift_reg[2];
    shift_reg[3] <= shift_reg_pipe;
    shift_reg[4] <= shift_reg[3];
    shift_reg[5] <= shift_reg[4];
    shift_reg[6] <= shift_reg[5];
    
    data_sum_pipe <= i_data*$signed(i_coeffs[NB_COEFFS-1 : 0]) + shift_reg[0]*$signed(i_coeffs[(2*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[1]*$signed(i_coeffs[(3*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[2]*$signed(i_coeffs[(4*NB_COEFFS)-1 -: NB_COEFFS]);
    
    
  end
  
  integer j;
  
  always@(*)
  begin
                                                                                                                                               
    data_sum = data_sum_pipe + shift_reg[3]*$signed(i_coeffs[(5*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[4]*$signed(i_coeffs[(6*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[5]*$signed(i_coeffs[(7*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[6]*$signed(i_coeffs[(8*NB_COEFFS)-1 -: NB_COEFFS]);
    
  end
  
  assign o_data = data_sum;
  
endmodule