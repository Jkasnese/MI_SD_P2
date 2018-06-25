/*
    This module decodes a user option into a baudrate.
    Baudrate: 9600 (00), 19200 (01), 57600 (10), 115200 (11) b/s
*/

module clk_decoder(
    input sys_clk,
    input [1:0] usr_option,
    input reset,
    input enable,
    output clk
);


//localparam sys_clk_rate = 50_000_000; // 50MHz
reg [12:0] selected_baudrate;

reg [12:0] counter;
reg out_clk = 1'b0;
assign clk = out_clk;

// This first module selects the number that the system clock (50mhz) will be diveded by:
always @ (*) begin
    case (usr_option)
        2'b00:
            selected_baudrate = 13'd5207;
        2'b01:
            selected_baudrate = 13'd2603;
        2'b10:
            selected_baudrate = 13'd867;
        2'b11:
            selected_baudrate = 13'd217;
    endcase
end

always @ (posedge sys_clk) begin
    if (reset == 1'b1 || !enable) begin
        counter <= 13'd0;
        out_clk <= 1'b0;
    end
    else begin
        if (counter < selected_baudrate) begin
            counter <= counter + 1'b1;
        end
        else begin
            out_clk = ~out_clk;
            counter <= 1'b0;
        end
    end
end

endmodule
