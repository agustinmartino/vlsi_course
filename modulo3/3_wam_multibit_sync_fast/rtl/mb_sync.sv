module mb_sync #( //Sincronizador con problema de perdida de pulso en el cruce 
  NB = 8
)
(
  input  [NB - 1 : 0] i_data,       //Señal sincrona al dominio de origen
  input               i_valid,      //Señal sincrona al dominio de origen
  input               i_src_clock,  
  input               i_dest_clock,
  output [NB - 1 : 0] o_data        //Señal sincrona al dominio de destino
);


reg  [NB - 1 : 0] data_src_d;
wire [NB - 1 : 0] data_delay;
reg  valid_d;
wire valid_sync;
reg  valid_sync_d;
reg  [NB - 1 : 0] data_out_d;

always @(posedge i_src_clock)
begin
  valid_d <= i_valid;
end

always @(posedge i_src_clock)
begin
  if(i_valid == 1'b1 & valid_d ==1'b0) //Pulse detector
  begin 
    data_src_d <= i_data;
  end
end

bit_sync u_valid_sync(
  .i_data(valid_d),
  .i_clock(i_dest_clock),
  .o_data(valid_sync)
);

always @(posedge i_dest_clock)
begin
  valid_sync_d <= valid_sync;
end

genvar i;

generate
  for (i = 0; i<NB; i = i+1)
  begin
    random_delay_bits #(
      .NB_IN(1),
      .MIN_DELAY(1),
      .MAX_DELAY(4)
    ) 
    u_delay (
      .i_data(data_src_d[i]),
      .o_data(data_delay[i])
    );
  end
endgenerate

always @(posedge i_dest_clock)
begin
  if(valid_sync == 1'b1 & valid_sync_d ==1'b0) //Pulse detector
  begin 
    data_out_d <= data_delay;
  end
end

assign o_data = data_out_d;

endmodule