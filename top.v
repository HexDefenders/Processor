module top(clk, rst, gpio1, board_switches, board_btns, hsync, vsync, vga_blank_n, vga_clk, r, g, b);

	input clk, rst;
	input [35:0] gpio1;
	input [9:0] board_switches;
	input [3:1] board_btns;
	output hsync, vsync, vga_blank_n, vga_clk;
	output [7:0] r, g, b;
	
	wire memread, memwrite, link;
	wire [15:0] memdata, adr, instruction, srcData, dstData, imm, p1, p2, p3, p4, randomVal;
	wire [3:0] aluControl;
	wire [1:0] mux4En, pcEn, exMemResultEn;
	wire [4:0] nextpc;
	wire C, L, F, Z, N, pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, pcRegMuxEn, shiftALUMuxEn, regImmMuxEn, irS;
	wire playerInputFlag;
	
	reg en;
	
	programcounter programcounter(.clk(clk), .rst(rst), .en(pcEn), .newAdr(dstData), .imm(imm), .nextpc(nextpc));
	
	statemachine SM(.clk(clk), .reset(rst), .C(C), .L(L), .F(F), .Z(Z), .N(N), .instruction(instruction), .aluControl(aluControl), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), 
						.dstRegEn(dstRegEn), .immRegEn(immRegEn), .resultRegEn(resultRegEn), .signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), 
						.shiftALUMuxEn(shiftALUMuxEn), .regImmMuxEn(regImmMuxEn), .exMemResultEn(exMemResultEn), .memread(memread), .memwrite(memwrite), .link(link), .pcEn(pcEn), .irS(irS));
						
	dataPath DP(.clk(clk), .memdata(memdata), .instruction(instruction), .aluControl(aluControl), .exMemResultEn(exMemResultEn), .pcRegEn(pcRegEn), .srcRegEn(srcRegEn), 
					.dstRegEn(dstRegEn), .immRegEn(immRegEn), .resultRegEn(resultRegEn), .signEn(signEn), .regFileEn(regFileEn), .pcRegMuxEn(pcRegMuxEn), .mux4En(mux4En), 
					.shiftALUMuxEn(shiftALUMuxEn), .irS(irS), .regImmMuxEn(regImmMuxEn), .srcData(srcData), .dstData(dstData), .adr(adr), .signOut(imm),
					.C(C), .L(L), .F(F), .Z(Z), .N(N));
		
	exmem mem(
		.clk(~clk), .rst(rst), .en(en), .pc(nextpc), .memwrite(memwrite), .memread(memread), .link(link),
		.adr(srcData), .writedata(dstData), .memdata(memdata), .instruction(instruction), .randomVal(randomVal),
		.p1(p1), .p2(p2), .p3(p3), .p4(p4), .playerInputFlag(playerInputFlag)
	);
	
	vga vga (
		.clk(clk), .rst(rst), 
		.value(randomVal[7:0]), .p1(p1), .p2(p2), .p3(p3), .p4(p4), 
		.hsync(hsync), .vsync(vsync), .vga_blank_n(vga_blank_n), .vga_clk(vga_clk), .r(r), .g(g), .b(b)
	);
	
	controllers controllers (
		.gpins(gpio1), .playerInput(), .playerInputFlag(playerInputFlag), .firstPlayerFlag(), .switchInput()
	);


	always@(adr) begin
		if (adr >= 16'd43) //I/O Space --> this will be updated to be 16'hC000
			en <= 0;
		else if (adr <= 16'd31) //Program/Application Space --> this will be updated to be 16'hA000
			en <= 1;
		else //Data space that exists between Application and I/O Space
			en <= 1;
	end
	
endmodule  