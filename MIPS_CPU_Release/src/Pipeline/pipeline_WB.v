module pipeline_WB(WB_RegDst,WB_MemtoReg,WB_out,WB_inA,WB_inB,WB_PC,WB_WrReg,WB_Destiny);
input [1:0]WB_RegDst,WB_MemtoReg;
input [4:0]WB_WrReg;
input [31:0]WB_inA,WB_inB;
input [30:0] WB_PC;
output [31:0]WB_out;
output [4:0]WB_Destiny;

assign WB_out = (WB_MemtoReg==0) ? WB_inA: //from ALU
              (WB_MemtoReg==1) ? WB_inB: // from Memory
              (WB_MemtoReg==2) ? {1'b0, WB_PC}:
              ({1'b0, WB_PC} - 4);
assign WB_Destiny = (WB_RegDst==2) ? 31:
                  (WB_RegDst==3) ? 26: WB_WrReg;
endmodule