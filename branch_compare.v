module branch_compare ( 
	input wire br,
	input wire reset,
	input wire [31:0] rs1,
	input wire [31:0] rs2,
	input wire [31:0] imm, 
	
	output reg [31:0] new_address,
	output reg success
);
	
	always @ (*) begin
		if (reset == 1'b1) begin
			new_address = 1;
		end else begin
			if (br) begin
				if (rs1 == rs2) begin
					new_address = imm;
				end
			end
		end
	end	
	

endmodule