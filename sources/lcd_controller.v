module lcd_controller(

	// Entradas
	 input Clock,  // 50  MHz
	 input Reset,
	 input [1:0] Modo_OP,

	// Saídas

	 output LCD_EN,
	 output LCD_RS,
	 output LCD_RW,
	 output [7:0] LCD_DADOS,
	 output idle
	);
	
	// Estadoss

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
						ENTRY_MODE = 4'b1011;


    // Tempos de delay. Clock de 1KHz
    parameter [5:0]
              tn_40ms  = 6'd40, 
              tn_10ms = 6'd10,
              tn_20ms = 6'd20,
              tn_4ms = 6'd4,
              tn_1ms = 6'd1;

    parameter [7:0] letra_A = 8'b01000001; // Testar escrita 

		
   reg [3:0] next = 4'b0000, reg_state = 4'b0000;
   reg reg_en = 1'b0, reg_rs = 1'b0; 
	reg reg_rw = 1'b0;
   reg [7:0] reg_db; // = 8'b11111111;
   reg [20:0] time_counter = 6'd0;
   reg num_of_lines = 1'b1, cursor_direction = 1'b1;
	reg [15:0] clk_conversor;
	reg lcd_clk, reg_idle;

	// Flags for delays
	reg flag_40ms, flag_20ms, flag_10ms, flag_4ms, flag_1ms, flag_rst = 1'b0;
		
	 
    // assign num_of_lines = Modo_OP[1];
    // assign cursor_direction = Modo_OP[0];

	// assign Colunas[0] = 1'b0;
	// assign Colunas[4:1] = 4'b1111;
    assign LCD_EN = reg_en;
    assign LCD_RS = reg_rs;
    assign LCD_RW = reg_rw;
    assign LCD_DADOS = reg_db;

    assign idle = reg_idle;

	// Flags counter
	always @ (posedge lcd_clk or posedge Reset or posedge flag_rst) begin
		if (Reset == 1'b1) begin
			time_counter <= 6'd0;
			flag_1ms <= 1'b0;
			flag_4ms <= 1'b0;
			flag_10ms <= 1'b0;
			flag_20ms <= 1'b0;
			flag_40ms <= 1'b0;
		end
		else begin
			if (flag_rst == 1'b1) begin
				flag_1ms <= 1'b0;
				flag_4ms <= 1'b0;
				flag_10ms <= 1'b0;
				flag_20ms <= 1'b0;
				flag_40ms <= 1'b0;
				time_counter <= 6'd0;
			end
			else begin
				time_counter <= time_counter + 1'b1;
				if (time_counter >= tn_1ms) begin
					flag_1ms <= 1'b1;
				end
				if (time_counter >= tn_4ms) begin
					flag_4ms <= 1'b1;
				end
				if (time_counter >= tn_10ms) begin
					flag_10ms <= 1'b1;
				end
				if (time_counter >= tn_20ms) begin
					flag_20ms <= 1'b1;
				end
				if (time_counter >= tn_40ms) begin
					flag_40ms <= 1'b1;
				end
			end
		end
	end

	// State machine clock
    always @ (posedge lcd_clk) begin
        begin
            reg_state <= next;
        end
    end

	 
    always @ (*) begin
    	reg_en = 1'b0;
	        case (reg_state)
            INIT: begin
            		reg_idle = 1'b0;
					 if (flag_40ms == 1'b1) begin 
							  reg_rs = 1'b0;
							  reg_db = 8'b00110000;
							  reg_en = 1'b1;
							  next = CONFIG;
							  flag_rst = 1'b1;
						 end
					 else begin   
							  next = INIT; 
						 end
				  end

            CONFIG:  begin
                        if(flag_4ms == 1'b1) begin
                                reg_rs = 1'b0;
                                reg_db = 8'b00110000;
							  	reg_en = 1'b1;
  							    next = CONFIG_2;
								 flag_rst = 1'b1;
                            end
                        else begin
                            next = CONFIG;
                        end
                    end

            CONFIG_2: begin
								if (flag_1ms == 1'b1) begin
										reg_rs = 1'b0;
										reg_db = 8'b00110000;
										reg_en = 1'b1;
								next = FUNCTION_SET;
								flag_rst = 1'b1;
										next = CONFIG_2;
								end
                      	else begin
                      		next = CONFIG_2;
                      	end
				end
            FUNCTION_SET: begin               // Tem coisas ajustáveis
            				if (flag_1ms == 1'b1) begin
		                        reg_rs = 1'b0;
		                        reg_db = 8'b0111001; // FUNCTION_SET {3'b0011, num_of_lines, 4'b001};
		                        reg_en = 1'b1;
								next = OSC_FREQ;
								flag_rst = 1'b1;
		                    end
		                    else begin
		                    	next = FUNCTION_SET;
		                    end
				end
            OSC_FREQ: begin
            			if (flag_1ms == 1'b1) begin
	                        reg_rs = 1'b0;
	                        reg_db = 8'b00010100; // OSC FREQ 8'b00001110;
	                        reg_en = 1'b1;
							next = POWER_CONTROL;
							flag_rst = 1'b1;
	                    end
	                    else begin
	                    	next = OSC_FREQ;
	                    end
				end
            POWER_CONTROL: begin //power contrl
            			if (flag_1ms == 1'b1) begin
	                        reg_rs = 1'b0;
	                        reg_db =  8'b01010110; // 8'b0111000; // POWR
	                        reg_en = 1'b1;
									flag_rst = 1'b1;
							next = FOLLOWER_CONTROL;
	                    end
	                    else begin
	                    	next = POWER_CONTROL;
	                    end
				end
            FOLLOWER_CONTROL: begin     //follower control              
            		if (flag_1ms == 1'b1) begin
                        reg_rs = 1'b0;
                        reg_db =  8'b01101101; 
                        reg_en = 1'b1;
						flag_rst = 1'b1;
						next = CONTRAST;
                    end
                    else begin
                    	next <= FOLLOWER_CONTROL;
                    end
			end
			CONTRAST: begin // Contrast
					if (flag_1ms == 1'b1) begin
						reg_rs = 1'b0;
						reg_db = 8'b01110000; // = 8'b10000000;
						reg_en = 1'b1;
						flag_rst = 1'b1;
						next = DISPLAY_ON;
					end
					else begin
						next = CONTRAST;
					end
			end
            DISPLAY_ON: begin 
            		if (flag_1ms == 1'b1) begin
                        reg_rs = 1'b0;
                        reg_db = 8'b00001110; // 8'b00001111; 
                        reg_en = 1'b1;
						flag_rst = 1'b1;
						next = ENTRY_MODE;
                    end
                    else begin
                    	next = DISPLAY_ON;
                    end
				end
            ENTRY_MODE: begin 
            		if (flag_1ms == 1'b1) begin
                        reg_rs = 1'b0;
                        reg_db = 8'b00001100; // {6'b000001, cursor_direction, 1'b0};
                        reg_en = 1'b1;
						flag_rst = 1'b1;
						next = DISPLAY_CLEAR;
                    end
                    else begin
                    	next = ENTRY_MODE;
                    end
				end
            DISPLAY_CLEAR: begin
							if (flag_1ms == 1'b1) begin
								  reg_rs = 1'b0;
								  reg_db = 8'b00000001;
								  reg_en = 1'b1;
							reg_rw = 1'b1;
							 flag_rst = 1'b1;
							 if (flag_10ms == 1'b1) begin
								next = IDLE;	
							 end else begin
								next = DISPLAY_CLEAR;
							 end
						end
       		end
            IDLE: begin
            	reg_rs = 1'b0;
            	reg_db = 8'b0;
            	reg_en = 1'b0;
            	flag_rst = 1'b1;
            	reg_idle = 1'b1;
            	next = IDLE;
            end
        endcase
    end

endmodule