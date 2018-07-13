module IDEX_reg(clk,reset,stall, //????load??use??
                ID_MemWr,EX_MemWr,
                ID_RegWr,EX_RegWr,
                ID_MemRd,EX_MemRd,
                ID_ALUFun,EX_ALUFun,
                ID_RegDst,EX_RegDst,
                ID_MemtoReg,EX_MemtoReg,
                ID_WrReg,EX_WrReg,
                ID_PC,EX_PC,
                ID_rt,EX_rt,
                ID_rd,EX_rd,
                IDcontrol_jal,EXcontrol_jal,
                ID_rs,EX_rs,
                ID_ALUSrc1, ID_ALUSrc2,
                ID_dataA, ID_dataB,
                ID_imm, ID_shamt,
                ID_EXTOp, ID_LUOp,
                EX_ALUSrc1, EX_ALUSrc2,
                EX_dataA, EX_dataB,
                EX_imm, EX_shamt,
                EX_EXTOp, EX_LUOp);
input clk,reset,stall,ID_MemWr,ID_MemRd,ID_RegWr;//when stall is enable,place MemWr,MenRd and RegWr on zero
input [5:0]ID_ALUFun;
input [1:0]ID_RegDst,ID_MemtoReg;
input [4:0]ID_WrReg,ID_rt,ID_rd,ID_rs;
input [31:0]ID_PC;
input IDcontrol_jal;
input ID_ALUSrc1, ID_ALUSrc2; 
input [4:0]ID_shamt;
input [31:0]ID_dataA;
input [31:0]ID_dataB;
input [15:0]ID_imm;
input ID_EXTOp, ID_LUOp;
output reg EXcontrol_jal;
output reg[31:0]EX_PC;
output reg[4:0]EX_WrReg,EX_rt,EX_rd,EX_rs;
output reg[1:0]EX_RegDst,EX_MemtoReg;
output reg[5:0]EX_ALUFun;
output reg EX_MemWr,EX_MemRd,EX_RegWr;
output reg EX_ALUSrc1, EX_ALUSrc2;
output reg [4:0]EX_shamt;
output reg [31:0]EX_dataA;
output reg [31:0]EX_dataB;
output reg [15:0]EX_imm; 
output reg EX_EXTOp, EX_LUOp;
always@(posedge clk or posedge reset) begin
EX_MemWr=(stall|reset) ? 0:ID_MemWr;
EX_MemRd=(stall|reset) ? 0:ID_MemRd;
EX_RegWr=(stall|reset) ? 0:ID_RegWr;
if(reset) begin
EX_ALUFun=0;
EX_RegDst=0;
EX_MemtoReg=0;
EX_WrReg=0;
EX_PC=32'h80000000;
EX_rt=0;
EX_rd=0;
EX_rs=0;
EXcontrol_jal=0;
EX_ALUSrc1 <= 0;
EX_ALUSrc2 <= 0;
EX_shamt <= 5'b0;
EX_dataA <= 32'b0;
EX_dataB <= 32'b0;
EX_imm <= 16'b0;
EX_EXTOp <= 0;
EX_LUOp <= 0;
end
else begin
EX_ALUFun=ID_ALUFun;
EX_RegDst=ID_RegDst;
EX_MemtoReg=ID_MemtoReg;
EX_WrReg=ID_WrReg;
EX_PC=ID_PC;
EX_rt=ID_rt;
EX_rd=ID_rd;
EX_rs=ID_rs;
EXcontrol_jal=IDcontrol_jal;
EX_ALUSrc1 <= ID_ALUSrc1;
EX_ALUSrc2 <= ID_ALUSrc2;
EX_shamt <= ID_shamt;
EX_dataA <= ID_dataA;
EX_dataB <= ID_dataB;
EX_imm <= ID_imm;
EX_EXTOp <= ID_EXTOp;
EX_LUOp <= ID_LUOp;
end
end
endmodule
