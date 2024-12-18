library ieee;
use ieee.std_logic_1164.all;

entity counter_unit is
    port (
        Clk, reset, toggle_swatch: in std_logic;
        Q10, Q1: buffer std_logic_vector(3 downto 0)
    );
end;

architecture arch of counter_unit is
    signal J10, J1, K10, K1: std_logic_vector(3 downto 0);
    signal tens_rst: std_logic;
    signal tens_enable: std_logic;
    signal RESET_TOP_LEVEL: std_logic;
    signal HLD_CNTR: std_logic;
    signal HOLD: std_logic;

    component ffjk is
        port (J, K, Clk, ClrN, Hld: in std_logic;
            Q: buffer std_logic);
    end component;

begin
	process(clk)
	begin
		if Q10 = "0101" and Q1 = "1001" then
			tens_rst <= '1';
		else
			tens_rst <= '0';
		end if;
	end process;
    
    -- Ones place J and K generation
    J1(3) <= Q1(2) and Q1(1) and Q1(0);
    J1(2) <= Q1(1) and Q1(0);
    J1(1) <= not Q1(3) and Q1(0);
    J1(0) <= not Q1(0) or Q1(1);
    
    K1(3) <= Q1(3) and Q1(0);
    K1(2) <= Q1(1) and Q1(0);
    K1(1) <= Q1(0);
    K1(0) <= not Q1(3) or Q1(0);

    -- Tens place J and K generation
    J10(3) <= Q10(2) and Q10(1) and Q10(0);
    J10(2) <= Q10(1) and Q10(0);
    J10(1) <= not Q10(3) and Q10(0);
    J10(0) <= not Q10(0) or Q10(1);
    
    K10(3) <= Q10(3) and Q10(0);
    K10(2) <= Q10(1) and Q10(0);
    K10(1) <= Q10(0);
    K10(0) <= not Q10(3) or Q10(0);

    -- Tens place clock generation (when ones place reaches 9)
    tens_enable <= Q1(3) and not Q1(2) and not Q1(1) and Q1(0);
    HLD_CNTR <= not tens_enable;
    HOLD <= HLD_CNTR or toggle_swatch;
    RESET_TOP_LEVEL <= reset or tens_rst;

    -- Ones counter flip-flops
    FF_1_3: ffjk port map ( J1(3), K1(3), Clk, reset, toggle_swatch, Q1(3) );
    FF_1_2: ffjk port map ( J1(2), K1(2), Clk, reset, toggle_swatch, Q1(2) );
    FF_1_1: ffjk port map ( J1(1), K1(1), Clk, reset, toggle_swatch, Q1(1) );
    FF_1_0: ffjk port map ( J1(0), K1(0), Clk, reset, toggle_swatch, Q1(0) );
    
    -- Tens counter flip-flops
    FF_10_3: ffjk port map ( J10(3), K10(3), Clk, RESET_TOP_LEVEL, HOLD, Q10(3) );
    FF_10_2: ffjk port map ( J10(2), K10(2), Clk, RESET_TOP_LEVEL, HOLD, Q10(2) );
    FF_10_1: ffjk port map ( J10(1), K10(1), Clk, RESET_TOP_LEVEL, HOLD, Q10(1) );
    FF_10_0: ffjk port map ( J10(0), K10(0), Clk, RESET_TOP_LEVEL, HOLD, Q10(0) );

end;
