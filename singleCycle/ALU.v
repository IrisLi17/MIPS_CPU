module ALU(A,B,Sign,ALUFun,S);
input [31:0]A,B;
input[5:0]ALUFun;
input Sign;
output [31:0]S;
wire[31:0]added,compare,logic,shift;
wire Z, V, N;

Adder adds(.A(A),.B(B),.minus(ALUFun[0]),.Sign(Sign),.Z(Z),.V(V),.N(N),.added(added));
CMP cmps(.Z(Z),.V(V),.N(N),.compare(compare),.choose(ALUFun[3:1]));
Logic logics(.A(A),.B(B),.choice(ALUFun[3:0]),.logic(logic));
Shift shifts(.A(A[4:0]),.B(B),.chooses(ALUFun[1:0]),.shift(shift));
assign S=(ALUFun[5:4]==2'b00)?added:
         (ALUFun[5:4]==2'b01)?logic:
         (ALUFun[5:4]==2'b10)?shift:compare;

endmodule

// add/sub
module Adder(A,B,minus,Sign,Z,V,N,added);
input [31:0]A,B;
input minus,Sign;
output Z,V,N;
output [31:0]added;
wire [31:0]b;
assign b = minus ? (~B+32'b1):B;
assign added = A+b;
assign Z = (added) ? 1'b0:1'b1;
assign V = (Sign& ( (~added[31]&A[31]&b[31]) | (added[31]&(~A[31])&(~b[31])) )) ? 1'b1:1'b0;
assign N = (added[31]) ? 1'b1:1'b0;
endmodule

//CMP
module CMP(Z,V,N,compare,choose);
input Z,V,N;
input[2:0]choose;
output[31:0] compare;
assign compare=(choose==3'b001) ? Z:
               (choose==3'b000) ? ~Z:
               (choose==3'b010) ? (N&(~V)):
               (choose==3'b110) ? (N|Z):
               (choose==3'b101) ? N:
               (choose==3'b111) ? ~(N|Z):32'b0;
endmodule

//Logic
module Logic(A,B,choice,logic);
input [31:0]A,B;
input [3:0]choice;
output [31:0]logic;
assign logic=(choice==4'b1000) ? A&B:
             (choice==4'b1110) ? A|B:
             (choice==4'b0110) ? A^B:
             (choice==4'b0001) ? ~(A|B):
             (choice==4'b1010) ? A:32'b0;
endmodule

//Shift
module Shift(A,B,chooses,shift);
input [4:0] A;
input [31:0] B;
input[1:0]chooses;
output[31:0]shift;
wire [31:0] a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4;

assign a1=(A[0]==1) ? {B[30:0],1'b0} : B;
assign a2=(A[1]==1) ? {a1[29:0],2'b00} : a1;
assign a3=(A[2]==1) ? {a2[27:0],4'b0000} : a2;
assign a4=(A[3]==1) ? {a3[23:0],8'b0} :a3;

assign b1=(A[0]==1) ? {1'b0,B[31:1]} : B;
assign b2=(A[1]==1) ? {2'b00,b1[31:2]} : b1;
assign b3=(A[2]==1) ? {4'b0000,b2[31:4]} : b2;
assign b4=(A[3]==1) ? {8'b0,b3[31:8]} :b3;

assign c1=(A[0]==1) ? {B[31],B[31:1]} : B;
assign c2=(A[1]==1) ? {{2{B[31]}},c1[31:2]} : c1;
assign c3=(A[2]==1) ? {{4{B[31]}},c2[31:4]} : c2;
assign c4=(A[3]==1) ? {{8{B[31]}},c3[31:8]} :c3;

assign shift=(chooses==2'b00)?( (A[4]==1) ? {a4[15:0],16'b0}:a4 ):
             (chooses==2'b01)?( (A[4]==1) ? {16'b0,b4[31:16]}:b4):
             (chooses==2'b11)?( (A[4]==1) ? {{16{B[31]}},c4[31:16]}:c4):31'b0;
endmodule