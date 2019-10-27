module statemachine(clk, reset, instruction, aluControl, pcRegEn, srcRegEn, dstRegEn, immRegEn, 
						resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn, exMemResultEn, memread, memwrite);
	input clk, reset;
	input [15:0] instruction;
	output reg [3:0] aluControl;
	output reg pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, shiftALUMuxEn, regImmMuxEn, 
							exMemResultEn, memread, memwrite;
	output reg [1:0] mux4En;
	reg [5:0] PS, NS;
	parameter [5:0] S0 = 6'd0, S1 = 6'd1, S2 = 6'd2, S3 = 6'd3, S4 = 6'd4, S5 = 6'd5, S6 = 6'd6, S7 = 6'd7, S8 = 6'd8, S9 = 6'd9, S10 = 6'd10, 
						 S11 = 6'd11, S12 = 6'd12, S13 = 6'd13, S14 = 6'd14, S15 = 6'd15, S16 = 6'd16, S17 = 6'd17, S18 = 6'd18, S19 = 6'd19, S20 = 6'd20,
						 S21 = 6'd21, S22 = 6'd22, S23 = 6'd23, S24 = 6'd24;
						 
	always @(posedge reset, posedge clk) begin
	if (reset)
		PS <= S0;
	else
		PS <= NS;
	end
	
	always@(*) begin
		// initialize control signals
		{pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, 
		shiftALUMuxEn, regImmMuxEn, resultRegEn, exMemResultEn, memread, memwrite} <= 1'd0;
		aluControl = 4'b0;
		mux4En = 2'b0;
		NS = 6'b0;
		
		case(PS)
			S0: begin
				if (instruction[15:12] == 0000) begin // Register
					if (instruction[7:4] == 4'b0101) begin // ADD
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S1;
					end
					else if (instruction[7:4] == 4'b1001) begin // SUB
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S2;
					end
					else if (instruction[7:4] == 4'b1011) begin // CMP
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S3;
					end
					else if (instruction[7:4] == 4'b0001) begin // AND
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S4;
					end
					else if (instruction[7:4] == 4'b0010) begin // OR
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S5;
					end
					else if (instruction[7:4] == 4'b0011) begin // XOR
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S6;
					end
					else if (instruction[7:4] == 4'b1101) begin // MOV
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S7;
					end
				end
				
				else if (instruction[15:12] == 4'b0100) begin // Special
					if (instruction[7:4] == 4'b0000) begin // LOAD
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S8;
					end
					else if (instruction[7:4] == 4'b0100) begin // STOR
						srcRegEn <= 1;
						dstRegEn <= 1;
						NS <= S9;
					end
					else if (instruction[7:4] == 1000) begin// JAL
						NS <= S10;
					end
					else if (instruction[7:4] == 1100) begin// Jcond
						NS <= S11;
					end
				end
				
				else if (instruction[15:12] == 1000) begin // Shift
					if (instruction[7:4] == 0100) begin// LSH
						NS <= S12;
					end
					else if (instruction[7:4] == 0000) begin // LSHI 
						NS <= S13;
					end
					else if (instruction[7:4] == 0001) begin // LSHI
						NS <= S14;
					end
				end
				
				else if (instruction[15:12] == 4'b1100) begin // Bcond
					NS <= S15;
				end
				else if (instruction[15:12] == 4'b0001) begin // ANDI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S16;
				end
				else if (instruction[15:12] == 4'b0010) begin // ORI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S17;
				end
				else if (instruction[15:12] == 4'b0011) begin // XORI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S18;
				end
				else if (instruction[15:12] == 4'b0101) begin // ADDI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S19;
				end
				else if (instruction[15:12] == 4'b1001) begin // SUBI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S20;
				end
				else if (instruction[15:12] == 4'b1011) begin // CMPI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S21;
				end
				else if (instruction[15:12] == 4'b1101) begin // MOVI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S22;
				end
				else if (instruction[15:12] == 4'b1111) begin // LUI
					immRegEn <= 1;
					dstRegEn <= 1;
					NS <= S23;
				end
			end
					
			S1: begin // ADD
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 4'b1000;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= S0; 
			end
			
			S2: begin // SUB
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 0001;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0; 
			end
			
			S3: begin // CMP
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 0010;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S4: begin // AND
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 0011;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0; 
			end
			
			S5: begin // OR
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 4'b0100;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S6: begin // XOR
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 4'b0101;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S7: begin // MOV
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 0;
				aluControl <= 4'b0110;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S8: begin // LOAD
				regFileEn <= 1;
				memread <= 1;
				memwrite <= 0;
				exMemResultEn <= 1;
			end
			
			S9: begin // STOR
				regFileEn <= 0;
				memread <= 0;
				memwrite <= 1;
				exMemResultEn <= 1;
			end
			
			S10: begin // JAL
				
			end
			
			S11: begin // Jcond
				
			end
			
			S12: begin // LSH
			
			end
			
			S13: begin // LSHI
			
			end
			
			S14: begin // LSHI
			
			end
			
			S15: begin // Bcond
			
			end
			
			S16: begin // ANDI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 4'b0011;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0; 
			end
			
			S17: begin // ORI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 4'b0100;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S18: begin // XORI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 4'b0101;
				shiftALUMuxEn <=0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S19: begin // ADDI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 0000;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0; 
			end
			
			S20: begin // SUBI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 0001;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0; 
			end
			
			S21: begin // CMPI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 0010;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S22: begin // MOVI
				regFileEn <= 1;
				pcRegMuxEn <= 1;
				mux4En <= 01;
				aluControl <= 0011;
				shiftALUMuxEn <= 0;
				resultRegEn <= 1;
				NS <= 0;
			end
			
			S23: begin // LUI
			
			end
					
		endcase
	end
endmodule
