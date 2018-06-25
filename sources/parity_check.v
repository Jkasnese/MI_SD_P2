module parity_check(
    input reset,
    input clk,

    input use_parity, //1 y, 0 n
    input parity_type, // 1 odd 0 even

    input serial_in,
    input done, // signal when receiving is done

    output check // 1 ok, 0 err
);

reg status = 1'b1; // 1 ok, 0 err

assign check =  use_parity ? status : 1'b1;

always @ (posedge clk) begin
    if (reset == 1'b1) begin
        status <= 1'b1;
    end
    else begin
        if (serial_in == 1'b1) begin
            status <= ~status;
        end
        if (done == 1'b1 && parity_type == 1'b1) begin // done and parity is odd
                status <= ~status;
        end
    end

end

endmodule
