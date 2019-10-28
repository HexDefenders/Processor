module dataPath(clk, reset, memdata, instruction, aluControl, exMemResultEn, pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, 
					 regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, irS, regImmMuxEn, regpcCont, srcData, dstData, adr, signOut);
	input clk, reset;
	input [15:0] instruction, memdata;
	input [3:0] aluControl;
	//why are some mux 2 control signals 2 bits?
	input pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, shiftALUMuxEn, regImmMuxEn, 
					exMemResultEn, irS;
	input [1:0] mux4En, regpcCont;
	wire [3:0] src, dst, Rsrc, Rdest, OpCode, OpCodeExt;
	wire [15:0] result, exMemOrResult, shiftOrALU, regFileResult, pcOrReg, mux4Out, aluResult, regOrImm, shiftOut;
	wire [7:0] instImm, imm;
	wire C, L, F, Z, N;
	output [15:0] srcData, dstData, adr, signOut;
	//output [3:0] pc;
	
	/* FOR TESTING */
	instructionRegister instructionRegister(.inst(instruction), .s(irS), .OpCode(OpCode), .Rdest(Rdest), .OpCodeExt(OpCodeExt), .Rsrc(Rsrc), .imm(instImm));
	/* */
	
	//instructionRegister instructionRegister(.inst(memdata), .s(irS), .OpCode(OpCode), .Rdest(Rdest), .OpCodeExt(OpCodeExt), .Rsrc(Rsrc), .imm(instImm));
	
	//register pcReg(.D(aluResult), .En(pcRegEn), .clk(clk), .Q(pc)); // program counter
	register srcReg(.D({12'b0, Rsrc}), .En(srcRegEn), .clk(clk), .Q(src)); // src
	register dstReg(.D({12'b0, Rdest}), .En(dstRegEn), .clk(clk), .Q(dst)); // dst
	register immReg(.D({8'b0, instImm}), .En(immRegEn), .clk(clk), .Q(imm)); // imm
	register resultReg(.D(shiftOrALU), .En(resultRegEn), .clk(clk), .Q(result)); // result
	
	//Mux to choose regfile's write data
	//Note: d2 and d3 are extra inputs for testing and debugging
	//mux4 RegFileResult(.d0(result), .d1(memdata), .d2(0), .d3(1), .s(regFileResultCont), .y(regFileResult));
	mux2 exMemOrResultMux(.d0(result), .d1(memdata), .s(exMemResultEn), .y(regFileResult));
	
	regfile regFile(.clk(clk), .regwrite(regFileEn), .ra1(src), .ra2(dst), .wd(regFileResult), .rd1(srcData), .rd2(dstData));
	
	signExtend signExtend(.in(imm), .s(signEn), .out(signOut));
	
	//mux2 pcOrRegMux(.d0(pc), .d1(dstData), .s(pcRegMuxEn), .y(pcOrReg));
	
	mux4 toALUMux(.d0(srcData), .d1(signOut), .d2(1), .d3(0), .s(mux4En), .y(mux4Out));
	
	alu ALU(.a(mux4Out), .b(pcOrReg), .aluControl(aluControl), .C(C), .L(L), .F(F), .Z(Z), .N(N), .result(aluResult));
	
	mux2 regOrImmMux(.d0(srcData), .d1(signOut), .s(regImmMuxEn), .y(regOrImm));
	
	shifter shifter(.in(dstData), .s(regOrImm), .out(shiftOut));
	
	mux2 shiftOrALUMux(.d0(aluResult), .d1(shiftOut), .s(shiftALUMuxEn), .y(shiftOrALU));
	
	//d1 use to be pc
	mux4 srcRegOrPCMux(.d0(srcData), .d1(0), .d2(result), .d3(0), .s(regpcCont), .y(adr));

endmodule 