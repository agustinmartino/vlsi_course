module sel_coeffs #(
    parameter NB = 8
)
(
    input  [NB-1 : 0] i_coeffs_a,
    input  [NB-1 : 0] i_coeffs_b,
    input             i_sel,
    input             i_clock_a,
    input             i_clock_b,
    input             i_reset,
    output [NB-1 : 0] o_coeffs
);

reg [NB-1 : 0] coeffs_a_reg;
reg [NB-1 : 0] coeffs_b_reg;
reg [NB-1 : 0] coeffs_dly;
reg sel_reg;
reg sel_reg_d;
reg valid;
reg sel_dly;
reg sel_sync;
wire [NB-1 : 0] coeffs_sync;
reg [NB-1 : 0] coeffs_reg;




always @(posedge i_clock_a)
begin
    if(i_reset)
    begin
        coeffs_a_reg <= {NB {1'b0}};
        coeffs_b_reg <= {NB {1'b0}};
        sel_reg <= 1'b0;
        sel_reg_d <= 1'b0;
    end
    else
    begin
        coeffs_a_reg <= i_coeffs_a;
        coeffs_b_reg <= i_coeffs_b;
        sel_reg <= i_sel;
        sel_reg_d <= sel_reg;
    end
end

always @(posedge i_clock_a)
begin
    if(sel_reg == 1'b0)
    begin
        coeffs_reg <= coeffs_a_reg;
    end
    else
    begin
        coeffs_reg <= coeffs_b_reg;
    end
    valid <= sel_reg ^ sel_reg_d;
end


mb_sync #(
  .NB(8)
)
u_mb_sync
(
  .i_data(coeffs_reg),
  .i_valid(valid),
  .i_reset(i_reset),
  .i_src_clock(i_clock_a),  
  .i_dest_clock(i_clock_b),
  .o_data(coeffs_sync)
);


assign o_coeffs = coeffs_sync;

endmodule