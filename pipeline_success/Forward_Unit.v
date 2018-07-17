/*
EX/MEM -> ID/EX forwarding
MEM/WB -> ID/EX forwarding
*/

module Forward_Unit (
  input clk,
  input reset,

  input EX_MEM_RegWrite,
  input [4:0]EX_MEM_RegRd,
  input [4:0]ID_EX_RegRs,
  input [4:0]ID_EX_RegRt,
  input MEM_WB_RegWrite,
  input [4:0]MEM_WB_RegRd,
  input IDControl_Branch,
  input [4:0]IF_ID_RegRs,
  input [4:0]IF_ID_RegRt,
  input Memcontrol_jal,
  input [2:0]PCSrc,
  input EX_MEM_MEMWrite,
  input [4:0] EX_MEM_RegRt,
  input [4:0] MEM_WB_Reg,

  output reg [1:0] ForwardA,
  output reg [1:0] ForwardB,
  output reg ForwardC,
  output reg ForwardD,
  output reg ForwardPC,//jal-jr
  output reg Forwardsw //Mem -> Mem
);

always @(*) begin
  if (reset) begin
    ForwardA <= 2'b00;
    ForwardB <= 2'b00;
    ForwardC <= 0;
    ForwardD <= 0;
    Forwardsw <= 0;
    ForwardPC <= 0;
  end
  else begin
    if (EX_MEM_RegRd!=0 && EX_MEM_RegWrite && (EX_MEM_RegRd==ID_EX_RegRs)) ForwardA <= 2'b10;
    else if (MEM_WB_RegRd!=0 && MEM_WB_RegWrite && (MEM_WB_RegRd==ID_EX_RegRs)) ForwardA <= 2'b01;
    else ForwardA <= 2'b00;
 

    if (EX_MEM_RegRd!=0 && EX_MEM_RegWrite && (EX_MEM_RegRd==ID_EX_RegRt)) ForwardB <= 2'b10;
    else if (MEM_WB_RegRd!=0 && MEM_WB_RegWrite && (MEM_WB_RegRd==ID_EX_RegRt)) ForwardB <= 2'b01;
    else ForwardB <= 2'b00;

    ForwardC <= (IDControl_Branch && (EX_MEM_RegRd!=0)&&(EX_MEM_RegRd==IF_ID_RegRs));
    ForwardD <= (IDControl_Branch && (EX_MEM_RegRd!=0)&&(EX_MEM_RegRd==IF_ID_RegRt));
    ForwardPC <=(PCSrc==3 && Memcontrol_jal==1) ?1:0;
    Forwardsw <= EX_MEM_MEMWrite && MEM_WB_RegWrite && (EX_MEM_RegRt == MEM_WB_Reg);
  end
end

endmodule