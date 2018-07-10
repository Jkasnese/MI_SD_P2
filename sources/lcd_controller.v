module lcd_controller(

input Clock, 
input Reset,
input [1:0] user_opt,


output LCD_EN,
output [7:0] LCD_DATA,
output idle
);


    parameter   [3:0]   INIT = 4'b0000,
                        CONFIG = 4'b0001,
                        CONFIG_2 = 4'b0010,
                        FUNCTION_SET = 4'b0011,
                        OSC_FREQ = 4'b0100,
                        POWER_CONTROL = 4'b0101,
                        FOLLOWER_CONTROL = 4'b0110,
								CONTRAST = 4'b0111,
                        DISPLAY_ON = 4'b1000,
								IDLE = 4'b1001,
								DISPLAY_CLEAR = 4'b1010,
								ENTRY_MODE = 4'b1011,
								WRITE_CHAR = 4'b1100;


 parameter [20:0]
              t_40ms  = 21'd2_000_000,
              t_4_1ms = 21'd205_000,
              t_250ns = 21'd13,
              t_1ms = 21'd50_000;


reg reg_en = 1'b0;
reg reg_idle = 1'b0;
reg reg_rs, reg_rw;
reg [7:0] reg_db = 8'b0000000;
reg [20:0] counter = 21'd0;
reg [3:0] reg_state = 4'b0000;
reg [1:0] internal_state = 2'b00, prev_state = 2'b00;

wire num_of_lines, cursor_direction;

assign num_of_lines = user_opt[0];
assign cursor_direction = user_opt[1];


reg flag_rst = 1'b1, flag_40ms = 1'b0, flag_4ms = 1'b0, flag_250ns = 1'b0, flag_1ms = 1'b0;

assign LCD_DATA = reg_db;
assign LCD_EN = ~reg_en;


always @(posedge Clock) begin

	if(flag_rst == 1'b1) begin
		flag_1ms <= 1'b0;
		flag_250ns <=1'b0;
		flag_4ms <= 1'b0;
		flag_40ms <= 1'b0;
      counter <= 21'd0;
	end

	else begin

		if(counter >= t_250ns) begin
			flag_250ns <= 1'b1;
		end
		else begin
			flag_250ns <= 1'b0;
		end

	if(counter >= t_1ms) begin
			flag_1ms <= 1'b1;
			end
			else begin
				flag_1ms <= 1'b0;
			end

	if(counter >= t_4_1ms) begin
			flag_4ms <= 1'b1;
			end
			else begin
				flag_4ms <= 1'b0;
			end

	if(counter >= t_40ms) begin
			flag_40ms <= 1'b1;
			end
			else begin
				flag_40ms <= 1'b0;
			end

	    counter = counter + 1'd1;

	    end
	end

	
	always @ (posedge Clock) begin
		
		if(Reset == 1'b1) begin
			reg_state <= INIT;
			internal_state <= 2'b00;
		end
		
		else begin 
				case(reg_state)
				
					INIT: begin
						case(internal_state)
							2'b00: begin 
								flag_rst <= 1'b0;
									if(flag_40ms == 1'b1) begin
										reg_db <= 8'b00110000;
										reg_rs <= 1'b0;
										reg_en <= 1'b1;
										prev_state <= internal_state;
										internal_state <= internal_state + 1'b1;
										reg_state <= reg_state;
										flag_rst <= 1'b1;
									end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
								if(prev_state == 2'b00) begin
									flag_rst = 1'b1;
								end
								else begin
									flag_rst = 1'b0;
								end
							
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									reg_rs <= 1'b0;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									reg_state <= reg_state;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
								
								if(prev_state == 2'b01) begin
									flag_rst = 1'b1;
								end
								else begin
									flag_rst = 1'b0;
								end
								
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_state <= CONFIG;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					CONFIG: begin
						
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
							
								if(flag_4ms == 1'b1) begin
									reg_db <= 8'b00110000;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									reg_state <= reg_state;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end						
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
							
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									reg_state <= reg_state;
									flag_rst <= 1'b1;
								end
								
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_state <= CONFIG_2;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					CONFIG_2: begin

						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b00110000;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									reg_state <= reg_state;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									reg_state <= reg_state;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_state <= FUNCTION_SET;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					FUNCTION_SET: begin
						
						case(internal_state)
							2'b00: begin 
							
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
							
								if(flag_1ms == 1'b1) begin
									reg_db <= {4'b0011, num_of_lines, 3'b001}; // 8'b00111001; 
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_state <= OSC_FREQ;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					OSC_FREQ: begin
						
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
							if(flag_1ms == 1'b1) begin
									reg_db <= 8'b00010100;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									reg_state <= POWER_CONTROL;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					POWER_CONTROL: begin
					
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b01010110;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									prev_state <= internal_state;
									reg_state <= FOLLOWER_CONTROL;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					FOLLOWER_CONTROL: begin
						
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b01101101;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									prev_state <= internal_state;
									reg_state <= CONTRAST;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end
					
					CONTRAST: begin
						
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b01110000;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									prev_state <= internal_state;
									reg_state <= DISPLAY_ON;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					DISPLAY_ON: begin

						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b00001111;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
									flag_rst <= 1'b1;
								end
								else begin
									flag_rst <= 1'b0;
								end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									prev_state <= internal_state;
									reg_state <= ENTRY_MODE;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					ENTRY_MODE: begin
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <=  {6'b000001, cursor_direction, 1'b0}; // 8'b00000101;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
						if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									reg_state <= DISPLAY_CLEAR;
									prev_state <= internal_state;
									internal_state <= 2'b00;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end

					DISPLAY_CLEAR: begin
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_db <= 8'b00000001;
									reg_rs <= 1'b0;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
							if(prev_state == 2'b00) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_1ms == 1'b1) begin
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_en <= 1'b0;
									reg_db <= reg_db;
									prev_state <= internal_state;
									internal_state <= 2'b00;
									reg_state <= WRITE_CHAR;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end
					
					WRITE_CHAR: begin
						case(internal_state)
							2'b00: begin 
							if(prev_state == 2'b10) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_40ms == 1'b1) begin
									reg_db <= 8'b00110000;
									reg_rs <= 1'b1;
									reg_en <= 1'b1;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
							2'b01: begin
								if(prev_state == 2'b00) begin
										flag_rst <= 1'b1;
									end
									else begin
										flag_rst <= 1'b0;
									end
									 
								if(flag_40ms == 1'b1) begin
									reg_rs <= reg_rs;
									reg_db <= reg_db;
									reg_en <= 1'b0;
									prev_state <= internal_state;
									internal_state <= internal_state + 1'b1;
									flag_rst <= 1'b1;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end

							2'b10: begin
							if(prev_state == 2'b01) begin
								flag_rst <= 1'b1;
							end
							else begin
								flag_rst <= 1'b0;
							end
								if(flag_250ns == 1'b1) begin
									flag_rst <= 1'b1;
									reg_db <= reg_db;
									reg_rs <= reg_rs;
									reg_state <= IDLE;
									prev_state <= internal_state;
									internal_state <= 2'b10;
								end
								else begin 
									prev_state <= internal_state;
									reg_state <= reg_state;
									internal_state <= internal_state;
								end
							end
						endcase
					end
					
					IDLE: begin
					reg_rs <= 1'b0;
						if(flag_40ms == 1'b1) begin
							flag_rst <= 1'b0;
							reg_en <= 1'b0;
							reg_rs <= 1'b0;
							reg_rw <= 1'b0;
							reg_db <= 8'b00000000;
							reg_state <= IDLE;
							reg_idle <= 1'b1;
						end
					end
			endcase
		end
	end
endmodule
