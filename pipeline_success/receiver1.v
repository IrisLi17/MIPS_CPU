module receiver1(uart_rx,clk,reset,rx_data,rx_status);
input uart_rx;
input clk;
input reset;
output [7:0] rx_data;
output rx_status;

reg out_status;
reg [1:0] status;
reg [6:0] baud_count;
reg lastdata;
reg curdata;
reg [7:0] data;
reg [7:0] temp_data;

assign rx_status = out_status;
assign rx_data = temp_data;
initial begin
  status<=2'b00;
  baud_count<=7'd0;
  out_status<=1'b0;
  temp_data<=8'b11111111;
  data<=8'b11111111;
end
always @(posedge clk or posedge reset) begin
  if(reset == 1'b1) begin
    status<=2'b00;
    baud_count<=7'd0;
    out_status<=1'b0;
    temp_data<=8'b11111111;
    data<=8'b11111111;
  end
  else if (out_status == 1'b1) begin
    out_status <= 1'b0; //只希望输出一个串口时钟的高电平，防止上层uart_con[3]总是被置为1
  end
  else begin
    curdata<=uart_rx;
    lastdata<=curdata;
    if(status == 2'b00) begin
      if(curdata == 1'b0 && lastdata == 1'b1) begin
        status<=2'b01;
        out_status<=1'b0;
      end
    end
    else if(status == 2'b01) begin
      if(baud_count == 7'd7) begin
        status<=2'b10;
        baud_count<=7'd0;
      end
      else begin
        baud_count<=baud_count+7'd1;
      end
    end
    else if(status == 2'b10) begin
      if(baud_count[3:0] == 4'b1111) begin
        data[baud_count[6:4]]<=uart_rx;
        if(baud_count == 7'b1111111) begin
          baud_count<=7'd0;
          status<=2'b11;
        end
        else begin
          baud_count<=baud_count+7'd1;
        end      
      end
      else begin
        baud_count<=baud_count+7'd1;
      end
    end
    else begin
      if(baud_count == 7'd15) begin
        baud_count<=7'd0;
        status<=2'b00;
        //temp_data<=data;
        out_status<=1'b1;
      end
      else begin
        baud_count<=baud_count+7'd1;
        if(baud_count == 7'd0) begin
          temp_data<=data;
        end
      end
    end
  end
end
endmodule