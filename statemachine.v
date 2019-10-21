module statemachine(clk, reset, instruction, aluControl, pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn);
	input clk, reset;
	input [15:0] instruction;
	output reg [3:0] aluControl;
	output reg [1:0] pcRegEn, srcRegEn, dstRegEn, immRegEn, resultRegEn, signEn, regFileEn, pcRegMuxEn, mux4En, shiftALUMuxEn, regImmMuxEn;
	reg [5:0] PS, NS;
	// parameter [5:0] S0 = 6'd0, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000;
	parameter [5:0] S0 = 6'd0, S1 = 6'd1, S2 = 6'd2, S3 = 6'd3, S4 = 6'd4, S5 = 6'd5, S6 = 6'd6, S7 = 6'd7, S8 = 6'd8, S9 = 6'd9, S10 = 6'd10, 
						 S11 = 6'd11, S12 = 6'd12, S13 = 6'd13, S14 = 6'd14, S15 = 6'd15, S16 = 6'd16, S17 = 6'd17, S18 = 6'd18, S19 = 6'd19, S20 = 6'd20,
						 S21 = 6'd21, S22 = 6'd22, S23 = 6'd23, S24 = 6'd24, S25 = 6'd25, S26 = 6'd26, S27 = 6'd27, S28 = 6'd28, S29 = 6'd29, S30 = 6'd30,
						 S31 = 6'd31, S32 = 6'd32, S33 = 6'd33, S34 = 6'd34, S35 = 6'd35, S36 = 6'd36, S37 = 6'd37, S38 = 6'd38, S39 = 6'd39, S40 = 6'd40,
						 S41 = 6'd41, S42 = 6'd42, S43 = 6'd43, S44 = 6'd44, S45 = 6'd45, S46 = 6'd46;
						 
	always @(posedge reset, posedge clk) begin
	if (reset)
		PS <= S0;
	else
		PS <= NS;
	end
	
	always@(*) begin
		// initialize control signals
		{pcRegEn, srcRegEn, dstRegEn} = 0;
		//pcRegEn = srcRegEn = dstRegEn = immRegEn = resultRegEn = signEn = regFileEn = pcRegMuxE = mux4En = shiftALUMuxEn = regImmMuxEn = resultRegEn = 0;
		case(instruction)
			S0: begin
				if (instruction[15:12] == 0000) begin // Register
					if (instruction[7:4] == 0101) begin // ADD
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S1;
					end
					if (instruction[7:4] == 1001) begin // SUB
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S2;
					end
					if (instruction[7:4] == 1011) begin // CMP
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S3;
					end
					if (instruction[7:4] == 0001) begin // AND
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S4;
					end
					if (instruction[7:4] == 0010) begin // OR
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S5;
					end
					if (instruction[7:4] == 0011) begin // XOR
						srcRegEn = 1;
						dstRegEn = 1;
						NS <= S6;
					end
					if (instruction[7:4] == 1101) begin // MOV
						NS <= S7;
					end
				end
				
				if (instruction[15:12] == 0100) begin // Special
					if (instruction[7:4] == 0000) // LOAD
						NS <= S8;
					if (instruction[7:4] == 0100) // STOR
						NS <= S9;
					if (instruction[7:4] == 1000) // JAL
						NS <= S10;
					if (instruction[7:4] == 1100) // Jcond
						NS <= S11;
				end
				
				if (instruction[15:12] == 1000) begin // Shift
					if (instruction[7:4] == 0100) // LSH
						NS <= S12;
					if (instruction[7:4] == 0000) // LSHI 
						NS <= S13;
					if (instruction[7:4] == 0001) // LSHI
						NS <= S14;
				end
				
				if (instruction[15:12] == 1100) // Bcond
					NS <= S15;
				if (instruction[15:12] == 0001) begin // ANDI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S16;
				end
				if (instruction[15:12] == 0010) begin // ORI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S17;
				end
				if (instruction[15:12] == 0011) begin // XORI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S18;
				end
				if (instruction[15:12] == 0101) begin // ADDI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S19;
				end
				if (instruction[15:12] == 1001) begin // SUBI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S20;
				end
				if (instruction[15:12] == 1011) begin // CMPI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S21;
				end
				if (instruction[15:12] == 1101) begin // MOVI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S22;
				end
				if (instruction[15:12] == 1111) begin // LUI
					immRegEn = 1;
					dstRegEn = 1;
					NS <= S23;
				end
			end
					
			S1: begin // ADD
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0000;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S2: begin // SUB
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0001;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S3: begin // CMP
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0010;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S4: begin // AND
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0011;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S5: begin // OR
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0100;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S6: begin // XOR
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0101;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S7: begin // MOV
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0110;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S8: begin // LOAD
				
			end
			
			S9: begin // STOR
				
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
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0011;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S17: begin // ORI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0100;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S18: begin // XORI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0101;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S19: begin // ADDI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0000;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S20: begin // SUBI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0001;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0; 
			end
			
			S21: begin // CMPI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0010;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S22: begin // MOVI
				regFileEn = 1;
				pcRegMuxEn = 1;
				aluControl = 0011;
				shiftALUMuxEn = 0;
				resultRegEn = 1;
				NS <= 0;
			end
			
			S23: begin // LUI
			
			end
			
			
			
			S24: begin // LUI
			
			end
			
			S25: begin // LUI
			
			end
			
			S26: begin // LUI
			
			end
			
			S27: begin // LUI
			
			end
			
			S28: begin // LUI
			
			end
			
			S29: begin // LUI
			
			end
			
			S30: begin // LUI
			
			end
			
			S31: begin // LUI
			
			end
				
			S32: begin // LUI
			
			end
			
			S33: begin // LUI
			
			end
			
			S34: begin // LUI
			
			end
			
			S35: begin // LUI
			
			end
			
			S36: begin // LUI
			
			end
			
			S37: begin // LUI
			
			end
			
			S38: begin // LUI
			
			end
			
			S39: begin // LUI
			
			end
			
			S40: begin // LUI
			
			end
			
			S41: begin // LUI
			
			end
			
			S42: begin // LUI
			
			end
			
			S43: begin // LUI
			
			end
			
			S44: begin // LUI
			
			end
			
			S45: begin // LUI
			
			end
			
			S46: begin // LUI
			
			end
					
		endcase
	end
endmodule
