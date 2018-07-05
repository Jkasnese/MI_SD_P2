module lcd_write(
	input Clock,
	input enable,
	input [87:0] data_in,
	output [7:0] lcd_data_out,
	output lcd_data_en
);


parameter 		WAIT = 1'b0,
				SEND = 1'b1;

reg [7:0] data_out;
reg [3:0] bytes_sent;
reg [1:0] reg_state, next;
reg reg_en, new_data;

// Detects everytime data changes
/*always @ (data_in) begin
	bytes_sent <= 4'd0;
end*/

always @ (posedge Clock) begin
	reg_state <= next;
end

always @ (*) begin
	if (enable == 1'b0) begin
		next <= WAIT;
	end
	else begin
		case (reg_state)
			WAIT: begin
				reg_en <= 1'b0;
				data_out <= data_in[7+(bytes_sent*8)-:8];
				if (bytes_sent == 4'd11) begin
					next <= WAIT;
				end
				else begin
					next <= SEND;
				end
			end
			SEND: begin
				reg_en <= 1'b1;
				bytes_sent <= bytes_sent + 1'b1;
				next <= WAIT;
			end
		endcase
	end
end

// IDLE
// WRITE CHAR
endmodule