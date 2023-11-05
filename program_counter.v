module program_counter ( 
	input wire [5:0] previous,
	input wire clock,
	input wire reset,
	
	output reg [5:0] current
);
	
	initial begin
		current = -1;
	end
	
	always @ (posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			current = 6'd63;
		end else begin
			current = previous + 6'd1;
		end
	end	
	

endmodule

