library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        clk, rst, wr_en : in std_logic;
        op_sel : in unsigned(1 downto 0);
        data_wr : unsigned(15 downto 0);
        reg_wr, reg_r0, reg_r1: in unsigned(2 downto 0);

        z, n, v : out std_logic;
        ula_result : out unsigned(15 downto 0)
    );
end entity;

architecture a_main of main is

    component registerFile is
        port(
            clk, rst, wr_en : in std_logic;
            data_wr : unsigned(15 downto 0);
            reg_wr, reg_r0, reg_r1: in unsigned(2 downto 0);
            data_r0, data_r1 : out unsigned(15 downto 0)
        );
    end component;

    component ULA is
        port(
            op_a,op_b  :  in unsigned(15 downto 0);
            op_sel :  in unsigned(1 downto 0);
            ula_out : out unsigned(15 downto 0);
            z, n, v : out std_logic
        );
    end component;

signal reg0_s, reg1_s : unsigned(15 downto 0);

begin
    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r0 => reg_r0,
        reg_r1 => reg_r1,

        data_r0 => reg0_s,
        data_r1 => reg1_s
    );


    ula_component : ULA port map(
        op_a => reg0_s,
        op_b => reg1_s,
        op_sel => op_sel,
        ula_out => ula_result,
        z => z,
        n => n,
        v => v
    );

    --ula_result <= ula_out_s;
end architecture;