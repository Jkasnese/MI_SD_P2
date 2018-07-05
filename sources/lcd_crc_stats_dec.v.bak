module lcd_crc_stats_dec(
	input crc_status,
	output [15:0] status_string
);

reg [15:0] out_string;

assign status_string = out_string;

always @ (*) begin
	if (crc_status == 1'b1) begin
		out_string <= 16'h5572; // <= er ascii
	end	
	else begin
		out_string <= 16'h6F6B; // <= ok ascii
	end
end