module program_counter ( 
	input wire [7:0] previous,
	input wire clock,
	input wire reset,
	input wire stall,
	input wire succ,
	input wire [31:0] new_addr,

	output reg [7:0] current
);

	initial begin
		current = 8'h00400000 - 8'h4;
	end

	always @ (posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			current = 8'h00400000 - 8'h4;
		end else begin
			if (succ == 1) begin
 /* -1 because pc will branch one clock cycle after the instruction is issued */
				current = previous + new_addr - 4;
			end else if (stall == 1) begin
				// the stall will not be received in time
				current = previous;
			end else begin
				current = previous + 4;
			end
		end
	end


endmodule

