module controller ( 
	input wire [5:0] instruction_type,
	input wire clock,
	
	output reg ALUSRC

);
	
	always @ (posedge clock) begin
		case (instruction_type)
			5'b100000	:	ALUSRC = 0; //R
			5'b010000	:	ALUSRC = 1; //I
			5'b001000	:	ALUSRC = 0; //S
			5'b000100	:	ALUSRC = 0; //B
			5'b000010	:	ALUSRC = 0; //J
			5'b000001	:	ALUSRC = 0; //U
			default	:	ALUSRC = 0;
		endcase	
	end	
	

endmodule