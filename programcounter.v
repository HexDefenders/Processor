module programcounter(clk, en, pc);
	input clk, en;
	output reg [3:0] pc = 4'b0;
	always@(posedge clk) begin
		if(en)
			pc <= pc + 1'b1;
			
		else
			pc <= pc;
	end
endmodule 