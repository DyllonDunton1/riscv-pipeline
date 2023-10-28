module ex_mem ( 
	input wire [31:0] data_in_1,
	input wire [31:0] data_in_2,
	input wire [4:0] rd_in,
	input wire memtoreg_in,
	input wire we_in,
	input wire clock,
	
	output reg [31:0] data_out_1,
	output reg [31:0] data_out_2,
	output reg [4:0] rd_out,
	output reg memtoreg_out,
	output reg we_out
);
	
	always @ (posedge clock) begin
		data_out_1 = data_in_1;
		data_out_2 = data_in_2;
		rd_out = rd_in;
		memtoreg_out = memtoreg_in;
		we_out = we_in;
	end	
	

endmodule