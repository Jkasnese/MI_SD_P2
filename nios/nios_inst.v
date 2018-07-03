	nios u0 (
		.clk_clk           (<connected-to-clk_clk>),           //        clk.clk
		.lcd_export        (<connected-to-lcd_export>),        //        lcd.export
		.rs232_rx_export   (<connected-to-rs232_rx_export>),   //   rs232_rx.export
		.rs232_tx_export   (<connected-to-rs232_tx_export>),   //   rs232_tx.export
		.rx_read_in_port   (<connected-to-rx_read_in_port>),   //    rx_read.in_port
		.rx_read_out_port  (<connected-to-rx_read_out_port>),  //           .out_port
		.rx_options_export (<connected-to-rx_options_export>), // rx_options.export
		.rx_parity_export  (<connected-to-rx_parity_export>),  //  rx_parity.export
		.leds_export       (<connected-to-leds_export>),       //       leds.export
		.btn_export        (<connected-to-btn_export>)         //        btn.export
	);

