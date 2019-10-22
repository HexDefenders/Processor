module top(clk, rst); //add I/O devices to this list later on

	input clk, rst;
	
	wire memread, memwrite;
	wire [15:0] memdata, adr, writedata, instruction;
	wire [3:0] aluControl;
	wire [1:0] pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn;
	wire reg en;
	
	
	statemachine SM(.clk(clk), .reset(rst), .instruction(instruction), .aluControl(aluControl), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), .dstRegEn(dstRegEn), .immRegEn(immRegEn), 
						.resultRegEn(resultRegEn), .signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), .shiftALUMuxEn(shiftALUMuxEn), .regImmMuxEn(regImmMuxEn), .regFileResultCont(regFileResultCont),
						.memread(memread), .memwrite(memwrite), .writedata(writedata));
						
	dataPath DP(.clk(clk), .instruction(instruction), .memdata(memdata), .aluControl(aluControl), .regFileResultCont(regFileResultCont), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), .dstRegEn(dstRegEn), .immRegEn(immRegEn), .resultRegEn(resultRegEn), 
					.signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), .shiftALUMuxEn(shiftALUMuxEn), .regImmMuxEn(regImmMuxEn));
		
	
	//clk = ~clk??
	exmem mem(.clk(~clk), .en(en), .memwrite(memwrite), .memread(memread), .adr(adr), .writedata(writedata), .memdata(memdata));
	
	//Initializing when in I/O space. Adr is 16 bits, I/O space = if top two bits are 11 (NEEDS TO BE CHANGED LATER!!!!!!!!!!!!!)
	always @(adr)
    case (adr[15:14])
      2'b00:	en = 1'b1;
      2'b01:	en = 1'b1;
      2'b10:	en = 1'b1;
      2'b11:	en = 1'b0;
      default:	en = 1'b1;
    endcase
  
endmodule  