module lcd(
	input Reset,
	input Clock,

	input [1:0] usr_op,
	input [31:0] crc,
	input crc_status,

	output [7:0] lcd_data,
	output lcd_en,
	output lcd_rs,
	output lcd_rw,
	output lcd_backlight
);

	wire [63:0] wire_crc_ascii;
	wire [15:0] wire_stats_string;
	wire [7:0] wire_lcd_data_out, wire_lcd_init_out;
	wire wire_idle;
	wire wire_lcd_clk;

	wire wire_lcd_en, wire_lcd_data_en;
	wire wire_lcd_rs;
	wire wire_lcd_rw;


	assign lcd_data = wire_idle ?  wire_lcd_init_out : wire_lcd_data_out;
	assign lcd_en = wire_idle ? wire_lcd_data_en : wire_lcd_en;	
	assign lcd_rs = wire_idle ? 1'b1 : 1'b0;
	assign lcd_rw = 1'b0;
	assign lcd_backlight = 1'b1;

	lcd_clk_decoder clkd(
		.sys_clk(Clock),
		.clk(wire_lcd_clk)
	);

	lcd_decoder dec(
		.crc32(crc),
		.show_string(wire_crc_ascii)
	);

	lcd_crc_stats_dec statsdec(
		.crc_status(crc_status),
		.status_string(wire_stats_string)
	);

	lcd_controller ctrl(

		.Clock(Clock),
		.Reset(Reset),
		.user_opt(usr_op),

		.LCD_EN(wire_lcd_en),
		.LCD_DATA(wire_lcd_init_out), 
		.idle(wire_idle)
	);

	lcd_write lcdw(
		.Clock(wire_lcd_clk),
		.enable(wire_idle),
		.data_in({wire_crc_ascii, 8'h20, wire_stats_string}),
		.lcd_data_out(wire_lcd_data_out),
		.lcd_data_en(wire_lcd_data_en)
	);


endmodule