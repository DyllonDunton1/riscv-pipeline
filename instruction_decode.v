// file instruction_decode.v

module instruction_decode(
	input clock,
	input [31:0] data_in,
	input reset,
	input succ,


	output reg [4:0] rs1,
	output reg [4:0] rs2,
	output reg [4:0] rd,
	output reg [6:0] opcode,
	output reg [2:0] func3,
	output reg [6:0] func7,
	output reg [31:0] imm
);

	always @(posedge clock or posedge reset) begin
	if (reset == 1'b1) begin
		imm	<= 0;
		rs1	<= 0;
		rs2	<= 0;
		rd	<= 0;
		opcode	<= 0;
		func3	<= 0;
		func7	<= 0;
	end else
	if (succ == 1'b1) begin
		imm	<= 0;
		rs1	<= 0;
		rs2	<= 0;
		rd	<= 0;
		opcode <= 0;
		func3	<= 0;
		func7	<= 0;
	end else	begin
		opcode <= data_in[6:0];

		rs1 <= data_in[19:15];
		rs2 <= data_in[24:20];
		rd <= data_in[11:7];

		func3 <= data_in[14:12];
		func7 <= data_in[31:25];

		if (data_in[6:0] == 7'b0110011) begin
		/* R-TYPE */
			imm[31:0] <= 0;

		end else if (data_in[6:0] == 7'b0010011) begin
		/* I TYPE */

			imm[31:12] <= 0;
			imm[11:0] <= data_in[31:20];

		end else if (data_in[6:0] == 7'b0000011) begin
		/* I TYPE */

			imm[31:12] <= 0;
			imm[11:0] <= data_in[31:20];

		end else if (data_in[6:0] == 7'b1100111) begin
		/* I TYPE */

			imm[31:12] <= 0;
			imm[11:0] <= data_in[31:20];

		end else if (data_in[6:0] == 7'b0100011) begin
		/* S-TYPE */

			imm[31:12] <= 0;
			imm[11:5] <= data_in[31:25];
			imm[4:0] <= data_in[11:7];

		end else if (data_in[6:0] == 7'b1100011) begin
		/* B TYPE */

			imm[31:13] <= 0;
			imm[12] <= data_in[31];
			imm[11] <= data_in[7];
			imm[10:5] <= data_in[30:25];		
			imm[4:1] <= data_in[11:8];
			imm[0] <= 1'b0;

		end else if (data_in[6:0] == 7'b0110111) begin
		/* U-TYPE */

			imm[31:12] <= data_in[31:12];
			imm[11:0] <= 0;

		end else if (data_in[6:0] == 7'b0010111) begin
		/* U-TYPE */

			imm[31:12] <= data_in[31:12];
			imm[11:0] <= 0;

		end else if (data_in[6:0] == 7'b1101111) begin
		/* J-TYPE */

			imm[31:21] <= 0;
			imm[20] <= data_in[31];
			imm[19:12] <= data_in[19:12];
			imm[11] <= data_in[20];
			imm[10:1] <= data_in[30:21];
			imm[0] <= 0;

		end
	end
	end
endmodule
