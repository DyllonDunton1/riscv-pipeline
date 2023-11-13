// data_memory_reset_controller.v

module data_memory_reset_controller(
	input wire clock,
	input wire project_clock_in,
	input wire reset,

	input wire [31:0] data_in,
	input wire [31:0] data_rst_in,
	input wire [5:0] address_in,
	input wire wren_in,

	output reg [31:0] data_out,
	output reg [5:0] address_out,
	output reg wren_out,
	output reg project_clock_out
);

	initial begin
		address_out = 0;
	end

	reg flip_flop;

	always @(posedge clock) begin
		/* if there is reset button, cycles thru reset data and writes
		* to in-use data while button pressed */
		if (reset == 1'b1) begin
			wren_out = 1;
			if (flip_flop) begin
				data_out = data_rst_in;
				project_clock_out = 1;
			end else begin
				address_out = address_out + 1;
				project_clock_out = 0;
			end
			flip_flop = !flip_flop;
		/* if there is no reset button, act as passthru */
		end else begin
			address_out = address_in;
			data_out = data_in;
			wren_out = wren_in;
			project_clock_out = project_clock_in;
		end
	end

endmodule
