module pipeline_IF(clk,IRQ,reset,stall,PCSrc,ConBA,ALUOut0,ID_BusA,PC,IF_PC,JT,ForwardPC,Mem_PC);
input clk,IRQ,reset,stall,ALUOut0,ForwardPC;
input [31:0]Mem_PC;
input[31:0]ConBA,ID_BusA;
input[25:0]JT;
input[2:0]PCSrc;
output reg[31:0] PC;
output reg[31:0]IF_PC;
wire[31:0] PC_choose;
assign PC_choose= stall? PC:
                  (PCSrc==0) ? 	PC+4 : //????
                  (PCSrc==1 & ALUOut0==0) ?  ConBA: //branch??
                  (PCSrc==2) ?  {PC[31:28],JT,2'b0}: //????
                  (ForwardPC==1) ? Mem_PC:
                  (PCSrc==3) ?  ID_BusA: //$ra
                  (PCSrc==4) ?  32'h80000004:
                  (PCSrc==5) ?  32'h80000008: PC+4;  
always @(posedge clk or posedge reset)
begin
if(reset)
PC<=32'h80000000;
else 
PC=PC_choose;
IF_PC=PC+4;
end
endmodule
