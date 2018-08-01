module pipeline_EX(ForwardA,ForwardB,EX_ALUFun,Sign,EX_ALUOut,MEMWBdata,EXMEMdata,
                   EX_ALUSrc1, EX_ALUSrc2, EX_imm, EX_shamt, EX_dataA, EX_dataB,EX_EXTOp,EX_LUOp,EX_rt_postForward);
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
output [31:0]EX_rt_postForward; 
wire [31:0]Data1,Data2;
wire [31:0] EX_BusA, EX_BusB;

assign EX_BusA = EX_ALUSrc1 ? EX_shamt : EX_dataA;
assign EX_BusB = EX_ALUSrc2 ? (EX_LUOp ? {EX_imm, 16'b0} : (EX_EXTOp ? (EX_imm[15] ? {16'b1111111111111111, EX_imm} : {16'b0, EX_imm}) : {16'b0, EX_imm})) : EX_dataB;
//对送入ALU的数据通路进行多路选择，立即数扩展等操作
assign Data1=(ForwardA==2'b0) ? EX_BusA :
             (ForwardA==2'b1) ? MEMWBdata :
             (ForwardA==2'b10) ? EXMEMdata : 32'b0;
assign Data2=(ForwardB==2'b0 || EX_ALUSrc2) ? EX_BusB ://当送入立即数时，不需要转发，这是为了规避lw及sw的问题
             (ForwardB==2'b1) ? MEMWBdata :
             (ForwardB==2'b10) ? EXMEMdata : 32'b0;
assign EX_rt_postForward = (ForwardB==2'b00) ? EX_dataB :
                           (ForwardB==2'b01) ? MEMWBdata :
                           (ForwardB==2'b10) ? EXMEMdata : 32'b0;//确保sw顺利进行，详细说明见实验报告
ALU ALUs(.A(Data1),.B(Data2),.Sign(Sign),.ALUFun(EX_ALUFun),.S(EX_ALUOut));
endmodule
