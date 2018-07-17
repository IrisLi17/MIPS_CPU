module pipeline_MEM(sys_clk,reset,Mem_MemRd,Mem_MemWr,Mem_in,Mem_outA,Mem_outB,Mem_BusB,led,switch,digi,irqout,uart_rx,uart_tx,Forwardsw,WB_dataB);
input sys_clk,reset,Mem_MemRd,Mem_MemWr;
input Forwardsw;
input [31:0] WB_dataB;
input [31:0]Mem_in,Mem_BusB;
input [7:0]switch;
input uart_rx;
output uart_tx;
output [31:0]Mem_outA,Mem_outB;
output [7:0]led;
output [11:0]digi;
output irqout;

wire [31:0]memout1,memout2,memout3;
wire [31:0]Mem_WriteData;

assign Mem_outB=(Mem_in[30]==1)?((Mem_in[5:0]==6'h18 || Mem_in[5:0]==6'h1c || Mem_in[5:0]==6'h20)?memout3:memout2):memout1;//0x40000000??????
assign Mem_outA=Mem_in;
assign Mem_WriteData = Forwardsw ? WB_dataB : Mem_BusB;

DataMemory DataMem(.reset(reset), .clk(sys_clk), .Address(Mem_in[31:2]), .Write_data(Mem_WriteData), .Read_data(memout1), 
.MemRead(Mem_MemRd), .MemWrite(Mem_MemWr));

Peripheral myPeripheral(.reset(reset),.clk(sys_clk),.rd(Mem_MemRd),.wr(Mem_MemWr),.addr(Mem_in),.wdata(Mem_WriteData),
.rdata(memout2),.led(led),.switch(switch),.digi(digi),.irqout(irqout));

UART myUART(.reset(reset),.sys_clk(sys_clk),.rd(Mem_MemRd),.wr(Mem_MemWr),.addr(Mem_in),
            .rdata(memout3),.wdata(Mem_WriteData[7:0]),.uart_rx(uart_rx),.uart_tx(uart_tx));
endmodule