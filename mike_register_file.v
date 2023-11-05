// file register_file.v

module register_file(
	input wire [4:0] read_address_1,
	input wire [4:0] read_address_2,
	input wire [31:0] write_data_in,
	input wire [4:0] write_address,

	input wire write_enable,
	input wire reset,
	input wire clock,

	input wire [4:0] read_address_debug,
	input wire clock_debug,

	output reg [31:0] data_out_1,
	output reg [31:0] data_out_2,
	output reg [31:0] data_out_debug
);
	reg [31:0] r [31:0];
	integer i;

	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			r[i] <= 0;
		end
	end

	always @(posedge clock or posedge reset) begin
		/* set the data_out based on read_address */
		data_out_1 <= r[read_address_1];
		data_out_2 <= r[read_address_2];

		if (reset == 1'b1) begin
			for (i = 0; i < 32; i = i + 1) begin
				r[i] <= i;
			end
		end else if ((write_enable == 1'b1) && write_address != 0) begin
			r[write_address] <= write_data_in;
		end

	end

	always @(posedge clock_debug) begin
		data_out_debug <= r[read_address_debug];
	end

endmodule
