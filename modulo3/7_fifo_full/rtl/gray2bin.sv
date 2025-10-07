module gray2bin #(
  parameter SIZE = 4
)
(
  output logic [SIZE-1:0] bin,
  input  logic [SIZE-1:0] gray
);

always_comb
  for (int i=0; i<SIZE; i++)
    bin[i] = ^(gray>>i);
    
endmodule