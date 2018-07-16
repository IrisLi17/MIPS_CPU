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

/*always @(*) begin

  if (reset) begin
    ID_EX_Clear <= 0;
    IF_ID_Clear <= 0;
  end

    if (ID_EX_MemRd && ((ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt))) begin
      ID_EX_Clear <= 1;
      IF_ID_Clear <= 0;
    end
     if (IDcontrol_Jump) begin
      ID_EX_Clear <= 0;
      IF_ID_Clear <= 1;
    end
     if (Branch) begin
      if (ID_EX_RegWrite && (
         ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
         ) begin
           ID_EX_Clear <= 1;
           IF_ID_Clear <= 0;
         end
      else if(IDcontrol_Branch)begin
        IF_ID_Clear <= 1;
        ID_EX_Clear <= 0;
      end
end
   else begin
        ID_EX_Clear <= 0;
        IF_ID_Clear <= 0;
   end    
end */
assign ID_EX_Clear=(reset | (IDcontrol_Jump)) ? 0:
(ID_EX_MemRd & ( (ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt) ) ) ? 1: //load-use
(Branch  & (ID_EX_RegWrite && (//reg-branch
         ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
         ) ) ? 1:0;
         
wire IF_ID_Clear_temp;
         
assign IF_ID_Clear_temp=(reset | (ID_EX_MemRd && ( (ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt) ) )) ? 0:
(IDcontrol_Jump) ? 1://jump
( (IDcontrol_Branch) & ~(ID_EX_RegWrite && (//branch
         ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
         ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
         ) ) ? 1:0;

reg pre_irq;
wire irq_flush,cur_irq;
assign cur_irq=irq;
assign irq_flush = (cur_irq && ~pre_irq);
always @(posedge clk or posedge reset) begin
  if(reset)  begin
    pre_irq <= 0;
  end
  else begin
    pre_irq <= cur_irq;  
  end
end

assign IF_ID_Clear = IF_ID_Clear_temp || irq_flush;

endmodule