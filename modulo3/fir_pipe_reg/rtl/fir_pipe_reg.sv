module fir_pipe_reg #(
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

  reg [NB_COEFFS*N_COEFFS -1 : 0] coeffs_reg;
  reg signed [NB_IN       -1 : 0] data_reg;
  reg signed [NB_OUT      -1 : 0] data_out_reg;
  
  integer i;
  
  always @(posedge i_clock)
  begin

    coeffs_reg   <= i_coeffs;
    data_reg     <= i_data;
    data_out_reg <= data_sum;
    
    shift_reg[0] <= data_reg;
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
    shift_reg_pipe <= shift_reg[2];
    shift_reg[3] <= shift_reg_pipe;
    shift_reg[4] <= shift_reg[3];
    shift_reg[5] <= shift_reg[4];
    shift_reg[6] <= shift_reg[5];
    
    data_sum_pipe <= data_reg*$signed(coeffs_reg[NB_COEFFS-1 : 0]) + shift_reg[0]*$signed(coeffs_reg[(2*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[1]*$signed(coeffs_reg[(3*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[2]*$signed(coeffs_reg[(4*NB_COEFFS)-1 -: NB_COEFFS]);
    
    
  end
  
  integer j;
  
  always@(*)
  begin
                                                                                                                                               
    data_sum = data_sum_pipe + shift_reg[3]*$signed(coeffs_reg[(5*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[4]*$signed(coeffs_reg[(6*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[5]*$signed(coeffs_reg[(7*NB_COEFFS)-1 -: NB_COEFFS]) + shift_reg[6]*$signed(coeffs_reg[(8*NB_COEFFS)-1 -: NB_COEFFS]);
    
  end
  
  assign o_data = data_out_reg;
  
endmodule