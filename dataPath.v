module dataPath(clk, instruction, memdata, aluControl, regFileResultCont, pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn);
	input clk;
	input [15:0] instruction, memdata;
	input [3:0] aluControl;
	//why are some mux 2 control signals 2 bits?
	input [1:0] pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn, regFileResultCont;
	wire pc, src, dst, imm;
	wire [15:0] result, regFileResult;
	wire C, L, F, Z, N;
	
	instructionRegister instructionRegister(instruction, s, OpCode, Rdest, OpCodeExt, Rsrc, instImm);
	
	register pcReg(shiftOrALU, pcRegEn, clk, pc); // PC
	register srcReg(Rsrc, srcRegEn, clk, src); //src
	register dstReg(Rdest, dstRegEn, clk, dst); // dst
	register immReg(instImm, immRegEn, clk, imm); // imm
	register resultReg(shiftOrALU, resultRegEn, clk, result); //result
	
	regfile regFile(clk, regFileEn, src, dst, regFileResult, regOut1, regOut2);
	
	signExtend signExtend(imm, signEn, signOut);
	
	mux2 pcOrRegMux(pc, regOut1, pcRegMuxEn, pcOrReg);
	
	mux4 toALUMux(regOut2, signOut, 1, 0, mux4En, mux4Out);
	
	alu ALU(pcOrReg, mux4Out, aluControl, C, L, F, Z, N, aluResult);
	
	mux2 regOrImmMux(regOut1, signOut, regImmMuxEn, regOrImm);
	
	shifter shifter(regOut2, regOrImm, shiftOut);
	
	mux2 shiftOrALUMux(aluResult, shiftOut, shiftALUMuxEn, shiftOrALU);
	
	//Mux to choose regfile's write data
	//Note: d2 and d3 are extra inputs for testing and debugging
	mux4 RegFileResult(.d0(result), .d1(memdata), .d2(0), .d3(1), .s(regFileResultCont), .y(regFileResult));
	

endmodule 