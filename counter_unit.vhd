library ieee;
use ieee.std_logic_1164.all;

-- toggle_swatch used to pause resume counter
entity counter_unit is
	port (Clk, reset, toggle_swatch: in std_logic;
		Q: buffer std_logic_vector (3 downto 0));
end;

architecture arch of counter_unit is
	signal J, K: std_logic_vector (3 downto 0);
	
	component ffjk is
	port (J, K, Clk, ClrN, Hld: in std_logic;
		Q: buffer std_logic);
	end component;
	
begin
	J(3) <= Q(2) and Q(1) and Q(0);
	J(2) <= Q(1) and Q(0);
	J(1) <= not Q(3) and Q(0);
	J(0) <= not Q(0) or Q(1);
	K(3) <= Q(3) and Q(0);
	K(2) <= Q(1) and Q(0);
	K(1) <= Q(0);
	K(0) <= not Q(3) or Q(0);

	FF3: ffjk port map ( J(3), K(3), Clk, reset, toggle_swatch, Q(3) );
	FF2: ffjk port map ( J(2), K(2), Clk, reset, toggle_swatch, Q(2) );
	FF1: ffjk port map ( J(1), K(1), Clk, reset, toggle_swatch, Q(1) );
	FF0: ffjk port map ( J(0), K(0), Clk, reset, toggle_swatch, Q(0) );

end;