module sender(tx_data,tx_enable,clk,reset,uart_tx,tx_status);
input [7:0] tx_data;
input tx_enable;
input clk;
input reset;
output uart_tx;//output signal
output tx_status;//availble status

reg last_enable;
reg cur_enable;
reg remain;
reg [7:0] tx_buffer;
reg [6:0] baud_count;//8*16=2^7,[6:4] represent which number to output
reg out_status;
reg [1:0] status;
//assign uart_tx = tx;
assign uart_tx = 
  //(status == 2'b00)?1'b1:
  (status == 2'b01)?1'b0:
  (status == 2'b10)?tx_buffer[baud_count[6:4]]:1'b1;
assign tx_status = out_status;
initial begin
  status<=2'b00;
  baud_count<=7'd0;
  //lock<=1'b0;
  remain<=1'b0;
  cur_enable<=1'b0;
  last_enable<=1'b0;
end
always @(posedge clk or posedge reset) begin
  if(reset == 1'b1) begin
    status<=2'b00;
    baud_count<=7'd0;
    remain<=1'b0;
    cur_enable<=1'b0;
    last_enable<=1'b0;
  end
  else begin
    cur_enable<=tx_enable;
    last_enable<=cur_enable;
    if(cur_enable == 1'b1 && last_enable == 1'b0) begin
      if(remain == 1'b0) remain<=1'b1;
    end
    if(status == 2'b00) begin
      if(tx_enable == 1'b1 && remain == 1'b1) begin
      //if(cur_enable == 1'b1 && last_enable == 1'b0) begin
        status<=2'b01;
        out_status<=1'b1;//unavailable
        tx_buffer<=tx_data;
      end 
      else begin
        out_status<=1'b0;//free
      end 
    end
    else if(status == 2'b01) begin
      if(baud_count == 7'd15) begin
        status<=2'b10;
        baud_count<=7'd0;
      end
      else begin
        baud_count<=baud_count+7'd1;
      end
    end
    else if(status == 2'b10) begin
      if(baud_count == 7'b1111111) begin
        status<=2'b11;
        baud_count<=7'd0;
      end
      else begin
        baud_count<=baud_count+7'd1;
      end
    end
    else begin
      if(baud_count == 7'd15) begin
        if(remain == 1'b0) begin
          status<=2'b00;
          out_status<=1'b0;
          //lock<=1'b0;
          tx_buffer<=7'b1111111;
          baud_count<=7'd0;
        end
        else begin
          status<=2'b01;
          out_status<=1'b1;
          tx_buffer<=tx_data;
          baud_count<=7'd0;
        end
      end
      else if(baud_count == 7'd0) begin
        baud_count<=baud_count+7'd1;
        if(remain == 1'b1) remain<=1'b0;
      end
      else begin
        baud_count<=baud_count+7'd1;
      end
    end
  end
end

endmodule