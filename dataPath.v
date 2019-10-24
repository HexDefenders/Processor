module dataPath(clk, instruction, memdata, aluControl, exMemResultEn, pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, 
					 regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn, srcData, dstData);
	input clk;
	input [15:0] instruction, memdata;
	input [3:0] aluControl;
	//why are some mux 2 control signals 2 bits?
	input [1:0] pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn, 
					exMemResultEn;
	wire pc, imm;
	wire [3:0] src, dst, Rsrc, Rdest, OpCode, OpCodeExt;
	wire [15:0] result, exMemOrResult, shiftOrALU, regFileResult, signOut, pcOrReg, mux4Out, aluResult, regOrImm, shiftOut;
	wire [7:0] instImm;
	wire C, L, F, Z, N, s;
	output [15:0] srcData, dstData;
	
	instructionRegister instructionRegister(instruction, s, OpCode, Rdest, OpCodeExt, Rsrc, instImm);
	
	register pcReg(.D(shiftOrALU), .En(pcRegEn), .clk(clk), .Q(pc)); // program counter
	register srcReg(.D(Rsrc), .En(srcRegEn), .clk(clk), .Q(src)); // src
	register dstReg(.D(Rdest), .En(dstRegEn), .clk(clk), .Q(dst)); // dst
	register immReg(.D(instImm), .En(immRegEn), .clk(clk), .Q(imm)); // imm
	register resultReg(.D(shiftOrALU), .En(resultRegEn), .clk(clk), .Q(result)); // result
	
	//Mux to choose regfile's write data
	//Note: d2 and d3 are extra inputs for testing and debugging
	//mux4 RegFileResult(.d0(result), .d1(memdata), .d2(0), .d3(1), .s(regFileResultCont), .y(regFileResult));
	mux2 exMemOrResultMux(.d0(result), .d1(memdata), .s(exMemResultEn), .y(regFileResult));
	
	regfile regFile(clk, regFileEn, src, dst, regFileResult, srcData, dstData);
	
	signExtend signExtend(imm, signEn, signOut);
	
	mux2 pcOrRegMux(pc, srcData, pcRegMuxEn, pcOrReg);
	
	mux4 toALUMux(dstData, signOut, 1, 0, mux4En, mux4Out);
	
	alu ALU(pcOrReg, mux4Out, aluControl, C, L, F, Z, N, aluResult);
	
	mux2 regOrImmMux(srcData, signOut, regImmMuxEn, regOrImm);
	
	shifter shifter(dstData, regOrImm, shiftOut);
	
	mux2 shiftOrALUMux(aluResult, shiftOut, shiftALUMuxEn, shiftOrALU);
	
	

endmodule 