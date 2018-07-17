/*
load-and-use stall
jump stall
beq stall 
reg-beq stall
*/

module Hazard_Unit(
  input reset,
  input clk,
  input Branch,
  input ID_EX_MemRd,
  input [4:0]ID_EX_RegRt,
  input [4:0]ID_EX_RegRd,
  input ID_EX_RegWrite,
  input ID_EX_RegDst_0,
  input [4:0]IF_ID_RegRs,
  input [4:0]IF_ID_RegRt,
  input IDcontrol_Branch,
  input IDcontrol_Jump,  
  input irq,

  output  ID_EX_Clear, // 1代表清空ID_EX寄存器
  output  IF_ID_Clear  // 1代表清空IF/ID寄存器
);

wire IF_ID_Clear_temp;
wire irq_flush,cur_irq;
reg pre_irq;

assign ID_EX_Clear=(reset | (IDcontrol_Jump)) ? 0:
(ID_EX_MemRd & ( (ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt) ) ) ? 1: //load-use
(Branch  & (ID_EX_RegWrite && (//reg-branch
         ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
         ) ) ? 1:0;
                  
assign IF_ID_Clear_temp=(reset | (ID_EX_MemRd && ( (ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt) ) )) ? 0:
(IDcontrol_Jump) ? 1://jump
( (IDcontrol_Branch) & ~(ID_EX_RegWrite && (//branch
         ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
         ) ) ? 1:0;

assign cur_irq = irq;

assign irq_flush = (cur_irq && ~pre_irq);

assign IF_ID_Clear = IF_ID_Clear_temp || irq_flush;

always @(posedge clk or posedge reset) begin
  if(reset)  begin
    pre_irq <= 0;
  end
  else begin
    pre_irq <= cur_irq;  
  end
end

endmodule