library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port( endereco   : in unsigned(11 downto 0);
         rom_out       : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of unsigned(18 downto 0);
   constant conteudo_rom : mem := (
      0 => B"0011_001_010_000000000",  --ld r2, 0 (A)
      1 => B"0011_001_011_000000000",  --ld r3, 0 (B)
      2 => B"0010_000_011_010_000000", --add r3, r2 (C)
      3 => B"0011_000_010_000000001",  --addi r2, 1 (D)
      4 => B"0011_001_100_000011110",  --ld r4, 30  (E)
                                       -- cmp r2,r4 (4 e 5 → cmpi r2,30)
      5 => B"0010_011_010_100_000000", --cmp
      6 => B"0011_010_010_000011110",  --cmpi
      7 => B"0100_001_000_111111101",  --blt -2 (ble -2)
      8 => B"0100_000_000_111111101",  --apenas para testar o ble
      9 => B"0010_010_100_011_000000", --mov r4, r3 (F)
      others => (others=>'0') --casos omissos => (zero em todos os bits) ()
   );
   
begin
   rom_out <= conteudo_rom(to_integer(endereco)); --sem clk pra ler
end architecture;