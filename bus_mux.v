module bus_mux ( 
	input wire [31:0] data_in_1,
	input wire [31:0] data_in_2,
	input wire select,
	
	output reg [31:0] data_out

);
	
	always @ (*) begin
		case (select)
			0	:	data_out = data_in_1;
			1	:	data_out = data_in_2;
		endcase	
		
	end	
	

endmodule