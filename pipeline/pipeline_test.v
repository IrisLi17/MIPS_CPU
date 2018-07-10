`timescale 10ps/1ps
module pipeline_test;
reg clk;
wire [7:0]led,switch;
reg reset;
wire uart_rx,uart_tx;
initial
begin
clk=0;
#50 reset=1;
#50 reset=0;
forever #100 clk=~clk;
end
pipeline pipe(clk,reset,led,switch,uart_rx,uart_tx);
endmodule
