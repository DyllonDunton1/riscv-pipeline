module if_id ( 
	input wire [31:0] instruction_in,
	input wire clock,
	
	output reg [31:0] instruction_out
);
	
	always @ (posedge clock) begin
		instruction_out = instruction_in;
	end	
	

endmodule