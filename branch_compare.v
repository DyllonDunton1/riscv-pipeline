module branch_compare ( 
	input wire [3:0] br,
	input wire reset,
	input wire [31:0] rs1,
	input wire [31:0] rs2,
	input wire [31:0] imm,
	input wire [31:0] pc_val,
	
	output reg [31:0] new_address,
	output reg success
);

	reg signed [31:0] comp1minus2;

	initial begin
		success = 0;
	end


	always @ (*) begin
		if (reset == 1'b1) begin
			new_address = 32'h00400004;
			success = 0;
		end else begin
			if (br != 0) begin //IF B-TYPE INSTRUCTION
				success = 0;
				comp1minus2 = rs1 - rs2;

				if ((comp1minus2 == 32'd0) && br == 4'd1) begin //IF BEQ
					new_address = pc_val + imm;
					success = 1;
				end else
				if ((comp1minus2 != 32'd0) && br == 4'd2) begin //IF BNE
					new_address = pc_val + imm;
					success = 1;
				end else
				if ((comp1minus2[31] == 1'b1) && br == 4'd3) begin //IF BLT
					new_address = pc_val + imm;
					success = 1;
				end else
				if ((comp1minus2[31] == 1'b0) && br == 4'd4) begin //IF BGE
					new_address = pc_val + imm;
					success = 1;
				end else
				if ((comp1minus2[31] == 1'b1) && br == 4'd5) begin //IF BLTU
					new_address = pc_val + imm;
					success = 1;
				end else
				if ((comp1minus2[31] == 1'b0) && br == 4'd6) begin //IF BGEU
					new_address = pc_val + imm;
					success = 1;
				end else
				if (br == 4'd7) begin //IF JAL
					new_address = pc_val + imm;
					success = 1;
				end else
				if	(br == 4'd8) begin
					new_address = imm + rs1;
					success = 1;
				end
			end
			else begin
				success = 0;
			end	
		end
	end	
	

endmodule
