module hazard_detect(
	input wire [31:0] instr_in,
	input wire [4:0] rd_t_minus_1,
	input wire [4:0] rd_t_minus_2,

	output reg [31:0] instr_out,
	output reg stall
);

	always @(*) begin
		if ( (rd_t_minus_1 == instr_in[19:15] && rd_t_minus_1 != 0)
		   ||(rd_t_minus_2 == instr_in[19:15] && rd_t_minus_2 != 0)
		   ||(rd_t_minus_1 == instr_in[24:20] && rd_t_minus_1 != 0)
		   ||(rd_t_minus_2 == instr_in[24:20] && rd_t_minus_2 != 0))
		begin
			stall <= 1;
			instr_out <= 0;
		end else begin
			stall <= 0;
			instr_out <= instr_in;
		end
	end

endmodule
