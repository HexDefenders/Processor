module tb_statemachine();
	reg clk, reset;
	reg [15:0] instruction;
	wire [3:0] aluControl;
	wire [1:0] pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn;
	
	statemachine uut();
	
	initial begin
		// Initiaize values
		clk = 0;
		reset = 0;
		#5;
		
		reset = 1; #10;
		reset = 0; #20;
		
		instruction = 0010000001000000; // STORE
	end		
		
endmodule 