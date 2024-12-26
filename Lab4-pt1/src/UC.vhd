library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port (
        clk : in std_logic;
        state : out std_logic
    );
end entity;

architecture a_UC of UC is
    signal s : std_logic := '0';
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
        if(s = '0')  then
            s <= '1';
        elsif (s = '1') then
            s <= '0';
        end if;
      end if;
   end process;

   state <= s;
end architecture;