library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
    port(
        clk, rst, wr_en : in std_logic;
        data_wr : in unsigned(15 downto 0);
        reg_wr, reg_r0, reg_r1: in unsigned(2 downto 0);
        data_r0, data_r1 : out unsigned(15 downto 0)
    );
end entity;

architecture a_registerFile of registerFile is

component reg16bits is
    port(
        clk, rst, wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end component;

signal wr_en0,wr_en1,wr_en2,wr_en3,wr_en4 : std_logic;
signal r0_data,r1_data,r2_data,r3_data,r4_data : unsigned(15 downto 0);

begin
    reg0 : reg16bits port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en0,
        data_in => data_wr,
        data_out => r0_data
    );
    reg1 : reg16bits port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en1,
        data_in => data_wr,
        data_out => r1_data
    );
    reg2 : reg16bits port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en2,
        data_in => data_wr,
        data_out => r2_data
    );
    reg3 : reg16bits port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en3,
        data_in => data_wr,
        data_out => r3_data
    );
    reg4 : reg16bits port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en4,
        data_in => data_wr,
        data_out => r4_data
    );
    

    data_r0 <= r0_data when reg_r0="000" else
               r1_data when reg_r0="001" else
               r2_data when reg_r0="010" else
               r3_data when reg_r0="011" else
               r4_data when reg_r0="100" else
               (others => '0');
    data_r1 <= r0_data when reg_r1="000" else
               r1_data when reg_r1="001" else
               r2_data when reg_r1="010" else
               r3_data when reg_r1="011" else
               r4_data when reg_r1="100" else
               (others => '0');

    wr_en0 <= '1' when wr_en='1' and reg_wr="000" else
              '0';
    wr_en1 <= '1' when wr_en='1' and reg_wr="001" else
              '0';
    wr_en2 <= '1' when wr_en='1' and reg_wr="010" else
              '0';
    wr_en3 <= '1' when wr_en='1' and reg_wr="011" else
              '0';
    wr_en4 <= '1' when wr_en='1' and reg_wr="100" else
              '0';

end architecture;