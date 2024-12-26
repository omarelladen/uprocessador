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
        port( endereco : in unsigned(11 downto 0);
              rom_out     : out unsigned(18 downto 0) 
            );
    end component;

    component UC is
        port (
            clk, rst : in std_logic;
            instr : in unsigned(18 downto 0);
            pc_wr, jump_en, irwrite, regwrite, memtoreg, regzero: out std_logic;
            aluop : out unsigned(1 downto 0);
            state : out unsigned(1 downto 0)
        );
    end component;

    component reg12bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(11 downto 0);
    
            data_out : out unsigned(11 downto 0)
        );
    end component;

    component reg19bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(18 downto 0);
    
            data_out : out unsigned(18 downto 0)
        );
    end component;

    component registerFile is
        port(
            clk, rst, wr_en : in std_logic;
            data_wr : in unsigned(15 downto 0);
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


    component reg16bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

signal rom_out_s : unsigned(18 downto 0);
signal state_s : unsigned(1 downto 0);

signal pc_wr_s : std_logic;
signal jump_en_s : std_logic;
signal cont_s : unsigned(11 downto 0) := "000000000000";
signal pc_out_s : unsigned(11 downto 0);
signal ir_out_s : unsigned(18 downto 0) := "0000000000000000000";
signal irwrite_s : std_logic;
signal regwrite_s : std_logic;
signal z_s, n_s, v_s: std_logic;
signal data_r0_s, data_r1_s, reg_a_out_s, reg_b_out_s, ula_result_s, aluout_s: unsigned(15 downto 0);
signal aluop_s : unsigned(1 downto 0);
signal data_wr_s : unsigned(15 downto 0);
signal memtoreg_s : std_logic;
signal regzero_s: std_logic;
signal reg_r0_s : unsigned (2 downto 0);
begin
    rom_c : ROM port map( -- n pode rom = ROM
        endereco => pc_out_s,
        rom_out => rom_out_s --signal
    ); 

    uc_c : UC port map(
        clk => clk,
        rst => rst,
        instr => ir_out_s, -------tava rom_out_s (errado)
        state => state_s, --signal
        pc_wr => pc_wr_s,
        jump_en => jump_en_s,
        irwrite => irwrite_s,
        regwrite => regwrite_s,
        aluop => aluop_s,
        memtoreg => memtoreg_s,
        regzero => regzero_s
    );

    pc_c : reg12bits port map( ------n ta escrevendo apos o jump, e limitar o tamanho do jump, e tirar nop do end 0 (dara ruim? precisara de um rst add?)
        clk => clk,
        rst => rst,
        wr_en => pc_wr_s, -- vir da UC
        data_in => cont_s,
        data_out => pc_out_s --signal
    );

    instr_reg : reg19bits port map(
        clk => clk,
        rst => rst,
        wr_en => irwrite_s, -- vir da UC
        data_in => rom_out_s,
        data_out => ir_out_s --signal
    );

    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wr_en => regwrite_s,
        data_wr => data_wr_s,-- MUX: vem do ULAOut ou direto da instr (ld)
        reg_wr => ir_out_s(11 downto 9), -- (=) com 2 operandos
        reg_r0 => reg_r0_s, -- (=) e eh o msm pros R-type e ld, pra mv valera zero
        reg_r1 => ir_out_s(8 downto 6),
        data_r0 => data_r0_s,-- vai pro o reg a
        data_r1 => data_r1_s -- vai pro o reg b
    );

    ula_component : ULA port map(
        op_a => reg_a_out_s, -- vem do reg a
        op_b => reg_b_out_s, -- vem do reg b
        op_sel => aluop_s,
        ula_out => ula_result_s, --- vai pro reg ULAOut
        z => z_s, --
        n => n_s, --por enquanto n tem brench
        v => v_s  --
    );

    reg_a : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => data_r0_s,
        data_out => reg_a_out_s --signal
    );
    reg_b : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => data_r1_s,
        data_out => reg_b_out_s --signal
    );
    aluout : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => ula_result_s,
        data_out => aluout_s --signal
    );

    --entrada do pc (end)(apesar de se chamar jump_EN, é basicamente um mux)
    cont_s <= (pc_out_s + 1) when jump_en_s = '0' else
              (ir_out_s(11 downto 0)); -------tava rom_out_s (errado)

    data_wr_s <= aluout_s when memtoreg_s='0' else -- res da ula no reg ulaout
                "0000000" & (ir_out_s(8 downto 0)) when memtoreg_s='1' and ir_out_s(8)='0' else -- cte da instr ld com 0 estendido
                "1111111" & (ir_out_s(8 downto 0)) when memtoreg_s='1' and ir_out_s(8)='1' else -- cte da instr ld com 1 estendido
                "0000000000000000";
                
    reg_r0_s <= "000" when regzero_s='0' else
                ir_out_s(11 downto 9);
end architecture;