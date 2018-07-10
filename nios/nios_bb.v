
module nios (
	clk_clk,
	lcd_config_export,
	lcd_crc_export,
	lcd_stats_export,
	rs232_rx_export,
	rs232_tx_export,
	rx_options_export,
	rx_parity_export,
	rx_read_in_port,
	rx_read_out_port,
	lcd_reset_export);	

	input		clk_clk;
	output	[1:0]	lcd_config_export;
	output	[31:0]	lcd_crc_export;
	output		lcd_stats_export;
	input	[7:0]	rs232_rx_export;
	output	[7:0]	rs232_tx_export;
	output	[7:0]	rx_options_export;
	input		rx_parity_export;
	input		rx_read_in_port;
	output		rx_read_out_port;
	output		lcd_reset_export;
endmodule
