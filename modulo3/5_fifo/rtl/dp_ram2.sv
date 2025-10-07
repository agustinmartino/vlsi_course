module dp_ram2 #(
  parameter type dat_t = logic [7:0]
)
(output dat_t q,
input dat_t d,
input logic waddr, raddr, we, clk
);

dat_t mem [0:1];
always_ff @(posedge clk)
  if (we) mem[waddr] <= d;

assign q = mem[raddr];
endmodule
