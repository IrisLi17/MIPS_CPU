module MEMWB_reg(clk,reset,
                 Mem_outB,WB_inB,
                 Mem_outA,WB_inA,
                 Mem_RegDst,WB_RegDst,
                 Mem_RegWr,WB_RegWr,
                 Mem_WrReg,WB_WrReg,
                 Mem_MemtoReg,WB_MemtoReg,
                 Mem_rd,WB_rd,
                 Mem_PC,WB_PC);
input clk,reset,Mem_RegWr;
input [31:0]Mem_outB,Mem_outA,Mem_PC;
input [1:0]Mem_MemtoReg,Mem_RegDst;
input [4:0]Mem_WrReg,Mem_rd;
output reg[1:0]WB_MemtoReg,WB_RegDst;
output reg[4:0]WB_WrReg,WB_rd;
output reg[31:0]WB_inA,WB_inB,WB_PC;
output reg WB_RegWr;
always@(posedge clk or posedge reset) begin
if(reset) begin
WB_inA=32'b0;
WB_inB=32'b0;
WB_RegWr=0;
WB_RegDst=0;
WB_MemtoReg=0;
WB_WrReg=0;
WB_PC=32'h80000000;
WB_rd=0;
end
else begin
WB_inA=Mem_outA;
WB_inB=Mem_outB;
WB_RegWr=Mem_RegWr;
WB_RegDst=Mem_RegDst;
WB_MemtoReg=Mem_MemtoReg;
WB_WrReg=Mem_WrReg;
WB_PC=Mem_PC;
WB_rd=Mem_rd;
end
end
endmodule
