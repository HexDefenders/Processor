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
		
		// Value 
		instruction = 16'b0100000101000010; // Store 
		#160;
		instruction = 16'b0100001100000010; // Load
		#160;
		instruction = 16'b0000000001010001; // Add 
		//#60;
		
	end
	
	always #10 clk = ~clk;
	
	
endmodule
