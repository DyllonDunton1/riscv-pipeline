// file instruction_decode.v

module instruction_decode(
        input clock,
        input [31:0] data_in,
        output reg [5:0] instr_id,
	output reg test_led
);

/* 6-bit identifier is sent out rather than a string, starts at 000000 for add,
* and follows the risc-v reference sheet for the order.
*/

        always @(posedge clock) begin
		if (data_in[6:0] == 7'b0110011) begin
			//R-TYPE
			if (data_in[14:12] == 3'h0) begin
				//add or sub
				if (data_in[31:25] == 7'h00) begin
					//add
					instr_id <= 6'd0;
					test_led <= 1'b1;
				end
				else begin
					//sub
					instr_id <= 6'd1;
				end
			end
			if (data_in[14:12] == 3'h1) begin
				//shift left logical
				instr_id <= 6'b000101;
			end
			if (data_in[14:12] == 3'h2) begin
				//set less than
				instr_id <= 6'b001000;
			end
			if (data_in[14:12] == 3'h3) begin
				//set less than u
				instr_id <= 6'b001001;
			end
			if (data_in[14:12] == 3'h4) begin
				//xor
				instr_id <= 6'b000010;
			end
			if (data_in[14:12] == 3'h5) begin
				//shift right (log or arth)
				if (data_in[31:25] == 7'h00) begin
					//shift right logical
					instr_id <= 6'b000110;
				end
				else begin
					//shift right arith
					instr_id <= 6'b000111;
				end
			end
			if (data_in[14:12] == 3'h6) begin
				//or
				instr_id <= 6'b000011;
			end
			if (data_in[14:12] == 3'h7) begin
				//and
				instr_id <= 6'b000100;
			end
		end
		if (data_in[6:0] == 7'b0100011) begin
			//S-TYPE
			if (data_in[14:12] == 3'h0) begin
				//store byte
				instr_id <= 6'd24;
			end
			if (data_in[14:12] == 3'h1) begin
				//store half
				instr_id <= 6'd25;
			end
			if (data_in[14:12] == 3'h2) begin
				//store word
				instr_id <= 6'd26;
			end
		end
		if (data_in[6:0] == 7'b1101111) begin
			//J-TYPE
			//jump and link
			instr_id <= 6'd33;
			test_led <= 1'b0;
		end
		if (data_in[6:0] == 7'b0110111) begin
			//U-TYPE
			//load upper imm
			instr_id <= 6'd35;
		end
		if (data_in[6:0] == 7'b0010111) begin
			//U-TYPE
			//add upper imm to pc
			instr_id <= 6'd36;
		end


                /* I TYPE addi, xori, ori, andi, slli, srli, srai, slti, sltiu  */
                if (data_in[6:0] == 7'b0010011) begin
                        if (data_in[14:12] == 3'h0) begin        // addi
                                instr_id <= 6'd10;
                        end
                        if (data_in[14:12] == 3'h4) begin        // xori
                                instr_id <= 6'd11;
                        end
                        if (data_in[14:12] == 3'h6) begin        // ori
                                instr_id <= 6'd12;
                        end
                        if (data_in[14:12] == 3'h7) begin        // andi
                                instr_id <= 6'd13;
                        end
                        if (data_in[14:12] == 3'h1) begin        // slli
                                instr_id <= 6'd14;
                        end
                        if (data_in[14:12] == 3'h5) begin        // srli & srai
                                if (data_in[31:25] == 7'h00) begin
                                        instr_id <= 6'd15;
                                end
                                if (data_in[31:25] == 7'h20) begin
                                        instr_id <= 6'd16;
                                end
                        end
                        if (data_in[14:12] == 3'h2) begin        // slti
                                instr_id <= 6'd17;
                        end
                        if (data_in[14:12] == 3'h3) begin        // sltiu
                                instr_id <= 6'd18;
                        end
                end
                /* I TYPE lb, lh, lw, lbu, lhu */
                if (data_in[6:0] == 7'b0000011) begin
                        if (data_in[14:12] == 3'h0) begin        // lb
                                instr_id <= 6'd19;
                        end
                        if (data_in[14:12] == 3'h1) begin        // lh
                                instr_id <= 6'd20;
                        end
                        if (data_in[14:12] == 3'h2) begin        // lw
                                instr_id <= 6'd21;
                        end
                        if (data_in[14:12] == 3'h4) begin        // lbu
                                instr_id <= 6'd22;
                        end
                        if (data_in[14:12] == 3'h5) begin        // lhu
                                instr_id <= 6'd23;
                        end
                end
                /* B TYPE beq, bne, blt, bge, bltu, bgeu */
                if (data_in[6:0] == 7'b1100011) begin
                        if (data_in[14:12] == 3'h0) begin        // beq
                                instr_id <= 6'd27;
                        end
                        if (data_in[14:12] == 3'h1) begin        // bne
                                instr_id <= 6'd28;
                        end
                        if (data_in[14:12] == 3'h4) begin        // blt
                                instr_id <= 6'd29;
                        end
                        if (data_in[14:12] == 3'h5) begin        // bge
                                instr_id <= 6'd30;
                        end
                        if (data_in[14:12] == 3'h6) begin        // bltu
                                instr_id <= 6'd31;
                        end
                        if (data_in[14:12] == 3'h7) begin        // bgeu
                                instr_id <= 6'd32;
                        end
                end
                /* I TYPE jalr */
                if (data_in[6:0] == 7'b1100111) begin
                        if (data_in[14:12] == 3'h0) begin        // jalr
                                instr_id <= 6'd34;
                        end
                end

        end

endmodule


