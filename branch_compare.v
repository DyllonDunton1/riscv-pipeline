module branch_compare ( 
	input wire [2:0] br,
	input wire reset,
	input wire [31:0] rs1,
	input wire [31:0] rs2,
	input wire [31:0] imm, 
	
	output reg [31:0] new_address,
	output reg success
);
	initial begin
		success = 0;
	end	
	
	always @ (*) begin
		if (reset == 1'b1) begin
			new_address = 1;
			success = 0;
		end else begin
			if (br != 0) begin //IF B-TYPE INSTRUCTION
				success = 0;
				if (((rs2 - rs1) == 32'd0) && br == 3'd1) begin //IF BEQ
					new_address = imm;
					success = 1;
				end
				if (((rs2 - rs1) != 32'd0) && br == 3'd2) begin //IF BNE
					new_address = imm;
					success = 1;
				end
				if (((rs2 - rs1) < 32'd0) && br == 3'd3) begin //IF BLT
					new_address = imm;
					success = 1;
				end
				if (((rs2 - rs1) >= 32'd0) && br == 3'd4) begin //IF BGE
					new_address = imm;
					success = 1;
				end
				if (((rs2 - rs1) < 32'd0) && br == 3'd5) begin //IF BLTU
					new_address = imm;
					success = 1;
				end
				if (((rs2 - rs1) >= 32'd0) && br == 3'd6) begin //IF BGEU
					new_address = imm;
					success = 1;
				end
				if (br == 3'd7) begin //IF JAL
					new_address = imm;
					success = 1;
				end
			end
			else begin
				success = 0;
			end	
		end
	end	
	

endmodule
