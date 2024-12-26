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
        port( clk      : in std_logic;
              endereco : in unsigned(6 downto 0);
              dado     : out unsigned(18 downto 0) 
            );
    end component;

    component UC is
        port (
            clk : in std_logic;
            state : out std_logic
        );
    end component;

    component reg6bits is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
    
            data_out : out unsigned(6 downto 0)
        );
    end component;


signal dado_s : unsigned(18 downto 0);
signal state_s : std_logic;

signal wr_en_s : std_logic := '1';
signal cont_s : unsigned(6 downto 0) := "0000000";
signal data_out_s : unsigned(6 downto 0);

begin
    rom_c : ROM port map( -- n pode rom = ROM
        clk => clk,
        endereco => data_out_s,
        dado => dado_s --signal
    );

    uc_c : UC port map(
        clk => clk,
        state => state_s --signal
    );

    pc_c : reg6bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_s,
        data_in => cont_s,
        data_out => data_out_s --signal
    );

    cont_s <= (data_out_s + 1);
end architecture;