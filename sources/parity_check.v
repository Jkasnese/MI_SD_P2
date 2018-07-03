module parity_check(
    input reset,
    input clk,

    input use_parity, //1 y, 0 n
    input parity_type, // 0 even, 1 odd 

    input rx_idle,
    input serial_in,

    output check // 0 ok, 1 err
);

reg status; // 0 ok, 1 err

assign check =  use_parity ? status : 1'b0;

always @ (posedge clk or posedge reset or posedge rx_idle) begin
    if (reset == 1'b1 || rx_idle == 1'b1) begin
        status <= parity_type;
    end
    else begin
        if (serial_in == 1'b1) begin
            status <= ~status;
        end
    end
end

endmodule
