library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port (
        clk, rst : in std_logic;
        instr : in unsigned(18 downto 0);
        state, mem_rd, pc_wr, jump_en : out std_logic
    );
end entity;

architecture a_UC of UC is
    signal s : std_logic := '0';
    signal opcode : unsigned(3 downto 0);
begin
   process(clk)
   begin
      if rst='1' then
        s <= '0';
      elsif(rising_edge(clk)) then
        if(s = '0')  then
            s <= '1';
        elsif (s = '1') then
            s <= '0';
        end if;
      end if;
   end process;

   state <= s;
   
   mem_rd <= '1' when s = '0' else
             '0';
   pc_wr  <= '1' when s = '1' else
             '0';

   opcode <= instr(18 downto 15);

   jump_en <=  '1' when opcode="0001" else
               '0';
end architecture;