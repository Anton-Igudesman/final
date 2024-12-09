library ieee;
use ieee.std_logic_1164.all;

entity ffjk is
	port (J, K, Clk, ClrN, Hld: in std_logic;
		Q: buffer std_logic);
end;

architecture arch of ffjk is
begin
	process(clk)
	begin
		if clk'event and Clk = '1' then
			if ClrN = '1' then
				Q <= '0';
			elsif Hld = '1' then
				Q <= Q;
			--elsif toggle_strt = '0' then
				--Q <= Q;
			elsif J = '0' and K = '1' then
				Q <= '0';
			elsif J = '1' and K = '0' then
				Q <= '1';
			elsif J = '1' and K = '1' then
				Q <= not Q;
			end if;
		end if;
	end process;
end;