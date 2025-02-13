library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end;


architecture a_tb of tb is
    component main
        port(
            rst : in std_logic; 
            clk      : in std_logic
    );
    end component;

	signal rst, clk : std_logic;
    signal dado : unsigned(18 downto 0);
	constant period_time : time := 50 ns;
	signal finished : std_logic := '0';

begin
    uut: main port map( 
        rst => rst,
        clk => clk
	);
    

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2;      -- espera 2 clks, pra garantir
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 300 us;             -- TEMPO TOTAL DA SIMULACAO! => precisa mudar tamanho da mem para nao passar do ultimo valor na sim
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                            -- gera clk até que sim_time_proc termine
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
		wait for period_time * 2;    --espera 100ns

        wait for period_time;        -- sinais mudam aqui a cada 50ns (na hora da borda de descida do clk)

        wait;

    end process;
end architecture;
