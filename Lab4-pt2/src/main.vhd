library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(

        rst : in std_logic;
        clk      : in std_logic
        
    );
end entity;

architecture a_main of main is

    component ROM is
        port( clk, rd_en : in std_logic;
              endereco : in unsigned(11 downto 0);
              dado     : out unsigned(18 downto 0) 
            );
    end component;

    component UC is
        port (
            clk, rst : in std_logic;
            instr : in unsigned(18 downto 0);
            state, mem_rd, pc_wr, jump_en : out std_logic
        );
    end component;

    component reg12bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(11 downto 0);
    
            data_out : out unsigned(11 downto 0)
        );
    end component;


signal dado_s : unsigned(18 downto 0);
signal state_s : std_logic;

signal mem_rd_s : std_logic;
signal pc_wr_s : std_logic;
signal jump_en_s : std_logic;
signal cont_s : unsigned(11 downto 0) := "000000000000";
signal data_out_s : unsigned(11 downto 0);

begin
    rom_c : ROM port map( -- n pode rom = ROM
        clk => clk,
        rd_en => mem_rd_s,
        endereco => data_out_s,
        dado => dado_s --signal
    ); 

    uc_c : UC port map(
        clk => clk,
        rst => rst,
        instr => dado_s,
        state => state_s, --signal
        mem_rd => mem_rd_s,
        pc_wr => pc_wr_s,
        jump_en => jump_en_s
    );

    pc_c : reg12bits port map(
        clk => clk,
        rst => rst,
        wr_en => pc_wr_s, -- vir da UC
        data_in => cont_s,
        data_out => data_out_s --signal
    );

    cont_s <= (data_out_s + 1) when jump_en_s = '0' else
              (dado_s(11 downto 0));
end architecture;