library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity freq8 is
	port ( clk: in std_logic; -- Pin connected to P11 (N14)
			clk_8: out std_logic);-- Can check it using PIN A8 - LEDR0

	end freq8;
  
architecture freq_div of freq8 is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
  
begin
  
process(clk)
	begin
	if(clk'event and clk='1') then
		count <=count+1;
		if (count = 50000000/(64)) then -- (25 MHz) ( /(2*25000000) )
			tmp <= NOT tmp;
			count <= 1;
		end if;
	end if;
	clk_8 <= tmp;
end process;
 
end freq_div;