module uart_sender(
    input reset,
    input clk,
    
    input send_enable,
    input [7:0] data_to_send,

	 output clk_enable,
    output sending,
    output done,
    output serial_out
);

reg bit_out;
reg [3:0] i;

wire busy;

assign sending = (i != 4'd0);
assign serial_out = bit_out;
assign done = i[3];

// Send logic. When done, send_enable will be set to low.
always @ (posedge clk) begin
    if (reset || !send_enable) begin
        bit_out <= 1'b1;     
        i <= 3'd0;
    end
    else if (i[3] != 1'b1)begin
        bit_out <= data_to_send[i];
        i <= i + 1'b1;
    end
end

endmodule
