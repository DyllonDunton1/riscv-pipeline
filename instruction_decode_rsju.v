module instruction_decode_rsju ( 
	input wire [31:0] data_in,
	input wire clock,
	
	output reg [39:0] char_out
);
	
	always @ (posedge clock) begin
				
		if (data_in[6:0] == 7'b0110011) begin
			//R-TYPE
			if (data_in[14:12] == 3'h0) begin
				//add or sub
				if (data_in[31:25] == 7'h00) begin
					//add
					char_out = "ADD  ";
				end
				else begin
					//sub
					char_out = "SUB  ";
				end
			end
			if (data_in[14:12] == 3'h1) begin
				//shift left logical
				char_out = "SLL  ";
			end
			if (data_in[14:12] == 3'h2) begin
				//set less than
				char_out = "SLT  ";
			end
			if (data_in[14:12] == 3'h3) begin
				//set less than u
				char_out = "SLTU ";
			end
			if (data_in[14:12] == 3'h4) begin
				//xor 
				char_out = "XOR  ";
			end
			if (data_in[14:12] == 3'h5) begin
				//shift right (log or arth)
				if (data_in[31:25] == 7'h00) begin
					//shift right logical
					char_out = "SRL  ";
				end
				else begin
					//shift right arith
					char_out = "SRA  ";
				end
			end
			if (data_in[14:12] == 3'h6) begin
				//or 
				char_out = "OR   ";
			end
			if (data_in[14:12] == 3'h7) begin
				//and
				char_out = "AND  ";
			end
		end
		if (data_in[6:0] == 7'b0100011) begin
			//S-TYPE
			if (data_in[14:12] == 3'h0) begin
				//store byte
				char_out = "SB   ";
			end
			if (data_in[14:12] == 3'h1) begin
				//store half
				char_out = "SH   ";
			end
			if (data_in[14:12] == 3'h2) begin
				//store word
				char_out = "SW   ";
			end
		end
		if (data_in[6:0] == 7'b1101111) begin
			//J-TYPE
			//jump and link
			char_out = "JAL  ";
		end
		if (data_in[6:0] == 7'b0110111) begin
			//U-TYPE
			//load upper imm
			char_out = "LUI  ";
		end
		if (data_in[6:0] == 7'b0010111) begin
			//U-TYPE
			//add upper imm to pc
			char_out = "AUIPC";
		end
	end	
	

endmodule