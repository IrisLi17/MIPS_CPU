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

  output reg [1:0] ForwardA,
  output reg [1:0] ForwardB,
  output reg ForwardC,
  output reg ForwardD
);

always @(*) begin
  if (reset) begin
    ForwardA <= 2'b00;
    ForwardB <= 2'b00;
    ForwardC <= 0;
    ForwardD <= 0;
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
  end
end

endmodule