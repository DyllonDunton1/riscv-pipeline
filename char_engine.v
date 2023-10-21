//char_engine
//version 2 (in progress)
//changed from previous: extending the character set to support the full alphabet, and special characters

//This character display enginne is designed to work with CPU developement projects, and displays various information from the project onto a vga-monitor.
//There is a built in hex engine that runs off the 3 data sources from the project.
//Characters are 8 * 8 pixels each with a blank line above each character, allowing allowing 80 * 53 characters on screen.
//The memory mapping takes into account only a 640*480 screen resolution

module char_engine(
	input wire clock,
	input wire project_clock,

	input [31:0] ins_data, //these inputs are for the data to be displayed later
	input [31:0] mem_data,
	input [31:0] reg_data,
	input [15:0] prg_counter,
	input [15:0]	cycle_counter,
	input [31:0] debug, //debug input
	input [31:0] gp_reg_00, //General Purpose Register inputs
	input [31:0] gp_reg_01,
	input [31:0] gp_reg_02,
	input [31:0] gp_reg_03,
	input [31:0] gp_reg_04, //General Purpose Register inputs
	input [31:0] gp_reg_05,
	input [31:0] gp_reg_06,
	input [31:0] gp_reg_07,
	input [31:0] gp_reg_08, //General Purpose Register inputs
	input [31:0] gp_reg_09,
	input [31:0] gp_reg_0A,
	input [31:0] gp_reg_0B,
	input [31:0] gp_reg_0C, //General Purpose Register inputs
	input [31:0] gp_reg_0D,
	input [31:0] gp_reg_0E,
	input [31:0] gp_reg_0F,
	
	/************************/
	
	output reg [0:7] mem_out, //if everything is backwards, swap the bit order on this output and recompile!
	
	/************************/
	
	output reg [15:0] mem_add,
	output mem_write,
	
	output reg [4:0] reg_sw,
	output reg [5:0] ins_sw,
	output reg [5:0] mem_sw);
	
	assign mem_write = 1;
	
	reg [7:0] hex_digit;
	reg [31:0] data;
	reg [7:0] hex_buffer[0:(MAX_STRING_LENGTH - 1)];
	reg [5:0] debug_prebuffer[0:31];
	reg [5:0] debug_buffer[0:38];
	reg [15:0] pc_history[0:9];
	reg [63:0] mem_buffer;
	reg [7:0] temp;
	
	parameter HORI_OFFSET = 0; //sets the horizontal offset of the memory renderer, only use if the top of the screen gets cut off.
	parameter NUM_LABEL_TASKS = 30; // This tells the code where to start tasks that require data manipulation, this must be set as you add more labels, debug tasks must be part of this number
	parameter MAX_STRING_LENGTH = 20; //Generally you do not need to modify this, but it will change the global maximum string length (default = 20)
	parameter DEBUG_TRUE = 6'h01; //This will change the charcter used when a debug value comes back as true
	parameter DEBUG_FALSE = 6'h00; //This will change the character used when a debug value comes back as false
	
/*-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
		-Enter your name, partner's name, milestone #, and test #
		-The # chars parameters must be edited in 'VGA_BLOCK.bdf', here they serve as reference to you
		-Under the name section you can edit the GP Register labels as well.
		-Follow the character use rules below in both sections
			
		UPPERCASE LETTERS, Numbers, Space, and symbols '-'  '.'  ':'  are supported
		Limited to 20 characters
---------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------*/


	//Set and Forget stuff
	reg [((yourname_chars*8)-1):0] yourname = "YOUR NAME";	//put your name in " "
	parameter yourname_chars = 9;										//# of characters, including spaces/other punct.
	
	reg [(partname_chars*8):0] partname = "PARTNER NAME";		//partners name in " "
	parameter partname_chars = 12;									//# of characters, including spaces/other punct.
	
	reg [7:0] group_num = "1";											//Enter your group number here
	
	//keep these numbers at one character, use hex digit for >9
	//Change for each milestone/test stuff
	reg [7:0] milestone_num = "1";									//Enter the Miletsone Number here, in " "
	reg [7:0] test_num = 	  "1";									//Enter the test number here in " "
	
	
/*------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
		Here you can edit the GP Register Labels
			
		Limited to 15 characters, same character support as above section
-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------*/

	reg [(gpx00_chars*8):0] gpx00_label = "GP REGISTER 00";				//put label in " "
	parameter gpx00_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx01_chars*8):0] gpx01_label = "GP REGISTER 01";				//put label in " "
	parameter gpx01_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx02_chars*8):0] gpx02_label = "GP REGISTER 02";				//put label in " "
	parameter gpx02_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx03_chars*8):0] gpx03_label = "GP REGISTER 03";				//put label in " "
	parameter gpx03_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx04_chars*8):0] gpx04_label = "GP REGISTER 04";				//put label in " "
	parameter gpx04_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx05_chars*8):0] gpx05_label = "GP REGISTER 05";				//put label in " "
	parameter gpx05_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx06_chars*8):0] gpx06_label = "GP REGISTER 06";				//put label in " "
	parameter gpx06_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx07_chars*8):0] gpx07_label = "GP REGISTER 07";				//put label in " "
	parameter gpx07_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx08_chars*8):0] gpx08_label = "GP REGISTER 08";				//put label in " "
	parameter gpx08_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx09_chars*8):0] gpx09_label = "GP REGISTER 09";				//put label in " "
	parameter gpx09_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0A_chars*8):0] gpx0A_label = "GP REGISTER 0A";				//put label in " "
	parameter gpx0A_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0B_chars*8):0] gpx0B_label = "GP REGISTER 0B";				//put label in " "
	parameter gpx0B_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0C_chars*8):0] gpx0C_label = "GP REGISTER 0C";				//put label in " "
	parameter gpx0C_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0D_chars*8):0] gpx0D_label = "GP REGISTER 0D";				//put label in " "
	parameter gpx0D_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0E_chars*8):0] gpx0E_label = "GP REGISTER 0E";				//put label in " "
	parameter gpx0E_chars = 14;													//# of characters, including spaces/other punct.
	
	reg [(gpx0F_chars*8):0] gpx0F_label = "GP REGISTER 0F";				//put label in " "
	parameter gpx0F_chars = 14;													//# of characters, including spaces/other punct.
	

/*-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------*/


	integer debug_count;
	
	integer data_index, reg_index, row, column, slice_delay, decode_delay, num_chars, k, x, y, z, i;
	
	initial begin
	slice_delay = 0; //initial values for the character renderer
	decode_delay = 0;
	x = 0;
	y = -1;
	data_index = -1;
	reg_index = 0;
	debug_count = 0;
	end
	
	always @(posedge clock) begin //semi-pipelined design, only executes one if statement per clock
				
		if (x < 0) begin //source and slice steps
			if (slice_delay == 0) data_index = data_index + 1;
			source_data();
			if (data_index > NUM_LABEL_TASKS) slice_data ();
			slice_delay = slice_delay + 1;
			if (slice_delay == 2) begin
				x = num_chars - 1;
				slice_delay = 0;
			end
		end
		
		else if (y < 0) begin //decode steps
			hex_digit <= hex_buffer[x];
			if (decode_delay == 0) begin
				x = x - 1;
			end
			decode_hex();
			decode_delay = decode_delay + 1;
			if (decode_delay == 3) begin
				y = 8;
				decode_delay = 0;
			end
		end
		
		else if (y >= 0) begin //this step writes to memory
			k = (y * 8) - 1;
			mem_add <= (80 * y) + (800 * row) + (num_chars - (x + 1)) + (column) + (HORI_OFFSET * 80); //this complicated formula tranlates information into a linear address
			mem_out <= mem_buffer[k -: 8];
			y = y - 1;
		end
	end
	
	always @(posedge clock) begin //debug indicators are set here
		
		if (debug[debug_count] == 1) debug_prebuffer[debug_count] <= DEBUG_TRUE; //this is the printed character for a true result, default = T
		else debug_prebuffer[debug_count] <= DEBUG_FALSE; //this is the character printed for a false result, default = F
		debug_count = debug_count + 1;
		if (debug_count > 31) debug_count = 0;
	end
	
	always @(posedge project_clock) begin //the program counter history is set by this code, it is driven by the clock of the project so that the data does not update too fast
		if (prg_counter != pc_history[0]) begin
			pc_history[9] = pc_history[8];
			pc_history[8] = pc_history[7];
			pc_history[7] = pc_history[6];
			pc_history[6] = pc_history[5];
			pc_history[5] = pc_history[4];
			pc_history[4] = pc_history[3];
			pc_history[3] = pc_history[2];
			pc_history[2] = pc_history[1];
			pc_history[1] = pc_history[0];
			pc_history[0] = prg_counter;
		end
	end
	always begin 
	//this is brute force way of building the debug buffer with spaces in it, the other methods used more logic units, and did not work properly due to timing issues
	//this method uses constant assignment to build the proper string, which uses far fewer LUs.	
	// I tried doing this procedurely using a loop, but found that it ran into timing issues, so I just use the direct method.
		debug_buffer[0] = " ";
		debug_buffer[1] = debug_prebuffer[0];
		debug_buffer[2] = debug_prebuffer[1];
		debug_buffer[3] = debug_prebuffer[2];
		debug_buffer[4] = debug_prebuffer[3];
		debug_buffer[5] = " ";
		debug_buffer[6] = debug_prebuffer[4];
		debug_buffer[7] = debug_prebuffer[5];
		debug_buffer[8] = debug_prebuffer[6];
		debug_buffer[9] = debug_prebuffer[7];
		debug_buffer[10] = " ";
		debug_buffer[11] = debug_prebuffer[8];
		debug_buffer[12] = debug_prebuffer[9];
		debug_buffer[13] = debug_prebuffer[10];
		debug_buffer[14] = debug_prebuffer[11];
		debug_buffer[15] = " ";
		debug_buffer[16] = debug_prebuffer[12];
		debug_buffer[17] = debug_prebuffer[13];
		debug_buffer[18] = debug_prebuffer[14];
		debug_buffer[19] = debug_prebuffer[15];
		debug_buffer[20] = debug_prebuffer[16];
		debug_buffer[21] = debug_prebuffer[17];
		debug_buffer[22] = debug_prebuffer[18];
		debug_buffer[23] = debug_prebuffer[19];
		debug_buffer[24] = " ";
		debug_buffer[25] = debug_prebuffer[20];
		debug_buffer[26] = debug_prebuffer[21];
		debug_buffer[27] = debug_prebuffer[22];
		debug_buffer[28] = debug_prebuffer[23];
		debug_buffer[29] = " ";
		debug_buffer[30] = debug_prebuffer[24];
		debug_buffer[31] = debug_prebuffer[25];
		debug_buffer[32] = debug_prebuffer[26];
		debug_buffer[33] = debug_prebuffer[27];
		debug_buffer[34] = " ";
		debug_buffer[35] = debug_prebuffer[28];
		debug_buffer[36] = debug_prebuffer[29];
		debug_buffer[37] = debug_prebuffer[30];
		debug_buffer[38] = debug_prebuffer[31];
	end
	
	task source_data; //This part of the module is the main task list for the renderer, it can be utilized in a variety of ways to render information.
			
		if (data_index == NUM_LABEL_TASKS + 4) ins_sw <= reg_index;
		if (data_index == NUM_LABEL_TASKS + 5) ins_sw <= reg_index + 32; //this code requests the data from memory to be printed on screen
		if (data_index == NUM_LABEL_TASKS + 6) mem_sw <= reg_index;
		if (data_index == NUM_LABEL_TASKS + 7) mem_sw <= reg_index + 32; //it always request the data one clock ahead of time, so that the data is ready when the system reads it
		// Two lines below added by Nicholas LaJoie - corrects register data formatting on screen
		if (data_index == NUM_LABEL_TASKS + 8) reg_sw <= reg_index; 
		//if (data_index == NUM_LABEL_TASKS + 9) reg_sw <= reg_index + 32; //this line is not needed, as there are only 32 registers
		
		case (data_index)
		//The data is only written to memory once. Array are set up for most labels, others are set manually
		
			0: begin //"INS. MEMORY" label
					reg [87:0] ins_mem_label = "INS. MEMORY";
					i = 0;
					while (i<11) begin
						hex_buffer[i] <= (((ins_mem_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end				
					row = 0;
					column = 0;
					num_chars = 11;
				end
			
			1: begin //"DATA MEMORY" label
					reg [87:0] data_mem_label = "DATA MEMORY";
					i = 0;
					while (i<11) begin
						hex_buffer[i] <= (((data_mem_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end					
					row = 0;
					column = 25;
					num_chars = 11;
				end
				
			2: begin //"REGISTERS" label
					reg [71:0] registers_label = "REGISTERS";
					i = 0;
					while (i<9) begin
						hex_buffer[i] <= (((registers_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end					
					row = 0;
					column = 50;
					num_chars = 9;
				end
				
			3: begin //PC HISTORY label

					reg [79:0] pc_hist_label = "PC HISTORY";
					i = 0;
					while (i<10) begin
						hex_buffer[i] <= (((pc_hist_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end		
				
					row  = 0;
					column = 63;
					num_chars = 10;
				end
				
			4: begin //CYCLES label
					reg [55:0] cycles_label = "CYCLES:";
					i = 0;
					while (i<7) begin
						hex_buffer[i] <= (((cycles_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end				
					row = 35;
					column = 0;
					num_chars = 7;
				end
				
			5: begin //DEBUG label
					hex_buffer[4] <= "D";
					hex_buffer[3] <= "E";
					hex_buffer[2] <= "B";
					hex_buffer[1] <= "U";
					hex_buffer[0] <= "G";			
					row = 39;
					column = 0;
					num_chars = 5;
				end

//The GP registers start here				
			6: begin //GP Register 0x00					
					i = 0;
					while (i<gpx00_chars) begin
						hex_buffer[i] <= (((gpx00_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 12;
					column = 63;
					num_chars = gpx00_chars;
				end
				
			7: begin //GP Register 0x01						
					i = 0;
					while (i<gpx01_chars) begin
						hex_buffer[i] <= (((gpx01_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end
					row = 15;
					column = 63;
					num_chars = gpx01_chars;
				end
				
			8: begin //GP Register 0x02						
					i = 0;
					while (i<gpx02_chars) begin
						hex_buffer[i] <= (((gpx02_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 18;
					column = 63;
					num_chars = gpx02_chars;
				end
				
			9: begin //GP Register 0x03				
					i = 0;
					while (i<gpx03_chars) begin
						hex_buffer[i] <= (((gpx03_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 21;
					column = 63;
					num_chars = gpx03_chars;
				end
				
			10: begin //GP Register 0x04						
					i = 0;
					while (i<gpx04_chars) begin
						hex_buffer[i] <= (((gpx04_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 24;
					column = 63;
					num_chars = gpx04_chars;
				end
				
			11: begin //GP Register 0x05						
					i = 0;
					while (i<gpx05_chars) begin
						hex_buffer[i] <= (((gpx05_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 27;
					column = 63;
					num_chars = gpx05_chars;
				end
				
			12: begin //GP Register 0x06						
					i = 0;
					while (i<gpx06_chars) begin
						hex_buffer[i] <= (((gpx06_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 30;
					column = 63;
					num_chars = gpx06_chars;
				end
				
			13: begin //GP Register 0x07						
					i = 0;
					while (i<gpx07_chars) begin
						hex_buffer[i] <= (((gpx07_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 33;
					column = 63;
					num_chars = gpx07_chars;
				end
				
			14: begin //GP Register 0x08					
					i = 0;
					while (i<gpx08_chars) begin
						hex_buffer[i] <= (((gpx08_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 36;
					column = 63;
					num_chars = gpx08_chars;
				end
				
			15: begin //GP Register 0x09						
					i = 0;
					while (i<gpx09_chars) begin
						hex_buffer[i] <= (((gpx09_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end
					row = 39;
					column = 63;
					num_chars = gpx09_chars;
				end
				
			16: begin //GP Register 0x0A						
					i = 0;
					while (i<gpx0A_chars) begin
						hex_buffer[i] <= (((gpx0A_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 42;
					column = 63;
					num_chars = gpx0A_chars;
				end
				
			17: begin //GP Register 0x0B				
					i = 0;
					while (i<gpx0B_chars) begin
						hex_buffer[i] <= (((gpx0B_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 45;
					column = 63;
					num_chars = gpx0B_chars;
				end
				
			18: begin //GP Register 0x0C						
					i = 0;
					while (i<gpx0C_chars) begin
						hex_buffer[i] <= (((gpx0C_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 34;
					column = 47;
					num_chars = gpx0C_chars;
				end
				
			19: begin //GP Register 0x0D						
					i = 0;
					while (i<gpx0D_chars) begin
						hex_buffer[i] <= (((gpx0D_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 37;
					column = 47;
					num_chars = gpx0D_chars;
				end
				
			20: begin //GP Register 0x0E						
					i = 0;
					while (i<gpx0E_chars) begin
						hex_buffer[i] <= (((gpx0E_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 40;
					column = 47;
					num_chars = gpx0E_chars;
				end
				
			21: begin //GP Register 0x0F						
					i = 0;
					while (i<gpx0F_chars) begin
						hex_buffer[i] <= (((gpx0F_label>>(8*i)) & 8'h7F));						
						i=i+1;
					end						
					row = 43;
					column = 47;
					num_chars = gpx0F_chars;
				end
				
			22: begin //00-15: label
					hex_buffer[5] <= "0";
					hex_buffer[4] <= "0";
					hex_buffer[3] <= "-";
					hex_buffer[2] <= "1";
					hex_buffer[1] <= "5";
					hex_buffer[0] <= ":";
					row = 40;
					column = 0;
					num_chars = 6;
				end
				
			23: begin //16-31: label
					hex_buffer[5] <= "1";
					hex_buffer[4] <= "6";
					hex_buffer[3] <= "-";
					hex_buffer[2] <= "3";
					hex_buffer[1] <= "1";
					hex_buffer[0] <= ":";				
					row = 42;
					column = 0;
					num_chars = 6;
				end
			
			24: begin //debug 0-15 task
					z = 0;			
					while (z <= 19) begin
						hex_buffer[z] = debug_buffer[z];
						z = z + 1;
					end				
					column = 6;
					row = 40;
					num_chars = 20;
				end
				
			25: begin //debug 16-31 task
					z = 0;				
					while (z <= 18) begin
						hex_buffer[z] = debug_buffer[z + 20];
						z = z + 1;
					end					
					column = 6;
					row = 42;
					num_chars = 19;
				end
				
			26: begin //Your Name 					
					i = 0;
					while (i<yourname_chars) begin
						hex_buffer[i] <= (((yourname>>(8*i)) & 8'h7F));						
						i=i+1;
					end					
					row = 38;
					column = 28;
					num_chars = yourname_chars;
				end
			
			27: begin //Partners name
					
					i = 0;
					while (i<partname_chars) begin
						hex_buffer[i] <= (((partname>>(8*i)) & 8'h7F));						
						i=i+1;
					end
					
					row = 39;
					column = 28;
					num_chars = partname_chars;
				end
			
			28: begin // Group #
					hex_buffer[6] <= "G";
					hex_buffer[5] <= "R";
					hex_buffer[4] <= "O";
					hex_buffer[3] <= "U";
					hex_buffer[2] <= "P";
					hex_buffer[1] <= " ";
					hex_buffer[0] <= group_num;
					
					row = 40;
					column = 28;
					num_chars = 7;
				end
			
			29: begin //Milestone #
			
					hex_buffer[10] <= "M";
					hex_buffer[9] <= "I";
					hex_buffer[8] <= "L";
					hex_buffer[7] <= "E";
					hex_buffer[6] <= "S";
					hex_buffer[5] <= "T";
					hex_buffer[4] <= "O";
					hex_buffer[3] <= "N";
					hex_buffer[2] <= "E";
					hex_buffer[1] <= " ";
					hex_buffer[0] <= milestone_num;
					
					row = 42;
					column = 28;
					num_chars = 11;
				end
			
			30: begin // Test #
			
					hex_buffer[5] <= "T";
					hex_buffer[4] <= "E";
					hex_buffer[3] <= "S";
					hex_buffer[2] <= "T";
					hex_buffer[1] <= " ";
					hex_buffer[0] <= test_num;
					
					row = 43;
					column = 28;
					num_chars = 6;
				end
				
			(NUM_LABEL_TASKS + 1): begin //instruction memory indexes 00-31
					data <= reg_index;
					column = 0;
					row = reg_index + 1;
					num_chars = 2;
				end
			
			(NUM_LABEL_TASKS + 2): begin //instruction memory indexes 32-63
					data <= reg_index + 32;
					column = 12;
					row = reg_index + 1;
					num_chars = 2;
				end	
				
			(NUM_LABEL_TASKS + 3): begin //data_memory indexes 00-31
					data <= reg_index;
					column = 25;
					row = reg_index + 1;
					num_chars = 2;
				end
				
			(NUM_LABEL_TASKS + 4): begin //data_memory indexes 32-63
					data <= reg_index + 32;
					column = 37;
					row = reg_index + 1;
					num_chars = 2;
				end
				
			(NUM_LABEL_TASKS + 5): begin //instruction memory data 00-31
					data <= ins_data;
					column = 2;
					row = reg_index + 1;
					num_chars = 9;
					hex_buffer[8] <= 6'h3a;
				end
				
			(NUM_LABEL_TASKS + 6): begin //instruction memory data 32-63
					data <= ins_data;
					column = 14;
					row = reg_index + 1;
					num_chars = 9;
					hex_buffer[8] <= ":";
				end
			
			(NUM_LABEL_TASKS + 7): begin //data memory data 00-31
					data <= mem_data; 
					column = 27;
					row = reg_index + 1;
					num_chars = 9;
					hex_buffer[8] <= ":";
				end
			
			(NUM_LABEL_TASKS + 8): begin //data memory data 31-63
					data <= mem_data; 
					column = 39;
					row = reg_index + 1;
					num_chars = 9;
					hex_buffer[8] <= ":";
				end
				
			(NUM_LABEL_TASKS + 9): begin //register indexes
					data <= 0;
					data[4:0] <= reg_index;
					column = 50;
					row = reg_index + 1;
					num_chars = 2;
				end
				
			(NUM_LABEL_TASKS + 10): begin // register data
					reg_sw <= reg_index;
					data <= reg_data;
					column = 52;
					row = reg_index + 1;
					num_chars = 9;
					hex_buffer[8] <= ":";
					if (slice_delay == 1) reg_index = reg_index + 1;
					if (reg_index == 32) begin //this resets the register index variable to zero once it reaches 32
						reg_index = 0;
					end
				end
			
			(NUM_LABEL_TASKS + 11): begin //Cycles data
					data <= cycle_counter; 
					column = 8;
					row = 35;
					num_chars = 4;
				end
			
			(NUM_LABEL_TASKS + 12): begin //pc history data
					if (reg_index <= 9) begin
						data <= pc_history[reg_index];
						row = reg_index + 1;
						column = 63;
						num_chars = 4;
					end
				
					else num_chars = 0; //setting num chars to 0 causes nothing to be written to memory, essentially aborting the source_data task
				
				end
			
//get the data for the gp registers			
			(NUM_LABEL_TASKS + 13): begin
					data <= gp_reg_00;
					column = 63;
					row = 13;
					num_chars = 8;
				end
		
			(NUM_LABEL_TASKS + 14): begin
					data <= gp_reg_01;
					column = 63;
					row = 16;
					num_chars = 8;
				end
				
			(NUM_LABEL_TASKS + 15): begin
					data <= gp_reg_02;
					column = 63;
					row = 19;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 16): begin
					data <= gp_reg_03;
					column = 63;
					row = 22;
					num_chars = 8;
				end
				

			(NUM_LABEL_TASKS + 17): begin
					data <= gp_reg_04;
					column = 63;
					row = 25;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 18): begin
					data <= gp_reg_05;
					column = 63;
					row = 28;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 19): begin
					data <= gp_reg_06;
					column = 63;
					row = 31;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 20): begin
					data <= gp_reg_07;
					column = 63;
					row = 34;
					num_chars = 8;
				end
				
			(NUM_LABEL_TASKS + 21): begin
					data <= gp_reg_08;
					column = 63;
					row = 37;
					num_chars = 8;
				end
		
			(NUM_LABEL_TASKS + 22): begin
					data <= gp_reg_09;
					column = 63;
					row = 40;
					num_chars = 8;
				end
				
			(NUM_LABEL_TASKS + 23): begin
					data <= gp_reg_0A;
					column = 63;
					row = 43;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 24): begin
					data <= gp_reg_0B;
					column = 63;
					row = 46;
					num_chars = 8;
				end
				

			(NUM_LABEL_TASKS + 25): begin
					data <= gp_reg_0C;
					column = 47;
					row = 35;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 26): begin
					data <= gp_reg_0D;
					column = 47;
					row = 38;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 27): begin
					data <= gp_reg_0E;
					column = 47;
					row = 41;
					num_chars = 8;
				end

			(NUM_LABEL_TASKS + 28): begin
					data <= gp_reg_0F;
					column = 47;
					row = 44;
					num_chars = 8;
				end
				
			default: data_index = NUM_LABEL_TASKS;
		endcase
	endtask
	
	task slice_data; //I tried other ways of doing this, but the straightforward approach works better.
		hex_buffer[7] <= data[31:28];
		hex_buffer[6] <= data[27:24];
		hex_buffer[5] <= data[23:20];
		hex_buffer[4] <= data[19:16];
		hex_buffer[3] <= data[15:12];
		hex_buffer[2] <= data[11:8];
		hex_buffer[1] <= data[7:4];
		hex_buffer[0] <= data[3:0];
	endtask
	
	task decode_hex;
		case (hex_digit)	
		
			8'h00: begin //zero
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
			
			8'h01: begin //one
					mem_buffer[7:0] <=   8'b00011000;
					mem_buffer[15:8] <=  8'b00111000;
					mem_buffer[23:16] <= 8'b01111000;
					mem_buffer[31:24] <= 8'b00011000;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b01111110;
					end
			
			8'h02: begin //two
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01100110;
					mem_buffer[23:16] <= 8'b01100110;
					mem_buffer[31:24] <= 8'b00001100;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00110000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01111110;
					end
					
			8'h03: begin //three
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b00000110;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b01111100;
					end
				
			8'h04: begin //four
					mem_buffer[7:0] <=   8'b00001110;
					mem_buffer[15:8] <=  8'b00010110;
					mem_buffer[23:16] <= 8'b00100110;
					mem_buffer[31:24] <= 8'b01000110;
					mem_buffer[39:32] <= 8'b01000110;
					mem_buffer[47:40] <= 8'b01111110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b00000110;
					end
					
			8'h05: begin //five
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111000;
					mem_buffer[39:32] <= 8'b00001100;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00001100;
					mem_buffer[63:56] <= 8'b01111000;
					end
					
			8'h06: begin //six
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000000;
					mem_buffer[23:16] <= 8'b01000000;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h07: begin //seven
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b00000110;
					mem_buffer[39:32] <= 8'b00001100;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00110000;
					mem_buffer[63:56] <= 8'b01100000;
					end
					
			8'h08: begin //eight
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b00111100;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h09: begin //nine
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000110;
					mem_buffer[23:16] <= 8'b01000110;
					mem_buffer[31:24] <= 8'b01000110;
					mem_buffer[39:32] <= 8'b00111110;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b00000110;
					end
					
			8'h0A: begin //A
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01111110;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h0B: begin //B
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000110;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b01000110;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01111100;
					end
					
			8'h0C: begin //C
					mem_buffer[7:0] <=   8'b00111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01100000;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b00111110;
					end
					
			8'h0D: begin //D
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b01100010;
					mem_buffer[23:16] <= 8'b01100010;
					mem_buffer[31:24] <= 8'b01100010;
					mem_buffer[39:32] <= 8'b01100010;
					mem_buffer[47:40] <= 8'b01100010;
					mem_buffer[55:48] <= 8'b01100010;
					mem_buffer[63:56] <= 8'b01111100;
					end
					
			8'h0E: begin //E
					mem_buffer[7:0] <=   8'b00111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b00111110;
					end
					
			8'h0F: begin //F
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01100000;
					end
					
			
					
			8'h25: begin //Filled
					mem_buffer[7:0] <=   8'b11111111;
					mem_buffer[15:8] <=  8'b11111111;
					mem_buffer[23:16] <= 8'b11111111;
					mem_buffer[31:24] <= 8'b11111111;
					mem_buffer[39:32] <= 8'b11111111;
					mem_buffer[47:40] <= 8'b11111111;
					mem_buffer[55:48] <= 8'b11111111;
					mem_buffer[63:56] <= 8'b11111111;
					end
					
			
					
					
/****************   ASCII VALUES   ********************/
					
			8'h20: begin //space
					mem_buffer[7:0] <=   8'b00000000;
					mem_buffer[15:8] <=  8'b00000000;
					mem_buffer[23:16] <= 8'b00000000;
					mem_buffer[31:24] <= 8'b00000000;
					mem_buffer[39:32] <= 8'b00000000;
					mem_buffer[47:40] <= 8'b00000000;
					mem_buffer[55:48] <= 8'b00000000;
					mem_buffer[63:56] <= 8'b00000000;
					end
					
			8'h2d: begin //-
					mem_buffer[7:0] <=   8'b00000000;
					mem_buffer[15:8] <=  8'b00000000;
					mem_buffer[23:16] <= 8'b00000000;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b00000000;
					mem_buffer[47:40] <= 8'b00000000;
					mem_buffer[55:48] <= 8'b00000000;
					mem_buffer[63:56] <= 8'b00000000;
					end
					
			
					
			8'h2e: begin //.
					mem_buffer[7:0] <=   8'b00000000;
					mem_buffer[15:8] <=  8'b00000000;
					mem_buffer[23:16] <= 8'b00000000;
					mem_buffer[31:24] <= 8'b00000000;
					mem_buffer[39:32] <= 8'b00000000;
					mem_buffer[47:40] <= 8'b00000000;
					mem_buffer[55:48] <= 8'b11000000;
					mem_buffer[63:56] <= 8'b11000000;
					end
			
			
			
			8'h30: begin //zero
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
			
			8'h31: begin //one
					mem_buffer[7:0] <=   8'b00011000;
					mem_buffer[15:8] <=  8'b00111000;
					mem_buffer[23:16] <= 8'b01111000;
					mem_buffer[31:24] <= 8'b00011000;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b01111110;
					end
			
			8'h32: begin //two
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01100110;
					mem_buffer[23:16] <= 8'b01100110;
					mem_buffer[31:24] <= 8'b00001100;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00110000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01111110;
					end
					
			8'h33: begin //three
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b00000110;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b01111100;
					end
				
			8'h34: begin //four
					mem_buffer[7:0] <=   8'b00001110;
					mem_buffer[15:8] <=  8'b00010110;
					mem_buffer[23:16] <= 8'b00100110;
					mem_buffer[31:24] <= 8'b01000110;
					mem_buffer[39:32] <= 8'b01000110;
					mem_buffer[47:40] <= 8'b01111110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b00000110;
					end
					
			8'h35: begin //five
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111000;
					mem_buffer[39:32] <= 8'b00001100;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00001100;
					mem_buffer[63:56] <= 8'b01111000;
					end
					
			8'h36: begin //six
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000000;
					mem_buffer[23:16] <= 8'b01000000;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h37: begin //seven
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b00000110;
					mem_buffer[39:32] <= 8'b00001100;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00110000;
					mem_buffer[63:56] <= 8'b01100000;
					end
					
			8'h38: begin //eight
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b00111100;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h39: begin //nine
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000110;
					mem_buffer[23:16] <= 8'b01000110;
					mem_buffer[31:24] <= 8'b01000110;
					mem_buffer[39:32] <= 8'b00111110;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b00000110;
					mem_buffer[63:56] <= 8'b00000110;
					end
					
			8'h3A: begin //:
					mem_buffer[7:0] <=   8'b00000000;
					mem_buffer[15:8] <=  8'b00011000;
					mem_buffer[23:16] <= 8'b00011000;
					mem_buffer[31:24] <= 8'b00000000;
					mem_buffer[39:32] <= 8'b00000000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b00000000;
					end					
					
			8'h41: begin //A
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01111110;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h42: begin //B
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000110;
					mem_buffer[31:24] <= 8'b01111100;
					mem_buffer[39:32] <= 8'b01000110;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01111100;
					end
					
			8'h43: begin //C
					mem_buffer[7:0] <=   8'b00111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01100000;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b00111110;
					end
					
			8'h44: begin //D
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b01100010;
					mem_buffer[23:16] <= 8'b01100010;
					mem_buffer[31:24] <= 8'b01100010;
					mem_buffer[39:32] <= 8'b01100010;
					mem_buffer[47:40] <= 8'b01100010;
					mem_buffer[55:48] <= 8'b01100010;
					mem_buffer[63:56] <= 8'b01111100;
					end
					
			8'h45: begin //E
					mem_buffer[7:0] <=   8'b00111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b00111110;
					end
					
			8'h46: begin //F
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01100000;
					end
				
			8'h47: begin //G
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01101110;
					mem_buffer[39:32] <= 8'b01100110;
					mem_buffer[47:40] <= 8'b01100110;
					mem_buffer[55:48] <= 8'b01100110;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h48: begin //H
					mem_buffer[7:0] <=   8'b01100110;
					mem_buffer[15:8] <=  8'b01100110;
					mem_buffer[23:16] <= 8'b01100110;
					mem_buffer[31:24] <= 8'b01111110;
					mem_buffer[39:32] <= 8'b01100110;
					mem_buffer[47:40] <= 8'b01100110;
					mem_buffer[55:48] <= 8'b01100110;
					mem_buffer[63:56] <= 8'b01100110;
					end
					
			8'h49: begin //I
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00011000;
					mem_buffer[23:16] <= 8'b00011000;
					mem_buffer[31:24] <= 8'b00011000;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b01111110;
					end
					
			8'h4a: begin //J
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b00000110;
					mem_buffer[39:32] <= 8'b00000110;
					mem_buffer[47:40] <= 8'b00000110;
					mem_buffer[55:48] <= 8'b01100110;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h4b: begin //K
					mem_buffer[7:0] <=   8'b01100110;
					mem_buffer[15:8] <=  8'b01100110;
					mem_buffer[23:16] <= 8'b01101100;
					mem_buffer[31:24] <= 8'b01110000;
					mem_buffer[39:32] <= 8'b01110000;
					mem_buffer[47:40] <= 8'b01101100;
					mem_buffer[55:48] <= 8'b01100110;
					mem_buffer[63:56] <= 8'b01100110;
					end
					
			8'h4c: begin //I
					mem_buffer[7:0] <=   8'b01100000;
					mem_buffer[15:8] <=  8'b01100000;
					mem_buffer[23:16] <= 8'b01100000;
					mem_buffer[31:24] <= 8'b01100000;
					mem_buffer[39:32] <= 8'b01100000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01111110;
					end
					
			8'h4d: begin //M
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01100110;
					mem_buffer[23:16] <= 8'b01011010;
					mem_buffer[31:24] <= 8'b01011010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h4e: begin //N
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01100010;
					mem_buffer[31:24] <= 8'b01010010;
					mem_buffer[39:32] <= 8'b01001010;
					mem_buffer[47:40] <= 8'b01000110;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h4f: begin //O
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h50: begin //P
					mem_buffer[7:0] <=   8'b01111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01111100;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01100000;
					end
					
			8'h51: begin //Q
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000100;
					mem_buffer[63:56] <= 8'b00111010;
					end
					
			8'h52: begin //R
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01111100;
					mem_buffer[47:40] <= 8'b01011000;
					mem_buffer[55:48] <= 8'b01001100;
					mem_buffer[63:56] <= 8'b01000110;
					end
					
			8'h53: begin //S
					mem_buffer[7:0] <=   8'b00111100;
					mem_buffer[15:8] <=  8'b01000000;
					mem_buffer[23:16] <= 8'b01000000;
					mem_buffer[31:24] <= 8'b00111100;
					mem_buffer[39:32] <= 8'b00000010;
					mem_buffer[47:40] <= 8'b00000010;
					mem_buffer[55:48] <= 8'b00000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h54: begin //T
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00011000;
					mem_buffer[23:16] <= 8'b00011000;
					mem_buffer[31:24] <= 8'b00011000;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b00011000;
					end
					
			8'h55: begin //U
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b00111100;
					end
					
			8'h56: begin //V
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01000010;
					mem_buffer[47:40] <= 8'b01000010;
					mem_buffer[55:48] <= 8'b00100100;
					mem_buffer[63:56] <= 8'b00011000;
					end
					
			8'h57: begin //W
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b01000010;
					mem_buffer[39:32] <= 8'b01011010;
					mem_buffer[47:40] <= 8'b01011010;
					mem_buffer[55:48] <= 8'b01100110;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h58: begin //X
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b00100100;
					mem_buffer[31:24] <= 8'b00011000;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00100100;
					mem_buffer[55:48] <= 8'b01000010;
					mem_buffer[63:56] <= 8'b01000010;
					end
					
			8'h59: begin //Y
					mem_buffer[7:0] <=   8'b01000010;
					mem_buffer[15:8] <=  8'b01000010;
					mem_buffer[23:16] <= 8'b01000010;
					mem_buffer[31:24] <= 8'b00100100;
					mem_buffer[39:32] <= 8'b00011000;
					mem_buffer[47:40] <= 8'b00011000;
					mem_buffer[55:48] <= 8'b00011000;
					mem_buffer[63:56] <= 8'b00011000;
					end
					
			8'h5a: begin //Z
					mem_buffer[7:0] <=   8'b01111110;
					mem_buffer[15:8] <=  8'b00000110;
					mem_buffer[23:16] <= 8'b00000110;
					mem_buffer[31:24] <= 8'b00001100;
					mem_buffer[39:32] <= 8'b00110000;
					mem_buffer[47:40] <= 8'b01100000;
					mem_buffer[55:48] <= 8'b01100000;
					mem_buffer[63:56] <= 8'b01111110;
					end
					
			default: mem_buffer <= 63'h0000000000000000;
		endcase
	endtask
	
	
endmodule	