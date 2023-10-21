// file instruction_decode.v

module instruction_decode_ib_type(
        input clock,
        input [31:0] data_in,
        output [39:0] char_out
);


        always @(posedge clock) begin
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


                /* I TYPE addi, xori, ori, andi, slli, srli, srai, slti, sltiu  */
                if (opcode == 7'b0010011) begin
                        if (func3 == 3'h0) begin        // addi
                                char_out = "addi "
                        end
                        if (func3 == 3'h4) begin        // xori
                                char_out = "xori "
                        end
                        if (func3 == 3'h6) begin        // ori
                                char_out = "ori  "
                        end
                        if (func3 == 3'h7) begin        // andi
                                char_out = "andi "
                        end
                        if (func3 == 3'h1) begin        // slli
                                char_out = "slli "
                        end
                        if (func3 == 3'h5) begin        // srli & srai
                                if (func7 == 7'h00) begin
                                        char_out = "srli "
                                end
                                if (func7 == 7'h20) begin
                                        char_out = "srai "
                                end
                        end
                        if (func3 == 3'h2) begin        // slti
                                char_out = "slti "
                        end
                        if (func3 == 3'h3) begin        // sltiu
                                char_out = "sltiu"
                        end
                end
                /* I TYPE lb, lh, lw, lbu, lhu */
                if (opcode == 7'b0000011) begin
                        if (func3 == 3'h0) begin        // lb
                                char_out = "lb   "
                        end
                        if (func3 == 3'h1) begin        // lh
                                char_out = "lh   "
                        end
                        if (func3 == 3'h2) begin        // lw
                                char_out = "lw   "
                        end
                        if (func3 == 3'h4) begin        // lbu
                                char_out = "lbu  "
                        end
                        if (func3 == 3'h5) begin        // lhu
                                char_out = "lhu  "
                        end
                end
                /* B TYPE beq, bne, blt, bge, bltu, bgeu */
                if (opcode == 7'1100011) begin
                        if (func3 == 3'h0) begin        // beq
                                char_out = "beq  "
                        end
                        if (func3 == 3'h1) begin        // bne
                                char_out = "bne  "
                        end
                        if (func3 == 3'h4) begin        // blt
                                char_out = "blt  "
                        end
                        if (func3 == 3'h5) begin        // bge
                                char_out = "bge  "
                        end
                        if (func3 == 3'h6) begin        // bltu
                                char_out = "bltu "
                        end
                        if (func3 == 3'h7) begin        // bgeu
                                char_out = "bgeu "
                        end
                end
                /* I TYPE jalr */
                if (opcode == 7'1100111) begin
                        if (func3 == 3'h0) begin        // jalr
                                char_out = "jalr "
                        end
                end

        end

endmodule


