module pipeline_EX(ForwardA,ForwardB,EX_ALUFun,Sign,EX_ALUOut,MEMWBdata,EXMEMdata,EX_BusB,EX_BusA);
input Sign;
input [1:0]ForwardA,ForwardB;
input [31:0]EX_BusA,EX_BusB,MEMWBdata,EXMEMdata;
input [5:0]EX_ALUFun;
output EX_ALUOut;
wire [31:0]Data1,Data2;
assign Data1=(ForwardA==2'b0) ? EX_BusA :
             (ForwardA==2'b1) ? MEMWBdata :
             (ForwardA==2'b10) ? EXMEMdata : 32'b0;
assign Data2=(ForwardB==2'b0) ? EX_BusB :
             (ForwardB==2'b1) ? MEMWBdata :
             (ForwardB==2'b10) ? EXMEMdata : 32'b0;
ALU ALUs(.A(Data1),.B(Data2),.Sign(Sign),.ALUFun(EX_ALUFun),.S(EX_ALUOut));
endmodule
