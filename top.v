module top(clk, rst, instruction); //add I/O devices to this list later on

	input clk, rst;
	input [15:0] instruction;
	
	wire memread, memwrite;
	wire [15:0] memdata, adr, writedata, instruction, srcData, dstData;
	wire [3:0] aluControl;
	wire [1:0] mux4En, regpcCont;
	wire [3:0] pc;
	wire pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, shiftALUMuxEn, regImmMuxEn, exMemResultEn, pcEn, irS;
	wire en;
	
	
	programcounter programcounter(.clk(clk), .en(pcEn), .pc(pc));
	
	statemachine SM(.clk(clk), .reset(rst), .instruction(instruction), .aluControl(aluControl), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), .dstRegEn(dstRegEn), .immRegEn(immRegEn), 
						.resultRegEn(resultRegEn), .signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), .shiftALUMuxEn(shiftALUMuxEn), 
						.regImmMuxEn(regImmMuxEn), .exMemResultEn(exMemResultEn), .memread(memread), .memwrite(memwrite), .pcEn(pcEn), .irS(irS), .regpcCont(regpcCont));
						
	dataPath DP(.clk(clk), .pc(pc), .memdata(memdata), .aluControl(aluControl), .exMemResultEn(exMemResultEn), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), 
					.dstRegEn(dstRegEn), .immRegEn(immRegEn), .resultRegEn(resultRegEn), .signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), 
					.shiftALUMuxEn(shiftALUMuxEn), .irS(irS), .regImmMuxEn(regImmMuxEn), .regpcCont(regpcCont), .srcData(srcData), .dstData(dstData), .adr(adr));
		
	assign en = 1;
	//clk = ~clk??
	exmem mem(.clk(~clk), .en(en), .memwrite(memwrite), .memread(memread), .adr(adr), .writedata(dstData), .memdata(memdata));
	
	//Initializing when in I/O space. Adr is 16 bits, I/O space = if top two bits are 11 (NEEDS TO BE CHANGED LATER!!!!!!!!!!!!!)
//	always @(adr)
//    case (adr[15:14])
//      2'b00:	en = 1'b1;
//      2'b01:	en = 1'b1;
//      2'b10:	en = 1'b1;
//      2'b11:	en = 1'b1;
//      default:	en = 1'b1;
//    endcase
  
endmodule  