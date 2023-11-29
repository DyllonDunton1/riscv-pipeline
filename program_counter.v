module program_counter ( 
	input wire [5:0] previous,
	input wire clock,
	input wire reset,
	input wire stall,
	input wire succ,
	input wire [31:0] new_addr,
	
	output reg [5:0] current
);
	
	initial begin
		current = -1;
	end
	
	always @ (posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			current = 6'd63;
		end else begin
			if (succ == 1) begin
 /* -1 because pc will branch one clock cycle after the instruction is issued */
				current = previous + (new_addr >> 2) - 1;
			end else if (stall == 1) begin
				// the stall will not be received in time
				current = previous;
			end else begin
				current = previous + 1;
			end	
		end
	end	
	

endmodule

