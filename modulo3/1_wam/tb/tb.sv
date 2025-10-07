module tb;
  
  parameter CLK_PERIOD_A = 10;
  parameter CLK_PERIOD_B = 7;
  parameter CYCLES = 20;
  
  reg clk_a;
  reg clk_b;
  reg d;
  wire q;
  integer counter;
  
  initial begin
    clk_a = 0;
    counter = 0;
    forever #(CLK_PERIOD_A/2) clk_a = ~clk_a;
  end

   initial begin
    clk_b = 0;
    counter = 0;
    forever #(CLK_PERIOD_B/2) clk_b = ~clk_b;
  end
  
  // Instantiate design under test
  ff DFF(.i_data(d),
         .i_clock_a(clk_a),
         .i_clock_b(clk_b),
         .o_data(q));
          
  always @(posedge clk_a)
  begin
    counter <= counter +1;
    d <= $random();
    
    if (counter >= CYCLES)
    begin
      $finish;
    end
  end
  
  //task display;
  //  #1 $display("d:%0h, q:%0h",d, q);
  //endtask

endmodule