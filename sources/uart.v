/*
    Registrador de configurações:

    B0 (LSB) - Presença de paridade: (1 sim/ 0 não)
    B1 - Paridade: (0 par/1impar)
    B2e3 - Dados: (11 5, 10 6, 01 7, 00 8)
    B4 - Stopbits: um 0, dois 1
    B5 - Handshake: (1sim/0não)
    B6e7 - Velocidade clock: (0 9600/ 1 19200 / 2 57600 / 3 115200
*/

module uart(
    input reset,
    input sys_clk,
    input serial_in,
    
	 input data_read, // TESTE TODO: to be substituted by reg to be written by Nios.
	 
    output serial_out,
	 output [7:0] led
);


reg [7:0] usr_options = 8'b11000000;
wire [8:0] data_in;
reg [8:0] reg_data_in;

assign led = data_in; // TESTE

always @ (posedge sys_clk) begin
	reg_data_in <= data_in;
end

wire uart_clk_rx;
wire uart_clk_tx;

wire wire_parity_status;

// RX
wire wire_timeout;
wire wire_rx_busy;
wire wire_rx_done;
wire wire_rx_start;

// TX
reg [8:0] data_out; // msb = send_enable
wire [7:0] wire_data_out = data_out[7:0];
wire wire_tx_busy;
wire wire_tx_done;

always @ (posedge wire_tx_done) begin
    data_out[8] <= 1'b0;
end

clk_decoder cd_rx (
    .sys_clk(sys_clk),
    .usr_option(usr_options[7:6]),
    .reset(reset),
    .enable(wire_rx_start),
    .clk(uart_clk_rx)
);

clk_decoder cd_tx (
    .sys_clk(sys_clk),
    .usr_option(usr_options[7:6]),
    .reset(reset),
    .enable(data_out[8]),
    .clk(uart_clk_tx)
);

timeout_gen to(
    .sys_clk(sys_clk),
    .receiving(wire_rx_busy),
    .serial_in(serial_in),
    .timeout(wire_timeout)
);

parity_check parity(
    .reset(reset),
    .clk(uart_clk_rx),
    .use_parity(usr_options[0]), //1 y, 0 n
    .parity_type(usr_options[1]), // 1 odd 0 even
    .serial_in(serial_in),
    .done(wire_rx_done), // signal when receiving is done
    .check(wire_parity_status) // 1 ok, 0 err
);

uart_receiver rx (
    .reset(reset),
    .clk(uart_clk_rx),
    .timeout(wire_timeout),
    .serial_in(serial_in),
    .handshake(usr_options[5]), // 1 y, 0 n
    .data_bits(usr_options[3:2]), // 11 5, 10 6, 01 7, 00 8;
	 .data_read(data_read),
    .enable_clk(wire_rx_start),
    .receiving(wire_rx_busy),
    .data_in(data_in),
    .data_ready(wire_rx_done)
);

uart_sender tx(
    .reset(reset),
    .clk(uart_clk_tx),
    .send_enable(data_out[8]),
    .data_to_send(wire_data_out),
    .sending(wire_tx_busy),
    .done(wire_tx_done),
    .serial_out(serial_out)
);

endmodule