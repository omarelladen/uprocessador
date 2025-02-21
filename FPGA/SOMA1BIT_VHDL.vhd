Library IEEE;
use ieee.std_logic_1164.all;


entity SOMA1BIT_VHDL is
	port(
			A, B, Ci: in std_logic;
			Cout, S: out std_logic
	);
end SOMA1BIT_VHDL;


architecture GATE_LEVEL of SOMA1BIT_VHDL is
	begin 
		Cout <= not ((not (B and A) and not (ci)) or not (A or B));
		S <= ( (A or B) and not (B and A)) xor Ci;
	end GATE_LEVEL;