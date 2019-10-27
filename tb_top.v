`timescale 1ns / 1ps

module tb_top();
	reg clk, rst;
	reg [15:0] instruction;
	
	top uut(.clk(clk), .rst(rst), .instruction(instruction));
	
	initial begin
		clk = 0;
		rst = 0; #5;
		
		rst = 1; #10;
		rst = 0; #20;
		
		//Pre-existing values hardcoded into Registers
		//R[1] = 2
		//R[2] = 4
		//R[3] = 3
		
		// Value 
		instruction = 16'b0100000101000010; // Store R[1] = 2 into M[R[2]] = M[address 4]
		#80;
		instruction = 16'b0100010000000010; // Load M[R[2]] = M[address 4] = 2 into R[4]
		#80;
		instruction = 16'b0000001001010011; // Add R[2] = R[2] + R[3] = 4 + 3 = 7
		#80;
		instruction = 16'b0000001010010001; // Sub R[2] = R[2] - R[1] = 7 - 2 = 5
		#80;
		instruction = 16'b0000010111010010; // MOV R[2] into R[5] = 5
		#80;
		instruction = 16'b0000001100010010; // And R[3] = R[3] & R[2] = 3 & 5 = 1
		#80;
		instruction = 16'b0000000100100101; // Or R[1] = R[1] | R[5] = 2 | 5 = 7
		#80;
		instruction = 16'b0000001100110001; // Xor R[3] = R[3] ^ R[1] = 1 ^ 7 = 6
		#80;
		instruction = 16'b0000000110110011; // Cmp R[3] to R[1] = 6 cmp 7 --> L = 1, N = 1
		#80;
		instruction = 16'b0000000000000000; //End of File Instruction
		
		
	end
	
	always #10 clk = ~clk;
	
	
endmodule
