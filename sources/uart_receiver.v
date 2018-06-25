/*
    Module to receive serial data and output paralel 8 bits data.
    If number of bits in a package is less than 8, appends 0s to MSBs to complete 8 bit bus.

    TODO: Implement handshake protocol.
	 TODO: Fix reg done logic. Should be used to handshake both from PC to FPGA and FPGA to Nios.
*/

module uart_receiver (
    input reset,
    input clk,
    input timeout,

    input serial_in,
    input handshake, // 1 y, 0 n
    input [1:0] data_bits, // 11 5, 10 6, 01 7, 00 8;
    
	 input data_read,
	 
    output enable_clk,
    output receiving,
    output [7:0] data_in,
    output data_ready
//    output everything_ready
);

//localparam max_packages = 9000;
//localparam packages_counter_width = log2(max_packages);

//reg [15:0] packages_counter;
//reg [15:0] total_packages;

//localparam timeout = 60; // Timeout in seconds
// TODO: implement timeout

reg [7:0] data_received;
reg [3:0] bits_received;
reg [3:0] data_width;
reg done;
reg en_clk;

assign data_ready = done;
assign enable_clk = en_clk; 

assign receiving = bits_received != 4'd0;
reg [7:0] wire_data_in;

assign data_in = wire_data_in;

// Clock enable logic. If serial received start_bit, enable. If done receiving, disable.
always @ (negedge serial_in or posedge done) begin
	if (serial_in == 1'b0) begin
		en_clk <= 1'b1;
	end
	if (done == 1'b1) begin
		en_clk <= 1'b0;
	end
end

// Data_bits decoder to data width and data_in bus index
always @ (posedge clk) begin
    case (data_bits)
        2'b11: begin
            wire_data_in <= {3'b0, data_received[7:3]};
            data_width <= 4'b0101;
        end
        2'b10: begin
            wire_data_in <= {2'b0, data_received[7:2]};
            data_width <= 4'b0110;
        end
        2'b01: begin
            wire_data_in <= {1'b0, data_received[7:1]};
            data_width <= 4'b0111;
        end
        2'b00: begin
            wire_data_in <= data_received;
            data_width <= 4'b1000;
        end
    endcase
end

// Receive bits into shift register
always @ (posedge clk or posedge reset or posedge timeout or posedge data_read) begin
    if (reset == 1'b1 || timeout == 1'b1) begin
        bits_received <= 4'd0;
        done <= 1'b0;
        //total_packages <= 16'd0;
    end
	 else if (data_read == 1'b1) begin
		  done <= 1'b0;
	 end
    else begin
        if (bits_received < data_width+1) begin // 1 because you also read the start bit
            done <= 1'b0;
            data_received <= {serial_in, data_received[7:1]};
            bits_received <= bits_received + 1'b1;
        end
        else begin
            done <= 1'b1;
            bits_received <= 4'd0;
		  end
    end
end

endmodule
