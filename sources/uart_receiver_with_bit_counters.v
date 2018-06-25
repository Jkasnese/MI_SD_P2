module uart_receiver (
    input reset,
    input clk,

    input serial_in,
    input handshake, // 1 y, 0 n
    input [2:0] data_bits, // 5, 6, 7, 8(000);
    
    output reading_data,
    output [7:0] data,
    output data_ready
);

localparam max_packages = 2000;
localparam packages_counter_width = log2(max_packages);
localparam timeout = 60; // Timeout in seconds
// TODO: implement timeout

reg reg_reading_data;
reg [2:0] bits_received;
reg [7:0] data_received;

reg [packages_counter_width-1:0] packages_counter;

always @ (posedge clk) begin
    if (reset == 1'b1) begin
        reg_reading_data <= 1'b0;
        bits_received <= 3'b0;
    end
    else begin
        data_received <= {serial_in, data_received[7:1]};
        bits_received <= bits_received + 1'b1;
    end
end
