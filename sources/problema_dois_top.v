module problema_dois_top(
	input clock,
	input reset,
	
	input serial_in,
	output serial_out,
	output cts,
	
	output [7:0] lcd_data,
	output lcd_en,
	output lcd_rs,
	output lcd_rw,
	output lcd_backlight

);
/*
// UART
wire wire_cts;
wire [7:0] wire_data_in;
//wire [7:0] wire_tx_out, usr_options;
wire[7:0] usr_options;
wire wire_data_read_nios;
assign cts = wire_cts;
*/
// LCD
reg [1:0] wire_lcd_config = 2'b00;
reg wire_crc_stats = 1'b0;
reg[31:0] wire_crc = 32'hFFFFFFFF;

/*	
	nios u0 (
		.clk_clk           (clock),           //      clk.clk
		.lcd_config_export (wire_lcd_config), // lcd_config.export
		.lcd_crc_export    (wire_crc),
		.lcd_stats_export  (wire_crc_stats),  //  lcd_stats.export
		.rs232_rx_export (wire_data_in),  // rs232_rx.in_port
		.rs232_tx_export   (wire_tx_out),   // rs232_tx.export
		.rx_options_export(usr_options),
		.rx_parity_export  (wire_parity_status),   //  rx_parity.export
		.rx_read_in_port   (wire_new_data),   //    rx_read.in_port
		.rx_read_out_port  (wire_data_read_nios),  //           .out_port
		.lcd_program(program_lcd)
	);
		
	uart uart1(
    .reset(reset),
    .sys_clk(clock),
    .serial_in(serial_in),
    
	 .usr_options(usr_options),
	 .data_read_nios(wire_data_read_nios), // TESTE TODO: to be substituted by reg to be written by Nios.
	 
	.cts(wire_cts),
    .serial_out(serial_out),
	 .data_in_nios(wire_data_in),
	 .parity_status(wire_parity_status),
	 .new_data(wire_new_data)
	);
*/

	lcd lcd(
		.Reset(reset),
		.Clock(clock),

		.usr_op(wire_lcd_config),
		.crc(wire_crc),
		.crc_status(wire_crc_stats),
		//.program(program_lcd),

		.lcd_data(lcd_data),
		.lcd_en(lcd_en),
		.lcd_rs(lcd_rs),
		.lcd_rw(lcd_rw),
		.lcd_backlight(lcd_backlight)
	);
	
endmodule