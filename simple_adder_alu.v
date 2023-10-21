module simple_adder_alu ( 
	input wire [31:0] data_in_1,
	input wire [31:0] data_in_2,
	input wire clock,
	
	output reg [31:0] sum

);
	
	always @ (posedge clock) begin
		sum = data_in_1 + data_in_2;
	end	
	

endmodule