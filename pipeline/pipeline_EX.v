module pipeline_EX(ForwardA,ForwardB,EX_ALUFun,Sign,EX_ALUOut,MEMWBdata,EXMEMdata,
                   EX_ALUSrc1, EX_ALUSrc2, EX_imm, EX_shamt, EX_dataA, EX_dataB,EX_EXTOp,EX_LUOp);
input Sign;
input [1:0]ForwardA,ForwardB;
input [31:0]MEMWBdata;
input [31:0]EXMEMdata;
input EX_ALUSrc1, EX_ALUSrc2;
input EX_EXTOp, EX_LUOp;
input [4:0] EX_shamt;
input [15:0] EX_imm;
input [31:0] EX_dataA;
input [31:0] EX_dataB; 
input [5:0]EX_ALUFun;
output [31:0]EX_ALUOut;
wire [31:0]Data1,Data2;
wire [31:0] EX_BusA, EX_BusB;

assign EX_BusA = EX_ALUSrc1 ? EX_shamt : EX_dataA;
assign EX_BusB = EX_ALUSrc2 ? (EX_LUOp ? {EX_imm, 16'b0} : (EX_EXTOp ? (EX_imm[15] ? {16'b1, EX_imm} : {16'b0, EX_imm}) : {16'b0, EX_imm})) : EX_dataB;

assign Data1=(ForwardA==2'b0) ? EX_BusA :
             (ForwardA==2'b1) ? MEMWBdata :
             (ForwardA==2'b10) ? EXMEMdata : 32'b0;
assign Data2=(ForwardB==2'b0) ? EX_BusB :
             (ForwardB==2'b1) ? MEMWBdata :
             (ForwardB==2'b10) ? EXMEMdata : 32'b0;
ALU ALUs(.A(Data1),.B(Data2),.Sign(Sign),.ALUFun(EX_ALUFun),.S(EX_ALUOut));
endmodule
