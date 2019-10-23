module tb_top();
	reg clk, reset;
	wire [15:0] instruction;
	
	top uut(.clk(clk), .rst(rst));
	
	initial begin
		//instruction = 0100000000000000; // Store
	end
	
endmodule
