module program_counter ( 
	input wire [5:0] previous,
	input wire clock,
	
	output reg [5:0] current
);
	
	initial begin
		current = 0;
	end	
	
	always @ (posedge clock) begin
		current = previous + 32'd1;
	end	
	

endmodule

