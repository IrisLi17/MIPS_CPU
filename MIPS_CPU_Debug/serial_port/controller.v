/*
module controller(rx_data,rx_status,tx_status,sys_clk,tx_data,tx_enable,reset);
input [7:0] rx_data;
input rx_status;
input tx_status;
input sys_clk;
input reset;
output [7:0] tx_data;
output tx_enable;

reg [7:0] rdata;
reg [7:0] tdata;
//reg update;
//reg enable;

assign tx_data = (rdata[7]==1)?~rdata:rdata;
//assign tx_enable = enable;
assign tx_enable = ~rx_status;
always @(posedge sys_clk or posedge reset) begin
  if(reset == 1'b1) begin
    rdata<=7'b1111111;
  end
  else begin
    if(rx_status == 0) begin
      rdata<=rx_data;
      //enable<=tx_status;
    end
    //else if(rx_status == 1) begin
    //  enable<=1'b0;
    //end
  end
end
endmodule
*/
//这个文件基本上没什么用了。。。