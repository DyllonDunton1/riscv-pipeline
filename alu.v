module alu ( 
	input wire [31:0] data_in_1,
	input wire [31:0] data_in_2,
	input wire [5:0] alu_op,
	input wire clock,
	input wire reset,


	output reg [31:0] data_out,
	output reg zero

);
	always @(posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			data_out = 0;
		end else begin
			if (data_in_1 == data_in_2) begin
				zero = 1;
			end else begin
				zero = 0;
			end

			case (alu_op)
				6'd0	:	data_out = data_in_1 + data_in_2; //ADD
				6'd1	:	data_out = data_in_1 - data_in_2; //SUB
				6'd2	:	data_out = data_in_1 ^ data_in_2; //XOR
				6'd3	:	data_out = data_in_1 | data_in_2; //OR
				6'd4	:	data_out = data_in_1 & data_in_2; //AND
				6'd5	:	data_out = data_in_1 << data_in_2; //SLL
				6'd6	:	data_out = data_in_1 >> data_in_2; //SRL
				6'd7	:	data_out = data_in_1 >> data_in_2; //SRA (MAYBE CHANGE FOR SIGNEDNESS)
				6'd8	:	data_out = (data_in_1 < data_in_2) ? 1 : 0; //SLT
				6'd9	:	data_out = (data_in_1 < data_in_2) ? 1 : 0; //SLTU (MAYBE CHANGE FOR SIGNEDNESS)

				6'd10	:	data_out = data_in_1 + data_in_2; //ADDI
				6'd11	:	data_out = data_in_1 ^ data_in_2; //XORI
				6'd12	:	data_out = data_in_1 | data_in_2; //ORI
				6'd13	:	data_out = data_in_1 & data_in_2; //ANDI
				6'd14	:	data_out = data_in_1 << data_in_2; //SLLI
				6'd15	:	data_out = data_in_1 >> data_in_2; //SRLI
				6'd16	:	data_out = data_in_1 >> data_in_2; //SRAI  (MAYBE CHANGE FOR SIGNEDNESS)
				6'd17	:	data_out = (data_in_1 < data_in_2) ? 1 : 0; //SLTI
				6'd18	:	data_out = (data_in_1 < data_in_2) ? 1 : 0; //SLTIU  (MAYBE CHANGE FOR SIGNEDNESS)
			endcase
		end
	end


endmodule
