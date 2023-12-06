// file clock_mux.v
module clock_mux(
	input wire clock_50,
	input wire key_clock,

	input wire [1:0] select,

	output reg clock_out
);

	reg [19:0] divisor;
	reg clock1;
	reg clock2;

	initial begin
		divisor = 0;
		clock1 = 0;
		clock2 = 0;
	end

	// other clock outputs are divisions of clock_50
	always @(posedge clock_50) begin
		if (select == 2'b10) begin
			clock1 <= divisor[14];
		end else
		if (select == 2'b01) begin
			clock2 <= divisor[19];
		end

		divisor <= divisor + 1;
	end

	always @(*) begin
		if (select == 2'b00) begin
			clock_out <= key_clock;
		end else
		if (select == 2'b10) begin
			clock_out <= clock1;
		end else
		if (select == 2'b01) begin
			clock_out <= clock2;
		end
	end

endmodule
