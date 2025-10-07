module tb;
  
  parameter CLK_PERIOD_A = 4;
  parameter CLK_PERIOD_B = 10;
  parameter CYCLES = 200;
  parameter DATA_CHANGE = 10;
  parameter NB = 8;
  
  reg src_clk;
  reg dest_clk;
  reg  [NB -1 : 0] d;
  wire [NB -1 : 0] q;
  reg valid;
  integer counter;
  integer counter_data;
  
  initial begin
    src_clk = 0;
    dest_clk = 0;
    counter = 0;
    counter_data = 0;
    valid = 0;
  end

  initial begin
    forever #(CLK_PERIOD_A/2) src_clk  = ~src_clk;
  end

  initial begin
    forever #(CLK_PERIOD_B/2) dest_clk = ~dest_clk;
  end
  
  // Instantiate design under test
  mb_sync #(
    .NB(8)
  ) 
  u_MB_SYNC(
    .i_data(d),
    .i_valid(valid),
    .i_src_clock(src_clk),
    .i_dest_clock(dest_clk),
    .o_data(q)
  );
          
  always @(posedge src_clk)
  begin
    counter <= counter +1;
    counter_data <= counter_data +1;
    
    if(counter_data >= DATA_CHANGE)
    begin
      d <= $random();
      valid <= 1'b1;
      counter_data <= 0;
    end
    else
    begin 
      valid <= 1'b0;
    end
    
    if (counter >= CYCLES)
    begin
      $finish;
    end
  end
  
  //task display;
  //  #1 $display("d:%0h, q:%0h",d, q);
  //endtask

endmodule