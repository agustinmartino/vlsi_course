`timescale 1ns/1ns

module tb_cdc_syncfifo;

  // Parámetros
  localparam int DATA_WIDTH = 8;
  typedef logic [DATA_WIDTH-1:0] dat_t;

  // Señales
  dat_t wdata;
  logic wrdy;
  logic wput;
  logic wclk, wrst_n;

  dat_t rdata;
  logic rrdy;
  logic rget;
  logic rclk, rrst_n;

  // DUT
  cdc_syncfifo #(.dat_t(dat_t)) dut (
    .wdata(wdata),
    .wrdy(wrdy),
    .wput(wput),
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rdata(rdata),
    .rrdy(rrdy),
    .rget(rget),
    .rclk(rclk),
    .rrst_n(rrst_n)
  );

  // Clock escritura (período 10ns)
  initial begin
    wclk = 0;
    forever #5 wclk = ~wclk;
  end

  // Clock lectura (período 14ns ? distinto al de escritura)
  initial begin
    rclk = 0;
    forever #7 rclk = ~rclk;
  end

  // Estímulos
  initial begin
    // Inicialización
    wput   = 0;
    rget   = 0;
    wdata  = '0;
    wrst_n = 0;
    rrst_n = 0;

    // Reset
    #20;
    wrst_n = 1;
    rrst_n = 1;

    // Activar siempre wput y rget
    wput = 1;
    rget = 1;

    // Inyectar datos de forma continua
    repeat (50) begin
      @(posedge wclk);
      if (wrdy) begin
        wdata <= $urandom;
      end
    end

    // Esperar a que se vacíe la FIFO
    repeat (30) @(posedge rclk);

    $finish;
  end

  // Monitor
  initial begin
    $display("time | wrdy wdata | rrdy rdata");
    $monitor("%4t | %b %h | %b %h", $time, wrdy, wdata, rrdy, rdata);
  end

endmodule