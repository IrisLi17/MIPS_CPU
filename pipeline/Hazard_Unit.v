/*
load-and-use stall
jump stall
beq stall 
reg-beq stall ???
*/

module Hazard_Unit(
  input reset,
  input clk,

  input ID_EX_MemRd,
  input ID_EX_RegRt,
  input ID_EX_RegRd,
  input ID_EX_RegWrite,
  input ID_EX_RegDst_0,
  input IF_ID_RegRs,
  input IF_ID_RegRt,
  input IDcontrol_Branch,
  input IDcontrol_Jump,  

  output reg PCWrite,
  output reg IF_ID_RegWrite,
  output reg ID_EX_Clear; // 1代表清空ID_EX寄存器
);

reg cur_jump;
reg pre_jump;
reg cur_branch;
reg pre_branch;

always @(posedge reset or posedge clk) begin
  cur_jump <= IDcontrol_Jump;
  pre_jump <= cur_jump;
  cur_branch <= IDcontrol_Branch;
  pre_branch <= cur_branch;

  if (reset) begin
    PCWrite <= 1;
    IF_ID_RegWrite <= 1;
    ID_EX_Clear <= 0;
  end
  else begin
    if (ID_EX_MemRd && ((ID_EX_RegRt==IF_ID_RegRs) || (ID_EX_RegRt==IF_ID_RegRt))) begin
      PCWrite <= 0;
      IF_ID_RegWrite <= 0;
      ID_EX_Clear <= 1;
    end
    if (pre_jump || pre_branch) begin
      PCWrite <= 0;
      IF_ID_RegWrite <= 0;
      ID_EX_Clear <= 1;
    end
    if (cur_branch && ID_EX_RegWrite && (
        ((IF_ID_RegRs==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
        ((IF_ID_RegRs==ID_EX_RegRd) && ~ID_EX_RegDst_0) || 
        ((IF_ID_RegRt==ID_EX_RegRt) &&  ID_EX_RegDst_0) || 
        ((IF_ID_RegRt==ID_EX_RegRd) && ~ID_EX_RegDst_0) ) 
       ) begin
      PCWrite <= 0;
      IF_ID_RegWrite <= 0;
      ID_EX_Clear <= 1;
    end
  end
end

endmodule