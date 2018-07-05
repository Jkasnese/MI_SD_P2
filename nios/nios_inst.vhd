	component nios is
		port (
			clk_clk           : in  std_logic                     := 'X';             -- clk
			lcd_config_export : out std_logic_vector(1 downto 0);                     -- export
			lcd_crc_export    : out std_logic_vector(31 downto 0);                    -- export
			lcd_stats_export  : out std_logic;                                        -- export
			rs232_rx_export   : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			rs232_tx_export   : out std_logic_vector(7 downto 0);                     -- export
			rx_options_export : out std_logic_vector(7 downto 0);                     -- export
			rx_parity_export  : in  std_logic                     := 'X';             -- export
			rx_read_in_port   : in  std_logic                     := 'X';             -- in_port
			rx_read_out_port  : out std_logic                                         -- out_port
		);
	end component nios;

	u0 : component nios
		port map (
			clk_clk           => CONNECTED_TO_clk_clk,           --        clk.clk
			lcd_config_export => CONNECTED_TO_lcd_config_export, -- lcd_config.export
			lcd_crc_export    => CONNECTED_TO_lcd_crc_export,    --    lcd_crc.export
			lcd_stats_export  => CONNECTED_TO_lcd_stats_export,  --  lcd_stats.export
			rs232_rx_export   => CONNECTED_TO_rs232_rx_export,   --   rs232_rx.export
			rs232_tx_export   => CONNECTED_TO_rs232_tx_export,   --   rs232_tx.export
			rx_options_export => CONNECTED_TO_rx_options_export, -- rx_options.export
			rx_parity_export  => CONNECTED_TO_rx_parity_export,  --  rx_parity.export
			rx_read_in_port   => CONNECTED_TO_rx_read_in_port,   --    rx_read.in_port
			rx_read_out_port  => CONNECTED_TO_rx_read_out_port   --           .out_port
		);

