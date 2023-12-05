module id_ex (
	input wire [31:0] data_in_1,
	input wire [31:0] data_in_2,
	input wire [4:0] rd_in,
	input wire [31:0] imm_in,
	input wire pcsrc_in,
	input wire alusrc_in,
	input wire memtoreg_in,
	input wire we_in,
   input wire reg_en_in,
	input wire [5:0] aluop_in,
	input wire br_in,
	input wire clock,
   input wire reset,
	input wire [31:0] pipe_pc_in,

	output reg [31:0] data_out_1,
	output reg [31:0] data_out_2,
	output reg [4:0] rd_out,
	output reg [31:0] imm_out,
	output reg pcsrc_out,
	output reg alusrc_out,
	output reg memtoreg_out,
	output reg we_out,
   output reg reg_en_out,
	output reg [5:0] aluop_out,
	output reg br_out,
	output reg [31:0] pipe_pc_out
);

	always @(posedge clock or posedge reset) begin
	if (reset == 1'b1) begin
		data_out_1 = 0;
		data_out_2 = 0;
		rd_out = 0;
		imm_out = 0;
		pcsrc_out = 0;
		alusrc_out = 0;
		memtoreg_out = 0;
		we_out = 0;
		reg_en_out = 0;
		aluop_out = 0;
		br_out = 0;
		pipe_pc_out = 0;
	end else begin
		data_out_1 = data_in_1;
		data_out_2 = data_in_2;
		rd_out = rd_in;
		imm_out = imm_in;
		pcsrc_out = pcsrc_in;
		alusrc_out = alusrc_in;
		memtoreg_out = memtoreg_in;
		we_out = we_in;
		reg_en_out = reg_en_in;
		aluop_out = aluop_in;
		br_out = br_in;
		pipe_pc_out = pipe_pc_in;
	end

	end

endmodule
