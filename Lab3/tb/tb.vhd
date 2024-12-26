library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end;


architecture a_tb of tb is
    component main --is
        port(
			clk, rst, wr_en : in std_logic;
			op_sel : in unsigned(1 downto 0);
			data_wr : unsigned(15 downto 0);
			reg_wr, reg_r0, reg_r1: in unsigned(2 downto 0);
			z, n, v : out std_logic;
			ula_result : out unsigned(15 downto 0)
        );
    end component;

	signal data_wr, ula_result: unsigned (15 downto 0);
	signal reg_wr, reg_r0, reg_r1 : unsigned (2 downto 0);
	signal op_sel : unsigned (1 downto 0);
	signal z, n, v, clk, rst, wr_en : std_logic;

	constant period_time : time := 50 ns;
	signal finished : std_logic := '0';

begin
    uut: main port map( 
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        op_sel => op_sel,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r0 => reg_r0,
        reg_r1 => reg_r1,
        z => z,
        n => n,
        v => v,
        ula_result => ula_result
	);
    
    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;


    process
    begin
		wait for period_time * 2;

		-- escreve 0x91 no r1
        wr_en <= '1';
        reg_wr <= "001";
        data_wr <= "0000000010010001";
        wait for period_time;

		-- escreve 0x91 no r2
        reg_wr <= "010";
        data_wr <= "0000000010010001";
        wait for period_time;

		-- da a operacao de soma, sel entre r1 e r2
        wr_en <= '0';
        
        op_sel <= "00";
        reg_r0 <= "001";
        reg_r1 <= "010";

		-- sub entre r1 e r2
        wait for period_time;
        op_sel <= "01";

        wait for period_time;
        wait;

    end process;
end architecture;
