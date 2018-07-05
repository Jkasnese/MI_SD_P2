module lcd_decoder(
	input [31:0] crc32,
	output [63:0] show_string
);

`include "chars.vh"

reg [31:0] crc = 32'hAB01EF89;

reg [63:0] out_string;
assign show_string = out_string;

generate
	genvar i;
	for (i = 0; i < 32; i = i + 4)
	begin:hextoascii
		always @ (*) begin
			case (crc[3+i:i])
				4'b0000:
					out_string[7+(i*2):i*2] <= `ZERO;
				4'b0001:
					out_string[7+(i*2):i*2] <= `ONE;
				4'b0010:
					out_string[7+(i*2):i*2] <= `TWO;
				4'b0011:
					out_string[7+(i*2):i*2] <= `THREE;
				4'b0100:
					out_string[7+(i*2):i*2] <= `FOUR;
				4'b0101:
					out_string[7+(i*2):i*2] <= `FIVE;
				4'b0110:
					out_string[7+(i*2):i*2] <= `SIX;
				4'b0111:
					out_string[7+(i*2):i*2] <= `SEVEN;
				4'b1000:
					out_string[7+(i*2):i*2] <= `EIGHT;
				4'b1001:
					out_string[7+(i*2):i*2] <= `NINE;
				4'b1010:
					out_string[7+(i*2):i*2] <= `A;
				4'b1011:
					out_string[7+(i*2):i*2] <= `B;
				4'b1100:
					out_string[7+(i*2):i*2] <= `C;
				4'b1101:
					out_string[7+(i*2):i*2] <= `D;
				4'b1110:
					out_string[7+(i*2):i*2] <= `E;
				4'b1111:
					out_string[7+(i*2):i*2] <= `F;
			endcase
		end // end always
	end // end for
endgenerate
endmodule