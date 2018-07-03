	component nios is
		port (
			clk_clk           : in  std_logic                     := 'X';             -- clk
			lcd_export        : out std_logic_vector(31 downto 0);                    -- export
			rs232_rx_export   : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			rs232_tx_export   : out std_logic_vector(7 downto 0);                     -- export
			rx_read_in_port   : in  std_logic                     := 'X';             -- in_port
			rx_read_out_port  : out std_logic;                                        -- out_port
			rx_options_export : out std_logic_vector(7 downto 0);                     -- export
			rx_parity_export  : in  std_logic                     := 'X';             -- export
			leds_export       : out std_logic_vector(7 downto 0);                     -- export
			btn_export        : in  std_logic                     := 'X'              -- export
		);
	end component nios;

	u0 : component nios
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --        clk.clk
			lcd_export        => CONNECTED_TO_lcd_export,        --        lcd.export
			rs232_rx_export   => CONNECTED_TO_rs232_rx_export,   --   rs232_rx.export
			rs232_tx_export   => CONNECTED_TO_rs232_tx_export,   --   rs232_tx.export
			rx_read_in_port   => CONNECTED_TO_rx_read_in_port,   --    rx_read.in_port
			rx_read_out_port  => CONNECTED_TO_rx_read_out_port,  --           .out_port
			rx_options_export => CONNECTED_TO_rx_options_export, -- rx_options.export
			rx_parity_export  => CONNECTED_TO_rx_parity_export,  --  rx_parity.export
			leds_export       => CONNECTED_TO_leds_export,       --       leds.export
			btn_export        => CONNECTED_TO_btn_export         --        btn.export
		);

