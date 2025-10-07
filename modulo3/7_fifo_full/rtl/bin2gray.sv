module bin2gray #(
  parameter SIZE = 4
)
(
  output logic [SIZE-1:0] gray,
  input logic [SIZE-1:0] bin
);

assign gray = (bin>>1) ^ bin;

endmodule