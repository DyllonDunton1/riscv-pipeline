//The parameters are available so that other resolutions are possible
//However, choosing a larger resolution, or color depth will increase the memory requirements.
//The cyclone II FPGA only has 4kb of ram available, using the color encoder, we can choose what the two colors are.
//A clever person may even learn how to use "Hold and Modify" techniques to get more colors on screen without needing more memory. (google it!)
//Remember:  horizontal resolution * vertical resolution * color bit depth = memory requirements.
//Default settings are 640*480 @60hz using 1-bit color depth, with a selectable pallete. This uses 67% of the Cyclone II's memory.
//An even more clever person could figure out how to use the onboard SRAM as video memory, allowing 640*480 with an 8-bit color pallete.



module vga_control (
	input wire clock,
	
	output reg [18:0]mem_add,
	output reg vga_hsync,
	output reg vga_vsync,
	output vga_sync,
	output reg vga_blank,
	output vga_clock);
	
	//assign vga_blank = 1; //blanking off
	assign vga_sync = 0; //sync on green off
	assign vga_clock = ~clock;
	
	parameter hres 	= 640;
	parameter hsync	= 96;
	parameter hfront	= 16;
	parameter hback 	= 48;
	parameter htotal	= hfront+hsync+hback+hres;
	
	parameter vres = 480;
	parameter vsync = 2;
	parameter vfront = 10;
	parameter vback = 33;
	parameter vtotal	= vfront+vsync+vback+vres;
	
	integer hcount, vcount;
	
	initial begin
		hcount = 0;
		vcount = 0;
	end
	
	always @(posedge clock) begin
	
		if ((hcount < (hres + hfront)) || (hcount > (hres + hfront + hsync))) vga_hsync <= 1'b1; //sets hsync
		else vga_hsync <= 1'b0;
	
		if ((vcount < (vres + vfront)) || (vcount > (vres + vfront + vsync))) vga_vsync <= 1'b0; //sets hsync
		else vga_vsync <= 1'b1;
	
		if (hcount == htotal) begin //increments vcount
			hcount = 0;
			vcount = vcount + 1;
		end
		
		if (vcount == vtotal -1) begin //starts the process over
			hcount = 0;
			vcount = 0;
		end
		
		if ((hcount <= hres) && (vcount <= vres)) begin //set memory address, and vblank
			mem_add <= ((vcount * hres) + hcount);
			vga_blank <= 1'b1;
		end
		else vga_blank <=1'b0;
		
		hcount = hcount + 1; //increment hcount
	end
	
endmodule
	
		