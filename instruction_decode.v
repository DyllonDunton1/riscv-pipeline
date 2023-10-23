// file instruction_decode.v

module instruction_decode(
        input clock,
        input [31:0] data_in,
        output reg [39:0] char_out,
		  output reg test_led
);
        initial begin
                test_led = 1'b0;
                char_out = "XXXXX";
        end

        always @(posedge clock) begin
		  
		  if (data_in == 32'd0) begin
				//U-TYPE
				//add upper imm to pc
				char_out <= "NOP  ";
			end
			if (data_in[6:0] == 7'b0110011) begin
				//R-TYPE
				if (data_in[14:12] == 3'h0) begin
					//add or sub
					if (data_in[31:25] == 7'h00) begin
						//add
						char_out <= "ADD  ";
						test_led <= 1'b1;
					end
					else begin
						//sub
						char_out <= "SUB  ";
					end
				end
				if (data_in[14:12] == 3'h1) begin
					//shift left logical
					char_out <= "SLL  ";
				end
				if (data_in[14:12] == 3'h2) begin
					//set less than
					char_out <= "SLT  ";
				end
				if (data_in[14:12] == 3'h3) begin
					//set less than u
					char_out <= "SLTU ";
				end
				if (data_in[14:12] == 3'h4) begin
					//xor
					char_out <= "XOR  ";
				end
				if (data_in[14:12] == 3'h5) begin
					//shift right (log or arth)
					if (data_in[31:25] == 7'h00) begin
						//shift right logical
						char_out <= "SRL  ";
					end
					else begin
						//shift right arith
						char_out <= "SRA  ";
					end
				end
				if (data_in[14:12] == 3'h6) begin
					//or
					char_out <= "OR   ";
				end
				if (data_in[14:12] == 3'h7) begin
					//and
					char_out <= "AND  ";
				end
			end
			if (data_in[6:0] == 7'b0100011) begin
				//S-TYPE
				if (data_in[14:12] == 3'h0) begin
					//store byte
					char_out <= "SB   ";
				end
				if (data_in[14:12] == 3'h1) begin
					//store half
					char_out <= "SH   ";
				end
				if (data_in[14:12] == 3'h2) begin
					//store word
					char_out <= "SW   ";
				end
			end
			if (data_in[6:0] == 7'b1101111) begin
				//J-TYPE
				//jump and link
				char_out <= "JAL  ";
			end
			if (data_in[6:0] == 7'b0110111) begin
				//U-TYPE
				//load upper imm
				char_out <= "LUI  ";
			end
			if (data_in[6:0] == 7'b0010111) begin
				//U-TYPE
				//add upper imm to pc
				char_out <= "AUIPC";
			end
			 /* I TYPE addi, xori, ori, andi, slli, srli, srai, slti, sltiu  */
			 if (data_in[6:0] == 7'b0010011) begin
					if (data_in[14:12] == 3'h0) begin        // addi
							  char_out <= "ADDI ";
					end
					if (data_in[14:12] == 3'h4) begin        // xori
							  char_out <= "XORI ";
					end
					if (data_in[14:12] == 3'h6) begin        // ori
							  char_out <= "ORI  ";
					end
					if (data_in[14:12] == 3'h7) begin        // andi
							  char_out <= "ANDI ";
					end
					if (data_in[14:12] == 3'h1) begin        // slli
							  char_out <= "SLLI ";
					end
					if (data_in[14:12] == 3'h5) begin        // srli & srai
							  if (data_in[31:25] == 7'h00) begin
										 char_out <= "SRLI ";
							  end
							  if (data_in[31:25] == 7'h20) begin
										 char_out <= "SRAI ";
							  end
					end
					if (data_in[14:12] == 3'h2) begin        // slti
							  char_out <= "SLTI ";
					end
					if (data_in[14:12] == 3'h3) begin        // sltiu
							  char_out <= "SLTIU";
					end
			 end
				 /* I TYPE lb, lh, lw, lbu, lhu */
				if (data_in[6:0] == 7'b0000011) begin
						if (data_in[14:12] == 3'h0) begin        // lb
								  char_out <= "LB   ";
						end
						if (data_in[14:12] == 3'h1) begin        // lh
								  char_out <= "LH   ";
						end
						if (data_in[14:12] == 3'h2) begin        // lw
								  char_out <= "LW   ";
						end
						if (data_in[14:12] == 3'h4) begin        // lbu
								  char_out <= "LBU  ";
						end
						if (data_in[14:12] == 3'h5) begin        // lhu
								  char_out <= "LHU  ";
						end
				 end
				 /* B TYPE beq, bne, blt, bge, bltu, bgeu */
				 if (data_in[6:0] == 7'b1100011) begin
						if (data_in[14:12] == 3'h0) begin        // beq
								  char_out <= "BEQ  ";
						end
						if (data_in[14:12] == 3'h1) begin        // bne
								  char_out <= "BNE  ";
						end
						if (data_in[14:12] == 3'h4) begin        // blt
								  char_out <= "BLT  ";
						end
						if (data_in[14:12] == 3'h5) begin        // bge
								  char_out <= "BGE  ";
						end
						if (data_in[14:12] == 3'h6) begin        // bltu
								  char_out <= "BLTU ";
						end
						if (data_in[14:12] == 3'h7) begin        // bgeu
								  char_out <= "BGEU ";
						end
				 end
				 /* I TYPE jalr */
				 if (data_in[6:0] == 7'b1100111) begin
						if (data_in[14:12] == 3'h0) begin        // jalr
								  char_out <= "JALR ";
						end
				 end
        end

endmodule
