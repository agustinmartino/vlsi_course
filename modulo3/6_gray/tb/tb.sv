`timescale 1ns/1ns
module tb;
  localparam WIDTH = 3;

  logic wclk;
  logic rclk;
  logic [WIDTH-1:0] wcount, rcount;

  // DUT
  counter #(
    .WIDTH(WIDTH)
  ) 
  dut (
    .wclk(wclk),
    .wcount(wcount),
    .rclk(rclk),
    .rcount(rcount)
  );

  // Generador de clocks
  initial begin
    wclk = 0;
    wcount = 0;
    forever #5 wclk = ~wclk;   // periodo 10ns
  end

  initial begin
    rclk = 0;
    forever #7 rclk = ~rclk;   // periodo 14ns 
  end

  initial begin

    // correr por un tiempo
    #200;
    $finish;
  end

  always @(posedge wclk)
  begin
    wcount <= wcount + 1'b1;
  end

  // Monitoreo
  always @(posedge wclk) begin
    $display("WCLK %t: contador interno=%0d", $time, wcount);
  end

  always @(posedge rclk) begin
    $display("RCLK %t: valor leido=%0d", $time, rcount);
  end

endmodule