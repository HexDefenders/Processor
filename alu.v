module alu(a, b, aluControl, C, L, F, Z, N, result);		
	input [15:0] a, b;
	input [3:0] aluControl;
	output reg C, L, F, Z, N;
	output reg [15:0] result;
	
	always@(*) begin
		{C, L, F, Z, N} = 0;
		result = 4'd0;
		
		case(aluControl) 
			4'b0000: // Empty case
				{C, L, F, Z, N} <= 0;
			
			4'b0001: begin //SUB or SUBI
			result = b - a; 
				if (result > b)
					{C, F} = 1;
				else 
					{C, F} = 0;
			end
			
			4'b0010: begin //CMP or CMPI
				if (b < a) begin
					L = 1;
					N = 1;
					Z = 0;
				end
				else if (a == b) begin
					L = 0;
					N = 0;
					Z = 1;
				end
				else 
					{L, Z, N} = 0;
			end
			
			4'b0011: //AND or ANDI
				result = a & b; 	
				
			4'b0100: //OR or ORI
				result = a | b;
			
			4'b0101: //XOR or XORI
				result = a ^ b; 
			
			4'b0110: //LUI
				result = {a[7:0], b[7:0]};	
			
			//4'b0111: begin //MOVI
			//	result = b;
			//end
			
			4'b1000: begin //ADD or ADDI
				result = a + b; 
				if (result < b || result < a)
					{C, F} = 1;
				else
					{C, F} = 0;
			end
			
			default:
				{C, L, F, Z, N} = 0;
				
		endcase
	end
endmodule
