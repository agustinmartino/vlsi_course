module sync(
    input i_data,
    input i_clock,
    output o_data
);

reg ff_dm;
reg ff_ms;

always @(posedge i_clock)
begin
    ff_dm <= i_data;
    ff_ms <= ff_dm;
end

assign o_data = ff_ms;

endmodule