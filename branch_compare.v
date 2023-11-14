module branch_compare ( 
	input wire br,
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
			if (br) begin //IF B-TYPE INSTRUCTION
				success = 0;
				if ((rs2 - rs1) == 32'd0) begin //IF BEQ
					new_address = (imm>>1);
					success = 1;
				end
			end
			else begin
				success = 0;
			end	
		end
	end	
	

endmodule