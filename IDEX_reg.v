module IDEX_reg(clk,reset,stall, //????load??use??
                ID_MemWr,EX_MemWr,
                ID_RegWr,EX_RegWr,
                ID_MemRd,EX_MemRd,
                ID_ALUFun,EX_ALUFun,
                ID_BusA,EX_BusA,
                ID_BusB,EX_BusB,
                ID_RegDst,EX_RegDst,
                ID_MemtoReg,EX_MemtoReg,
                ID_WrReg,EX_WrReg,
                ID_PC,EX_PC);
input clk,reset,stall,ID_MemWr,ID_MemRd,ID_RegWr;//when stall is enable,place MemWr,MenRd and RegWr on zero
input [5:0]ID_ALUFun;
input [1:0]ID_RegDst,ID_MemtoReg;
input [4:0]ID_WrReg;
input [31:0]ID_PC,ID_BusA,ID_BusB;
output reg[31:0]EX_PC,EX_BusA,EX_BusB;
output reg[4:0]EX_WrReg;
output reg[1:0]EX_RegDst,EX_MemtoReg;
output reg[5:0]EX_ALUFun;
output reg EX_MemWr,EX_MemRd,EX_RegWr;
always@(posedge clk or posedge reset) begin
EX_MemWr=(stall|reset) ? 0:ID_MemWr;
EX_MemRd=(stall|reset) ? 0:ID_MemRd;
EX_RegWr=(stall|reset) ? 0:ID_RegWr;
if(reset) begin
EX_ALUFun=0;
EX_BusA=0;
EX_BusB=0;
EX_RegDst=0;
EX_MemtoReg=0;
EX_WrReg=0;
EX_PC=0;
end
else begin
EX_ALUFun=ID_ALUFun;
EX_BusA=ID_BusA;
EX_BusB=ID_BusB;
EX_RegDst=ID_RegDst;
EX_MemtoReg=ID_MemtoReg;
EX_WrReg=ID_WrReg;
EX_PC=ID_PC;
end
end
endmodule
