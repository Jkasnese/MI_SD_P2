
module nios (
	clk_clk,
	lcd_export,
	rs232_rx_export,
	rs232_tx_export,
	rx_read_in_port,
	rx_read_out_port,
	rx_options_export,
	rx_parity_export,
	leds_export,
	btn_export);	

	input		clk_clk;
	output	[31:0]	lcd_export;
	input	[7:0]	rs232_rx_export;
	output	[7:0]	rs232_tx_export;
	input		rx_read_in_port;
	output		rx_read_out_port;
	output	[7:0]	rx_options_export;
	input		rx_parity_export;
	output	[7:0]	leds_export;
	input		btn_export;
endmodule
