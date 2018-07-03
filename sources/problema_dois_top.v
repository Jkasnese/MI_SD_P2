module problema_dois_top(
	input clock,
	input reset,
	input switch, // TESTE
	
	input serial_in,
	output serial_out,
	
	output [7:0] lcd,
	output [7:0] led // TESTE
);



wire [7:0] wire_data_in;
wire [7:0] leds; // TESTE
wire [31:0] wire_crc;
//wire [7:0] wire_tx_out, usr_options;
reg [7:0] usr_options = 8'b11000000;

wire wire_data_read_nios;

assign led = {wire_new_data, wire_data_in[6:0]};

reg [7:0] data_out, data_in;
reg data_read_nios;

	
/*	nios u0 (
		.clk_clk           (clock),           //      clk.clk
		.lcd_export(wire_crc),
		.rs232_rx_export (wire_data_in),  // rs232_rx.in_port
		.rs232_tx_export   (wire_tx_out),   // rs232_tx.export
		.rx_read_in_port   (wire_new_data),   //    rx_read.in_port
		.rx_read_out_port  (wire_data_read_nios),  //           .out_port
		.rx_options_export(usr_options),
		.rx_parity_export  (wire_parity_status),   //  rx_parity.export
		.leds_export       (leds),       //       leds.export
		.btn_export        (switch)         //        btn.export
	);*/
	
	uart uart1(
    .reset(reset),
    .sys_clk(clock),
    .serial_in(serial_in),
    
	 .usr_options(usr_options),
	 .data_read_nios(wire_data_read_nios), // TESTE TODO: to be substituted by reg to be written by Nios.
	 
    .serial_out(serial_out),
	 .data_in_nios(wire_data_in),
	 .parity_status(wire_parity_status),
	 .new_data(wire_new_data)
	);


//lcd lcd();
	
endmodule