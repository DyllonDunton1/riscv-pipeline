module register_file ( 
	input wire [4:0] read_address_1,
	input wire [4:0] read_address_2,
	input wire [31:0] write_data_in,
	input wire [4:0] write_address,
	input wire WriteEnable,
	input wire reset,
	input wire clock,
	
	input wire [4:0] read_address_debug,
	input wire clock_debug,
	
	output reg [31:0] data_out_1,
	output reg [31:0] data_out_2,
	
	output reg [31:0] data_output_debug);
	

	reg [31:0] x0 = 32'd0;
	reg [31:0] x1 = 32'd1;
	reg [31:0] x2 = 32'd2;
	reg [31:0] x3 = 32'd3;
	reg [31:0] x4 = 32'd4;
	reg [31:0] x5 = 32'd5;
	reg [31:0] x6 = 32'd6;
	reg [31:0] x7 = 32'd7;
	reg [31:0] x8 = 32'd8;
	reg [31:0] x9 = 32'd9;
	reg [31:0] x10 = 32'd10;
	reg [31:0] x11 = 32'd11;
	reg [31:0] x12 = 32'd12;
	reg [31:0] x13 = 32'd13;
	reg [31:0] x14 = 32'd14;
	reg [31:0] x15 = 32'd15;
	reg [31:0] x16 = 32'd16;
	reg [31:0] x17 = 32'd17;
	reg [31:0] x18 = 32'd18;
	reg [31:0] x19 = 32'd19;
	reg [31:0] x20 = 32'd20;
	reg [31:0] x21 = 32'd21;
	reg [31:0] x22 = 32'd22;
	reg [31:0] x23 = 32'd23;
	reg [31:0] x24 = 32'd24;
	reg [31:0] x25 = 32'd25;
	reg [31:0] x26 = 32'd26;
	reg [31:0] x27 = 32'd27;
	reg [31:0] x28 = 32'd28;
	reg [31:0] x29 = 32'd29;
	reg [31:0] x30 = 32'd30;
	reg [31:0] x31 = 32'd31;
	
	
	always @ (posedge clock) begin
		
		//DO WRITE FIRST
		if (reset) begin
			x0 = 32'd0;
			x1 = 32'd0;
			x2 = 32'd0;
			x3 = 32'd0;
			x4 = 32'd0;
			x5 = 32'd0;
			x6 = 32'd0;
			x7 = 32'd0;
			x8 = 32'd0;
			x9 = 32'd0;
			x10 = 32'd0;
			x11 = 32'd0;
			x12 = 32'd0;
			x13 = 32'd0;
			x14 = 32'd0;
			x15 = 32'd0;
			x16 = 32'd0;
			x17 = 32'd0;
			x18 = 32'd0;
			x19 = 32'd0;
			x20 = 32'd0;
			x21 = 32'd0;
			x22 = 32'd0;
			x23 = 32'd0;
			x24 = 32'd0;
			x25 = 32'd0;
			x26 = 32'd0;
			x27 = 32'd0;
			x28 = 32'd0;
			x29 = 32'd0;
			x30 = 32'd0;
			x31 = 32'd0;
		end
		
		else if (WriteEnable) begin
			case(write_address)
				5'd0	: x0 = 32'd0;
				5'd1	: x1 = write_data_in;
				5'd2	: x2 = write_data_in;
				5'd3	: x3 = write_data_in;
				5'd4	: x4 = write_data_in;
				5'd5	: x5 = write_data_in;
				5'd6	: x6 = write_data_in;
				5'd7	: x7 = write_data_in;
				5'd8	: x8 = write_data_in;
				5'd9	: x9 = write_data_in;
				5'd10	: x10 = write_data_in;
				5'd11	: x11 = write_data_in;
				5'd12	: x12 = write_data_in;
				5'd13	: x13 = write_data_in;
				5'd14	: x14 = write_data_in;
				5'd15	: x15 = write_data_in;
				5'd16	: x16 = write_data_in;
				5'd17	: x17 = write_data_in;
				5'd18	: x18 = write_data_in;
				5'd19	: x19 = write_data_in;
				5'd20	: x20 = write_data_in;
				5'd21	: x21 = write_data_in;
				5'd22	: x22 = write_data_in;
				5'd23	: x23 = write_data_in;
				5'd24	: x24 = write_data_in;
				5'd25	: x25 = write_data_in;
				5'd26	: x26 = write_data_in;
				5'd27	: x27 = write_data_in;
				5'd28	: x28 = write_data_in;
				5'd29	: x29 = write_data_in;
				5'd30	: x30 = write_data_in;
				5'd31	: x31 = write_data_in;
			endcase	
		end
	end
	
	always @ (negedge clock) begin
		//NOW DO READ
		
		//rs1
		case(read_address_1)
			5'd0	: data_out_1 = x0;
			5'd1	: data_out_1 = x1;
			5'd2	: data_out_1 = x2;
			5'd3	: data_out_1 = x3;
			5'd4	: data_out_1 = x4;
			5'd5	: data_out_1 = x5;
			5'd6	: data_out_1 = x6;
			5'd7	: data_out_1 = x7;
			5'd8	: data_out_1 = x8;
			5'd9	: data_out_1 = x9;
			5'd10	: data_out_1 = x10;
			5'd11	: data_out_1 = x11;
			5'd12	: data_out_1 = x12;
			5'd13	: data_out_1 = x13;
			5'd14	: data_out_1 = x14;
			5'd15	: data_out_1 = x15;
			5'd16	: data_out_1 = x16;
			5'd17	: data_out_1 = x17;
			5'd18	: data_out_1 = x18;
			5'd19	: data_out_1 = x19;
			5'd20	: data_out_1 = x20;
			5'd21	: data_out_1 = x21;
			5'd22	: data_out_1 = x22;
			5'd23	: data_out_1 = x23;
			5'd24	: data_out_1 = x24;
			5'd25	: data_out_1 = x25;
			5'd26	: data_out_1 = x26;
			5'd27	: data_out_1 = x27;
			5'd28	: data_out_1 = x28;
			5'd29	: data_out_1 = x29;
			5'd30	: data_out_1 = x30;
			5'd31	: data_out_1 = x31;
		endcase	
		
		//rs2
		case(read_address_2)
			5'd0	: data_out_2 = x0;
			5'd1	: data_out_2 = x1;
			5'd2	: data_out_2 = x2;
			5'd3	: data_out_2 = x3;
			5'd4	: data_out_2 = x4;
			5'd5	: data_out_2 = x5;
			5'd6	: data_out_2 = x6;
			5'd7	: data_out_2 = x7;
			5'd8	: data_out_2 = x8;
			5'd9	: data_out_2 = x9;
			5'd10	: data_out_2 = x10;
			5'd11	: data_out_2 = x11;
			5'd12	: data_out_2 = x12;
			5'd13	: data_out_2 = x13;
			5'd14	: data_out_2 = x14;
			5'd15	: data_out_2 = x15;
			5'd16	: data_out_2 = x16;
			5'd17	: data_out_2 = x17;
			5'd18	: data_out_2 = x18;
			5'd19	: data_out_2 = x19;
			5'd20	: data_out_2 = x20;
			5'd21	: data_out_2 = x21;
			5'd22	: data_out_2 = x22;
			5'd23	: data_out_2 = x23;
			5'd24	: data_out_2 = x24;
			5'd25	: data_out_2 = x25;
			5'd26	: data_out_2 = x26;
			5'd27	: data_out_2 = x27;
			5'd28	: data_out_2 = x28;
			5'd29	: data_out_2 = x29;
			5'd30	: data_out_2 = x30;
			5'd31	: data_out_2 = x31;
		endcase
		
	end
	
	always @ (posedge clock_debug) begin
		//debug
		case(read_address_debug)
			5'd0	: data_output_debug = x0;
			5'd1	: data_output_debug = x1;
			5'd2	: data_output_debug = x2;
			5'd3	: data_output_debug = x3;
			5'd4	: data_output_debug = x4;
			5'd5	: data_output_debug = x5;
			5'd6	: data_output_debug = x6;
			5'd7	: data_output_debug = x7;
			5'd8	: data_output_debug = x8;
			5'd9	: data_output_debug = x9;
			5'd10	: data_output_debug = x10;
			5'd11	: data_output_debug = x11;
			5'd12	: data_output_debug = x12;
			5'd13	: data_output_debug = x13;
			5'd14	: data_output_debug = x14;
			5'd15	: data_output_debug = x15;
			5'd16	: data_output_debug = x16;
			5'd17	: data_output_debug = x17;
			5'd18	: data_output_debug = x18;
			5'd19	: data_output_debug = x19;
			5'd20	: data_output_debug = x20;
			5'd21	: data_output_debug = x21;
			5'd22	: data_output_debug = x22;
			5'd23	: data_output_debug = x23;
			5'd24	: data_output_debug = x24;
			5'd25	: data_output_debug = x25;
			5'd26	: data_output_debug = x26;
			5'd27	: data_output_debug = x27;
			5'd28	: data_output_debug = x28;
			5'd29	: data_output_debug = x29;
			5'd30	: data_output_debug = x30;
			5'd31	: data_output_debug = x31;
		endcase
		
	end

endmodule

