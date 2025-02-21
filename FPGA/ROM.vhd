library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
       endereco : in unsigned(11 downto 0);
       rom_out : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 128) of unsigned(18 downto 0); -- precisa mudar tamanho da mem para nao passar do ultimo valor na sim 
   constant conteudo_rom : mem := (
      -- Crivo de Eratostenes até 100:

      -- init ram de 2 a 100
      0  => B"0011_001_001_000000010",  -- ld r1, 2       r1 = 2
      1  => B"0011_001_010_001100100",  -- ld r2, 100     r2 = 100
      2  => B"0101_001_001_000000_001", -- sw r1, r1      armazena na RAM
      3  => B"0110_000_001_000000000",  -- inc r1         r1++
      4  => B"0010_011_001_010_000000", -- cmp r1, r2     while r1 <= 100
      5  => B"0100_000_111111111101",   -- ble -3         pula (loop) enquanto r1 <= 100

      -- encontrar o prox primo
      6  => B"0010_010_001_000_000000", -- mv r1, r0      r1 = r0 = 0
      7  => B"0011_001_010_000000010",  -- ld r2, 2       r2 = 2
      8  => B"0101_000_011_000000_010", -- lw r3, r2      carrega o possivel primo da RAM
      9  => B"0010_011_011_000_000000", -- cmp r3, r0     verifica se r3==0 (ja marcado como nao primo)
      10 => B"0100_000_000000000011",   -- ble 3          pula se r3==0

      -- rm tds os multiplos dele
      11 => B"0010_010_100_010_000000", -- mv r4, r2      r4 = 2
      12 => B"0011_001_011_001100100",  -- ld r3, 100     r3 = 100
      13 => B"0010_000_100_010_000000", -- add r4, r2     vai para o próximo multiplo de r2
      14 => B"0010_011_011_100_000000", -- cmp r3, r4     while r4 < 100
      15 => B"0100_001_000000000011",   -- blt 3          pula se r4 > 100 (acabou a verificacao dos multiplos dele) => nao marca
   
      16 => B"0101_001_000_000000_100", -- sw r0, r4      marca r4 como nao primo
      17 => B"0001_000_000000001101",   -- jump 13        vai buscar o prox possivel primo
      18 => B"0110_000_010_000000000",  -- inc r2         vai para o prox num
      19 => B"0011_010_010_000001010",  -- cmpi r2, 10    verifica todos os nums ate 10 = floor(sqrt(100))
      20 => B"0100_000_111111110100",   -- ble -12        pula (loop) enquanto r2 < 10


      -- itera carregando os primos p r4
      21 => B"0011_001_001_000000010",  -- ld r1, 2       r1 = 2
      22 => B"0011_001_010_001100100",  -- ld r2, 100     r2 = 100
   
      23 => B"0101_000_011_000000_001", -- lw r3, r1      carrega em r3 o num q pd ser primo
      24 => B"0010_011_011_000_000000", -- cmp r3, r0     se o r3 != 0, eh primo e coloca ele em r4
      25 => B"0100_000_000000000010",   -- ble 2          pula se r3 == 0
   
      26 => B"0010_010_100_011_000000", -- mv r4, r3      mostra no r4 se r3 eh primo
      27 => B"0110_000_001_000000000",  -- inc r1         r1++
      28 => B"0010_011_001_010_000000", -- cmp r1, r2     while r1 <= 100
      29 => B"0100_000_111111111010",   -- ble -6         pula (loop) enquanto r1 <= 100

      others => (others=>'0') --casos omissos => (zero em todos os bits) 
   );
   
begin
   rom_out <= conteudo_rom(to_integer(endereco)); --sem clk pra ler
end architecture;