module controller ( 
	
	input wire clock,
	input wire [4:0] rs1,
	input wire [4:0] rs2,
	input wire [4:0] rd,
	input wire [6:0] opcode,
	input wire [2:0] f3,
	input wire [6:0] f7,
	input wire [31:0] immediate,
	
	output reg [39:0] char_out,
	
	output reg PCSRC,
	output reg ALUSRC,
	output reg MEMTOREG,
	output reg WRITEBACK_EN,
	
	output reg [8:0] type

);
	
	
	initial begin
		char_out = "XXXXX";
		PCSRC = 0;
		ALUSRC = 0;
		MEMTOREG = 0;
		WRITEBACK_EN = 0;
		type = 0;
	end

	always @(posedge clock) begin
	  
			if (opcode == 7'd0) begin
			//NOP
				char_out <= "NOP  ";
				type = 9'b000000000;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				
			end
			if (opcode == 7'b0110011) begin
				//R-TYPE
				type = 9'b100000000;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				
				
				if (f3 == 3'h0) begin
					//add or sub
					if (f7 == 7'h00) begin
						//add
						char_out <= "ADD  ";
					end
					else begin
						//sub
						char_out <= "SUB  ";
					end
				end
				if (f3 == 3'h1) begin
					//shift left logical
					char_out <= "SLL  ";
				end
				if (f3 == 3'h2) begin
					//set less than
					char_out <= "SLT  ";
				end
				if (f3 == 3'h3) begin
					//set less than u
					char_out <= "SLTU ";
				end
				if (f3 == 3'h4) begin
					//xor
					char_out <= "XOR  ";
				end
				if (f3 == 3'h5) begin
					//shift right (log or arth)
					if (f7 == 7'h00) begin
						//shift right logical
						char_out <= "SRL  ";
					end
					else begin
						//shift right arith
						char_out <= "SRA  ";
					end
				end
				if (f3 == 3'h6) begin
					//or
					char_out <= "OR   ";
				end
				if (f3 == 3'h7) begin
					//and
					char_out <= "AND  ";
				end
			end
			
			
			
			/* I TYPE addi, xori, ori, andi, slli, srli, srai, slti, sltiu  */
			if (opcode == 7'b0010011) begin
				
				type = 9'b010000000;
				PCSRC = 0;
				ALUSRC = 1;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				if (f3 == 3'h0) begin        // addi
					char_out <= "ADDI ";
				end
				if (f3 == 3'h4) begin        // xori
					char_out <= "XORI ";
				end
				if (f3 == 3'h6) begin        // ori
					char_out <= "ORI  ";
				end
				if (f3 == 3'h7) begin        // andi
					char_out <= "ANDI ";
				end
				if (f3 == 3'h1) begin        // slli
					char_out <= "SLLI ";
				end
				if (f3 == 3'h5) begin        // srli & srai
					if (f7 == 7'h00) begin
						 char_out <= "SRLI ";
					end
					if (f7 == 7'h20) begin
						 char_out <= "SRAI ";
					end
				end
				if (f3 == 3'h2) begin        // slti
					char_out <= "SLTI ";
				end
				if (f3 == 3'h3) begin        // sltiu
					char_out <= "SLTIU";
				end
			end
			
			
			
			
			/* I TYPE lb, lh, lw, lbu, lhu */
			if (opcode == 7'b0000011) begin
				type = 9'b00100000;
				PCSRC = 0;
				ALUSRC = 1;
				MEMTOREG = 1;
				WRITEBACK_EN = 0;
				
				if (f3 == 3'h0) begin        // lb
					char_out <= "LB   ";
				end
				if (f3 == 3'h1) begin        // lh
					char_out <= "LH   ";
				end
				if (f3 == 3'h2) begin        // lw
					char_out <= "LW   ";
				end
				if (f3 == 3'h4) begin        // lbu
					char_out <= "LBU  ";
				end
				if (f3 == 3'h5) begin        // lhu
					char_out <= "LHU  ";
				end
			end
			
			if (opcode == 7'b0100011) begin
				//S-TYPE
				
				type = 9'b000100000;
				PCSRC = 0;
				ALUSRC = 1;
				MEMTOREG = 1;
				WRITEBACK_EN = 1;
				
				
				
				if (f3 == 3'h0) begin
					//store byte
					char_out <= "SB   ";
				end
				if (f3 == 3'h1) begin
					//store half
					char_out <= "SH   ";
				end
				if (f3 == 3'h2) begin
					//store word
					char_out <= "SW   ";
				end
			end
			
			
			/* B TYPE beq, bne, blt, bge, bltu, bgeu */
			if (opcode == 7'b1100011) begin
				type = 9'b000010000;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
								
				if (f3 == 3'h0) begin        // beq
					char_out <= "BEQ  ";
				end
				if (f3 == 3'h1) begin        // bne
					char_out <= "BNE  ";
				end
				if (f3 == 3'h4) begin        // blt
					char_out <= "BLT  ";
				end
				if (f3 == 3'h5) begin        // bge
					char_out <= "BGE  ";
				end
				if (f3 == 3'h6) begin        // bltu
					char_out <= "BLTU ";
				end
				if (f3 == 3'h7) begin        // bgeu
					char_out <= "BGEU ";
				end
			end
			
			
			if (opcode == 7'b1101111) begin
				//J-TYPE
				type = 9'b000001000;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				
				//jump and link
				char_out <= "JAL  ";
			end
			
			if (opcode == 7'b0110111) begin
				//U-TYPE
				type = 9'b000000100;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				
				//load upper imm
				char_out <= "LUI  ";
			end
			if (opcode == 7'b0010111) begin
				//U-TYPE
				type = 9'b000000010;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				//add upper imm to pc
				char_out <= "AUIPC";
			end
			
			
			/* I TYPE jalr */
			if (opcode == 7'b1100111) begin
				type = 9'b000000001;
				PCSRC = 0;
				ALUSRC = 0;
				MEMTOREG = 0;
				WRITEBACK_EN = 0;
				
				
				if (f3 == 3'h0) begin        // jalr
					char_out <= "JALR ";
				end
			end
		end
	

endmodule