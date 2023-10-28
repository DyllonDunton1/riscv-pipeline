module mem_wb ( 
	input wire [31:0] data_in_2,
	input wire [4:0] rd_in,
        input wire reg_en_in,
	input wire clock,
	
	output reg [31:0] data_out_2,
	output reg [4:0] rd_out,
        output reg reg_en_out
);
	
	always @ (posedge clock) begin
		data_out_2 = data_in_2;
		rd_out = rd_in;
                reg_en_out = reg_en_in;
	end	
	

endmodule
