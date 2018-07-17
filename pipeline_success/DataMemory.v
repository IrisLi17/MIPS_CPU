module DataMemory(reset, clk, Address, Write_data, Read_data, MemRead, MemWrite);
	input reset, clk;
	input [29:0] Address;
	input [31:0] Write_data;
	input MemRead, MemWrite;
	output [31:0] Read_data;
	
	parameter RAM_SIZE = 32;
	parameter RAM_SIZE_BIT = 5;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];
	assign Read_data = (MemRead && Address[29:RAM_SIZE_BIT] == 25'd0) ? RAM_data[Address[RAM_SIZE_BIT - 1:0]] : 32'h00000000;
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset) begin
		  for (i = 16; i < RAM_SIZE; i = i + 1) begin
			RAM_data[i] <= 32'h00000000; //program data begins at address 16
		  end
      	  RAM_data[0]  <= {24'b0, 8'b00111111};
		  RAM_data[1]  <= {24'b0, 8'b00000110};
		  RAM_data[2]  <= {24'b0, 8'b01011011};
		  RAM_data[3]  <= {24'b0, 8'b01001111};
		  RAM_data[4]  <= {24'b0, 8'b01100110};
		  RAM_data[5]  <= {24'b0, 8'b01101101};
		  RAM_data[6]  <= {24'b0, 8'b01111101};
		  RAM_data[7]  <= {24'b0, 8'b00000111};
		  RAM_data[8]  <= {24'b0, 8'b01111111};
		  RAM_data[9]  <= {24'b0, 8'b01101111};
		  RAM_data[10] <= {24'b0, 8'b01110111};
		  RAM_data[11] <= {24'b0, 8'b01111100};
		  RAM_data[12] <= {24'b0, 8'b00111001};
		  RAM_data[13] <= {24'b0, 8'b01011110};
		  RAM_data[14] <= {24'b0, 8'b01111001};
		  RAM_data[15] <= {24'b0, 8'b01110001};
		end
		else if (MemWrite && Address[29:RAM_SIZE_BIT] == 25'd0)
			RAM_data[Address[RAM_SIZE_BIT - 1:0]] <= Write_data;
		else ;
			
endmodule
