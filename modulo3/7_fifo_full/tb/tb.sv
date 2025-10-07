`timescale 1ns/1ps

module tb;

  // Parámetros
  localparam NB_DATA = 4;
  localparam DEPTH   = 8;

  // Señales
  reg  [NB_DATA-1:0] i_data;
  reg                i_reset;
  reg                i_rclk;
  reg                i_wclk;
  wire [NB_DATA-1:0] o_data;
  wire               o_full;
  wire               o_empty;

  // DUT
  fifo #(
    .NB_DATA(NB_DATA),
    .DEPTH(DEPTH)
  ) dut (
    .i_data (i_data),
    .i_reset(i_reset),
    .i_rclk (i_rclk),
    .i_wclk (i_wclk),
    .o_data (o_data),
    .o_full (o_full),
    .o_empty(o_empty)
  );

  // Clocks con la misma frecuencia pero desfasados
  initial begin
    i_wclk = 0;
    forever #5 i_wclk = ~i_wclk; // periodo 10 ns
  end

  initial begin
    #2.5; // desfase de 180 grados respecto a i_wclk
    i_rclk = 0;
    forever #3 i_rclk = ~i_rclk;
  end

  // Estímulos
  initial begin
    // Inicialización
    i_reset = 1;
    i_data  = 0;
    #20;
    i_reset = 0;

    #400;
    $finish;
  end

  // Escribimos 10 valores en la FIFO

  always @(posedge i_wclk)
  begin
    i_data <= $random % (1 << NB_DATA);
  end

  // Monitoreo de estados
  always @(posedge i_wclk or posedge i_rclk) begin
    $display("[%0t] FULL=%b EMPTY=%b", $time, o_full, o_empty);
  end

endmodule