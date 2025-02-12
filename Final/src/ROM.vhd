library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
       endereco   : in unsigned(11 downto 0);
       rom_out    : out unsigned(18 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 128) of unsigned(18 downto 0); -- precisa tamanho da mem para nao passar do ultimo valor na sim 
   constant conteudo_rom : mem := (
      -- Crivo de Eratóstenes até 36:

      -- INICIALIZA NA MEMÓRIA 2 ATÉ 10
      0  => B"0011_001_001_000000010",  -- ld r1, 2       re1 = 2
      1  => B"0011_001_010_000100100",  -- ld r2, 36      r2 = 36
      2  => B"0101_001_001_000000_001", -- sw r1, r1      armazena o indice na RAM
      3  => B"0011_000_001_000000001",  -- addi r1, 1     r1++
      4  => B"0010_011_001_010_000000", -- cmp r1, r2     while r1 <= 36
      5  => B"0100_000_111111111101",   -- ble -3

      -- ENCONTRAR O PRÓXIMO PRIMO
      6  => B"0010_010_001_000_000000", -- mv r1, r0      r1 = r0 = 0
      7  => B"0011_001_010_000000010",  -- ld r2, 2       r2 = 2
      8  => B"0101_000_011_000000_010", -- lw r3, r2      carrega o possivel primo da RAM
      9  => B"0010_011_011_000_000000", -- cmp r3, r0     verifica se r3 eh zero (ja marcado como nao primo)
      10 => B"0100_000_000000000111",   -- ble 7

      -- REMOVER TODOS OS MÚLTIPLOS DELE
      11 => B"0010_010_100_010_000000", -- mv r4, r2      init
      12 => B"0011_001_011_000100100",  -- ld r3, 36
      13 => B"0010_000_100_010_000000", -- add r4, r2     vai para o próximo multiplo de r2
      14 => B"0010_011_011_100_000000", -- cmp r3, r4     enquanto r4 < 36
      15 => B"0100_001_000000000011",   -- blt 3
   
      16 => B"0101_001_000_000000_100", -- sw r0, r4      marca r4 como nao primo
      17 => B"0001_000_000000001101",   -- jump 13
      18 => B"0011_000_010_000000001",  -- addi r2, 1     vai para o prox num
      19 => B"0011_010_000000000110",   -- cmpi r2, 6     verifica todos os nums ate 6 = floor(sqrt(36))
      20 => B"0100_000_111111110100",   -- ble -12

      -- MARCA O FIM DO CRIVO
      21 => B"0011_001_001_111111111",  -- ld r1, FFFF
      22 => B"0010_010_001_000_000000", -- mv r1, r0
      23 => B"0010_010_010_000_000000", -- mv r2, r0
      24 => B"0010_010_011_000_000000", -- mv r3, r0
      25 => B"0010_010_100_000_000000", -- mv r4, r0

      -- ITERA PELOS PRIMOS MOSTRANDO ELES EM R4
      26 => B"0011_001_001_000000010",  -- ld r1, 2
      27 => B"0011_001_010_000100100",  -- ld r2, 36
   
      28 => B"0101_000_011_000000_001", -- lw r3, r1
      29 => B"0010_011_011_000_000000", -- cmp r3, r0     se o valor é dif de 0, eh primo e coloca ele em r4
      30 => B"0100_000_000000000010",   -- ble 2
   
      31 => B"0010_010_100_011_000000", -- mv r4, r3
      32 => B"0011_000_001_000000001",  -- addi r1, 1
      33 => B"0010_011_001_010_000000", -- cmp r1, r2
      34 => B"0100_000_111111111010",   -- ble -6

      35 => B"0011_001_100_000000000",   --ld r4,0         sinaliza no r4 que acabou de printar os primos encontrados

      others => (others=>'0') --casos omissos => (zero em todos os bits) 
   );
   
begin
   rom_out <= conteudo_rom(to_integer(endereco)); --sem clk pra ler
end architecture;