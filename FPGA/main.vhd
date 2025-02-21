-- Instrucoes OBRIGATORIAS a serem usadas na sua validacao:
-- {
--  'Acumulador ou nao': 'ULA com instrucoes ortogonais',            - op possiveis p qqr um dos reg
--  'Largura da ROM / instrucao em bits': [19],                      
--  'Numero de registradores no banco': [5],                         
--  'ADD ops': 'ADD com dois operandos apenas',                      
--  'Carga de constantes': 'Carrega diretamente com LD sem somar',   
--  'SUB ops': 'Subtracao com dois operandos apenas',                
--  'ADD ctes': 'Ha instrucao ADDI que soma com constante',          
--  'SUB ctes': 'Subtracao apenas entre registradores',              
--  'Subtracao': 'Subtracao com SUB sem borrow',                     - com um bit adicional (q eh a Cf, Carry Flag) q vai ser sub junto: SUB R1,R2: R1<-R1−R2−Cf, p fazer op com mais bits doq um reg tem disponivel, cascateando subs
--  'Comparacoes': 'Comparacao com CMPR ou CMPI',                    
--  'Saltos condicionais': ['BLE', 'BLT'],                           
--  'Saltos': 'Incondicional eh absoluto e condicional eh relativo',
--  'Validacao -- final do loop': 'Contador com INC',               
--  'Validacao -- complicacoes': 'A constante 1843 eh numero primo?'
-- }


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        rst : in std_logic;
        clk : in std_logic;
		  r4_print_out : out unsigned(15 downto 0);
		  slow_clk : out std_logic
    );
end entity;


architecture a_main of main is
    component ROM is
        port(
            endereco : in unsigned(11 downto 0);
            rom_out : out unsigned(18 downto 0) 
        );
    end component;
    component RAM is
        port( 
            clk, wr_en : in std_logic;
            endereco : in unsigned(15 downto 0);
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0) 
        );
    end component;
    component UC is 
        port(
            clk, rst : in std_logic;
            instr : in unsigned(18 downto 0);
            z_flag_in , n_flag_in, v_flag_in : in std_logic;
            pc_wr, ir_wr, reg_wr, mem_to_reg_sel, mem_wr, wr_data_sel, rd_reg_b_sel: out std_logic;
            alu_op_sel, pc_src_sel, rd_reg_a_sel, alu_src_b_sel : out unsigned(1 downto 0);
            flag_wr_en : out std_logic
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
            reg_wr, rd_reg_0, rd_reg_1: in unsigned(2 downto 0);
            rd_data_0, rd_data_1, r4_out : out unsigned(15 downto 0)
        );
    end component;
    component ULA is
        port(
            op_a,op_b : in unsigned(15 downto 0);
            op_sel : in unsigned(1 downto 0);
            alu_out : out unsigned(15 downto 0);
            z_flag, n_flag, v_flag : out std_logic
        );
    end component;
    component reg16bits is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component reg1bit is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in std_logic;
            data_out : out std_logic
        );
    end component;

signal rom_out_s, ir_out_s : unsigned(18 downto 0);
signal rd_data_0_s, rd_data_1_s, reg_a_out_s, reg_b_out_s, alu_out_s, alu_out_reg_s, data_wr_s, alu_op_b_s, ram_out_s, wr_data_s: unsigned(15 downto 0);
signal pc_in_s, pc_out_s : unsigned(11 downto 0);
signal rd_reg_0_s, rd_reg_1_s : unsigned (2 downto 0);
signal alu_op_sel_s, pc_src_sel_s, rd_reg_a_sel_s, alu_src_b_sel_s : unsigned(1 downto 0);
signal pc_wr_s, ir_wr_s, reg_wr_s, z_flag_s, n_flag_s, v_flag_s, mem_to_reg_sel_s, flag_wr_en_s, z_reg_s, n_reg_s, v_reg_s, mem_wr_s, wr_data_sel_s, rd_reg_b_sel_s : std_logic;
signal r4_out_s : unsigned(15 downto 0);

begin
    rom_c : ROM port map(
        endereco => pc_out_s,
        rom_out => rom_out_s
    ); 
    ram_c : RAM port map(
        clk => clk,
        endereco => alu_out_reg_s,
        wr_en => mem_wr_s,
        data_in => reg_b_out_s,
        data_out => ram_out_s
    );
    uc_c : UC port map(
        clk => clk,
        rst => rst,
        instr => ir_out_s,
        z_flag_in => z_reg_s,
        n_flag_in => n_reg_s,
        v_flag_in => v_reg_s,
        pc_wr => pc_wr_s,
        ir_wr => ir_wr_s,
        reg_wr => reg_wr_s,
        mem_wr => mem_wr_s,
        wr_data_sel => wr_data_sel_s,
        rd_reg_b_sel => rd_reg_b_sel_s,
        alu_op_sel => alu_op_sel_s,
        mem_to_reg_sel => mem_to_reg_sel_s,
        rd_reg_a_sel => rd_reg_a_sel_s,
        alu_src_b_sel => alu_src_b_sel_s,
        pc_src_sel => pc_src_sel_s,
        flag_wr_en => flag_wr_en_s
    );
    pc_c : reg12bits port map(
        clk => clk,
        rst => rst,
        wr_en => pc_wr_s, 
        data_in => pc_in_s,
        data_out => pc_out_s
    );
    instr_reg : reg19bits port map(
        clk => clk,
        rst => rst,
        wr_en => ir_wr_s, 
        data_in => rom_out_s,
        data_out => ir_out_s
    );
    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wr_en => reg_wr_s,
        data_wr => wr_data_s,
        reg_wr => ir_out_s(11 downto 9),
        rd_reg_0 => rd_reg_0_s,
        rd_reg_1 => rd_reg_1_s,
        rd_data_0 => rd_data_0_s,
        rd_data_1 => rd_data_1_s,
		  r4_out => r4_out_s
    );
    alu_c : ULA port map(
        op_a => reg_a_out_s,
        op_b => alu_op_b_s,
        op_sel => alu_op_sel_s,
        alu_out => alu_out_s,
        z_flag => z_flag_s,
        n_flag => n_flag_s,
        v_flag => v_flag_s 
    );
    reg_a : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_in => rd_data_0_s,
        data_out => reg_a_out_s 
    );
    reg_b : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_in => rd_data_1_s,
        data_out => reg_b_out_s 
    );
    alu_out_reg : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        data_in => alu_out_s,
        data_out => alu_out_reg_s 
    );
    reg_z : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => z_flag_s,
        data_out => z_reg_s 
    );
    reg_n : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => n_flag_s,
        data_out => n_reg_s 
    );
    reg_v : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => v_flag_s,
        data_out => v_reg_s 
    );


    -- MUXs:

    pc_in_s <= (ir_out_s(11 downto 0) + pc_out_s-1) when pc_src_sel_s="10" else -- branch
               (ir_out_s(11 downto 0))              when pc_src_sel_s="01" else -- jump
               (pc_out_s+1);                                                    -- cont normal

    data_wr_s <= alu_out_reg_s when mem_to_reg_sel_s='0' else                                          -- res da ula no reg ulaout
                 "0000000" & (ir_out_s(8 downto 0)) when mem_to_reg_sel_s='1' and ir_out_s(8)='0' else -- cte da instr ld
                 "1111111" & (ir_out_s(8 downto 0)) when mem_to_reg_sel_s='1' and ir_out_s(8)='1' else ---
                 "0000000000000000";
                
    rd_reg_0_s <= "000" when rd_reg_a_sel_s="00" else                --mv
                  ir_out_s(2 downto 0) when rd_reg_a_sel_s="01" else --lw,sw -end base da RAM
                  ir_out_s(11 downto 9);

    rd_reg_1_s <= ir_out_s(11 downto 9) when rd_reg_b_sel_s='1' else --lw,sw -end do reg q sera escrito
                    ir_out_s(8 downto 6); 

    alu_op_b_s <= "1111111"    & (ir_out_s(8 downto 0)) when alu_src_b_sel_s="00" and ir_out_s(8)='1' else --addi -ext p imm
                  "0000000"    & (ir_out_s(8 downto 0)) when alu_src_b_sel_s="00" and ir_out_s(8)='0' else ---
                  "1111111111" & (ir_out_s(8 downto 3)) when alu_src_b_sel_s="01" and ir_out_s(8)='1' else --lw, sw -offset
                  "0000000000" & (ir_out_s(8 downto 3)) when alu_src_b_sel_s="01" and ir_out_s(8)='0' else ---
                  "0000000000000001"                    when alu_src_b_sel_s="10" else                     --inc 
                  reg_b_out_s;
    
    wr_data_s <= ram_out_s when wr_data_sel_s='1' else
                 data_wr_s;   
				
	 -- manda diminuir a freq do clk qnd chega a hora de mostrar os primos
	 slow_clk <= '1' when ir_out_s="0110000001000000000" else
				    '0';
	 
	 -- r4 contera os primos ao final
	 r4_print_out <= r4_out_s;
    
end architecture;