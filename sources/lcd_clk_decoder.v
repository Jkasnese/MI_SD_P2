module lcd_clk_decoder(
	input sys_clk,
	output clk
);

reg [15:0] clk_divisor;
reg out_clk;

assign clk = out_clk;

// Convert 50MHz clk (20 ns) to 1KHz (1ms)
always @ (posedge sys_clk) begin
	if (clk_divisor == 16'd50_000) begin
		out_clk <= ~out_clk;
		clk_divisor <= 16'd1;
	end
	else begin
		clk_divisor <= clk_divisor + 1'b1;
	end
end

endmodule