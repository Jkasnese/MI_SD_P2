	nios u0 (
		.clk_clk           (<connected-to-clk_clk>),           //        clk.clk
		.lcd_config_export (<connected-to-lcd_config_export>), // lcd_config.export
		.lcd_crc_export    (<connected-to-lcd_crc_export>),    //    lcd_crc.export
		.lcd_stats_export  (<connected-to-lcd_stats_export>),  //  lcd_stats.export
		.rs232_rx_export   (<connected-to-rs232_rx_export>),   //   rs232_rx.export
		.rs232_tx_export   (<connected-to-rs232_tx_export>),   //   rs232_tx.export
		.rx_options_export (<connected-to-rx_options_export>), // rx_options.export
		.rx_parity_export  (<connected-to-rx_parity_export>),  //  rx_parity.export
		.rx_read_in_port   (<connected-to-rx_read_in_port>),   //    rx_read.in_port
		.rx_read_out_port  (<connected-to-rx_read_out_port>),  //           .out_port
		.lcd_reset_export  (<connected-to-lcd_reset_export>)   //  lcd_reset.export
	);

