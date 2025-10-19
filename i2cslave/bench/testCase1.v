// ---------------------------------- testcase0.v ----------------------------
`include "i2cSlave_define.v"
`include "i2cSlaveTB_defines.v"

module testCase0();

reg ack;
reg [7:0] data;
reg [15:0] dataWord;
reg [7:0] dataRead;
reg [7:0] dataWrite;
integer i;
integer j;

initial
begin
  $write("\n\n");
  testHarness.reset;
  #1000;

  // set i2c master clock scale reg PRER = (48MHz / (5 * 400KHz) ) - 1
  $write("Testing register read/write\n");
  testHarness.u_wb_master_model.wb_write(1, `PRER_LO_REG , 8'h17);
  testHarness.u_wb_master_model.wb_write(1, `PRER_HI_REG , 8'h00);
  testHarness.u_wb_master_model.wb_cmp(1, `PRER_LO_REG , 8'h17);

  // enable i2c master
  testHarness.u_wb_master_model.wb_write(1, `CTR_REG , 8'h80);

  //Toggle full BUS
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h00000000, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h00000000, dataWord, `NULL);
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, dataWord, `NULL);
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h00000000, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'h00000000, dataWord, `NULL);


  //Not valid address
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'hfb, 32'habcdabcd, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'hfb, 32'h00000000, dataWord, `NULL);

  //Try wr/rd again
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, dataWord, `NULL);
  
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h12345678, dataWord, `NULL);

  force testHarness.u_i2cSlave.myReg4 = 8'h00;
  force testHarness.u_i2cSlave.myReg5 = 8'h00;
  force testHarness.u_i2cSlave.myReg6 = 8'h00;
  force testHarness.u_i2cSlave.myReg7 = 8'h00;
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h0, dataWord, `NULL);

  force testHarness.u_i2cSlave.myReg4 = 8'hff;
  force testHarness.u_i2cSlave.myReg5 = 8'hff;
  force testHarness.u_i2cSlave.myReg6 = 8'hff;
  force testHarness.u_i2cSlave.myReg7 = 8'hff;
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h04, 32'hffffffff, dataWord, `NULL);

  force testHarness.u_i2cSlave.myReg4 = 8'h00;
  force testHarness.u_i2cSlave.myReg5 = 8'h00;
  force testHarness.u_i2cSlave.myReg6 = 8'h00;
  force testHarness.u_i2cSlave.myReg7 = 8'h00;
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h04, 32'h0, dataWord, `NULL);

  //Write to an invalid address
  multiByteReadWrite.write({7'h00, 1'b0}, 8'h00, 32'h00000000, `SEND_STOP);

  #500;
  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'hffffffff, dataWord, `NULL);

  force testHarness.rst_slave = 1'b1;
  #500;
  force testHarness.rst_slave = 1'b0;
  #2500;
  //Generate stop condition 
  force testHarness.sda = 1'b0;
  force testHarness.scl = 1'b0;
  #24000;
  force testHarness.scl = 1'b1;
  #2400;
  force testHarness.sda = 1'b1;
  #4400;
  force testHarness.scl = 1'b0;

  release testHarness.sda;
  #2400;
  release testHarness.scl;


  multiByteReadWrite.write({`I2C_ADDRESS, 1'b0}, 8'h00, 32'habcdabcd, `SEND_STOP);
  multiByteReadWrite.read({`I2C_ADDRESS, 1'b0}, 8'h00, 32'habcdabcd, dataWord, `NULL);

 


  $write("Finished all tests\n");
  $stop;	

end

endmodule

