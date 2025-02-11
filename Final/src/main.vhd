-- Instruções OBRIGATÓRIAS a serem usadas na sua validação:
-- {
--  'Acumulador ou não': 'ULA com instruções ortogonais',            OK? - op possiveis p qqr um dos reg
--  'Largura da ROM / instrução em bits': [19],                      OK
--  'Número de registradores no banco': [5],                         OK
--  'ADD ops': 'ADD com dois operandos apenas',                      OK
--  'Carga de constantes': 'Carrega diretamente com LD sem somar',   OK
--  'SUB ops': 'Subtração com dois operandos apenas',                OK
--  'ADD ctes': 'Há instrução ADDI que soma com constante',          OK
--  'SUB ctes': 'Subtração apenas entre registradores',              OK
--  'Subtração': 'Subtração com SUB sem borrow',                     OK? - com um bit adicional (q eh a Cf, Carry Flag) q vai ser sub junto: SUB R1,R2: R1<-R1−R2−Cf, p fazer op com mais bits doq um reg tem disponivel, cascateando subs
--  'Comparações': 'Comparação com CMPR ou CMPI',                    OK
--  'Saltos condicionais': ['BLE', 'BLT'],                           OK
--  'Saltos': 'Incondicional é absoluto e condicional é relativo',   tem problema o -1 ???????????????????????????????????????
--  'Validação -- final do loop': 'Contador com INC',                !?
--  'Validação -- complicações': 'A constante 1843 é número primo?'  !?
-- }

-- tratar overflow? ou so pra branch msm ???????????????????????????????????????
-- manter 4 op de ULA ???????????????????????????????????????
-- mudar pc pra 16b ???????????????????????????????????????-- ver tamanho da ram
-- ver tamanho da ram
-- usar nop de algm forma ???????????????????????????????????????
-- mudar nome de signals da UC e main
-- colocar prog de validacao na rom
-- deixar cod elegante
--  ???????????????????????????????????????
--  ???????????????????????????????????????
--  ???????????????????????????????????????


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(
        rst : in std_logic;
        clk : in std_logic
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
        port (
             clk, rst : in std_logic;
             instr : in unsigned(18 downto 0);
             z_flag_in , n_flag_in, v_flag_in : in std_logic;
             pc_wr, irwrite, regwrite, memtoreg, memwrite, wrdata_sel, readregb_sel: out std_logic;
             aluop, pcsource, regzero, alusrcb : out unsigned(1 downto 0);
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
            reg_wr, reg_r0, reg_r1: in unsigned(2 downto 0);
            data_r0, data_r1 : out unsigned(15 downto 0)
        );
    end component;
    component ULA is
        port(
            op_a,op_b : in unsigned(15 downto 0);
            op_sel : in unsigned(1 downto 0);
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
    component reg1bit is
        port(
            clk, rst, wr_en : in std_logic;
            data_in : in std_logic;
            data_out : out std_logic
        );
    end component;

signal rom_out_s, ir_out_s : unsigned(18 downto 0);
signal data_r0_s, data_r1_s, reg_a_out_s, reg_b_out_s, ula_result_s, aluout_s, data_wr_s, ula_op_b_selected_s, ram_out_s, wr_data_s: unsigned(15 downto 0);
signal pc_in_s, pc_out_s : unsigned(11 downto 0);
signal reg_r0_s, reg_r1_s : unsigned (2 downto 0);
signal aluop_s, pcsource_s, regzero_s, alusrcb_s : unsigned(1 downto 0);
signal pc_wr_s, irwrite_s, regwrite_s, z_s, n_s, v_s, memtoreg_s, flag_wr_en_s, z_reg_s, n_reg_s, v_reg_s, memwrite_s, wrdata_sel_s, readregb_sel_s : std_logic;

begin
    rom_c : ROM port map( -- n pode rom = ROM
        endereco => pc_out_s,
        rom_out => rom_out_s
    ); 
    ram_c : RAM port map(
        clk => clk,
        endereco => aluout_s, ------ colocar mux pra ULA
        wr_en => memwrite_s,
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
        irwrite => irwrite_s,
        regwrite => regwrite_s,
        memwrite => memwrite_s,
        wrdata_sel => wrdata_sel_s,
        readregb_sel => readregb_sel_s,
        aluop => aluop_s,
        memtoreg => memtoreg_s,
        regzero => regzero_s,
        alusrcb => alusrcb_s,
        pcsource => pcsource_s,
        flag_wr_en => flag_wr_en_s
    );
    pc_c : reg12bits port map( --comentario antigo - ja foi corrigido??: ----n ta escrevendo apos o jump, e limitar o tamanho do jump, e tirar nop do end 0 (dara ruim? precisara de um rst add?)
        clk => clk,
        rst => rst,
        wr_en => pc_wr_s, -- vir da UC
        data_in => pc_in_s,
        data_out => pc_out_s
    );
    instr_reg : reg19bits port map(
        clk => clk,
        rst => rst,
        wr_en => irwrite_s, -- vir da UC
        data_in => rom_out_s,
        data_out => ir_out_s
    );
    regFile : registerFile port map(
        clk => clk,
        rst => rst,
        wr_en => regwrite_s,
        data_wr => wr_data_s,-- MUX: vem do ULAOut ou direto da instr (ld)
        reg_wr => ir_out_s(11 downto 9), -- (=) com 2 operandos
        reg_r0 => reg_r0_s, -- (=) e eh o msm pros R-type e ld, pra mv valera zero
        reg_r1 => reg_r1_s,
        data_r0 => data_r0_s,-- vai pro reg a
        data_r1 => data_r1_s -- vai pro reg b
    );
    ula_c : ULA port map(
        op_a => reg_a_out_s, -- vem do reg a
        op_b => ula_op_b_selected_s, -- vem do reg b ou imm
        op_sel => aluop_s,
        ula_out => ula_result_s, -- vai pro reg ULAOut
        z => z_s,
        n => n_s,
        v => v_s 
    );
    reg_a : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => data_r0_s,
        data_out => reg_a_out_s 
    );
    reg_b : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => data_r1_s,
        data_out => reg_b_out_s 
    );
    aluout : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => '1', -- sempre enabled
        data_in => ula_result_s,
        data_out => aluout_s 
    );
    reg_z : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => z_s,
        data_out => z_reg_s 
    );
    reg_n : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => n_s,
        data_out => n_reg_s 
    );
    reg_v : reg1bit port map(
        clk => clk,
        rst => rst,
        wr_en => flag_wr_en_s,
        data_in => v_s,
        data_out => v_reg_s 
    );


    ---------------   confirmar -1   e +1
    -- adicionei: aluout_s(11 downto 0). era isso msm q faltava? trocar pc logo pra 16b??????????????????????????????????????????? 
    pc_in_s <= (ir_out_s(11 downto 0) + pc_out_s-1) when pcsource_s="10" else -- branch
               (ir_out_s(11 downto 0))              when pcsource_s="01" else -- jump
               (pc_out_s+1);                     -- when pcsource_s="00"      -- cont normal

    data_wr_s <= aluout_s when memtoreg_s='0' else -- res da ula no reg ulaout
                "0000000" & (ir_out_s(8 downto 0)) when memtoreg_s='1' and ir_out_s(8)='0' else -- cte da instr ld com 0 estendido
                "1111111" & (ir_out_s(8 downto 0)) when memtoreg_s='1' and ir_out_s(8)='1' else -- cte da instr ld com 1 estendido
                "0000000000000000";
                
    reg_r0_s <= "000" when regzero_s="00" else                --mv
                ir_out_s(2 downto 0) when regzero_s="01" else --lw, sw --reg de end
                ir_out_s(11 downto 9);

    reg_r1_s <= ir_out_s(11 downto 9) when readregb_sel_s='1' else-- valor pra armazenar com o sw
                ir_out_s(8 downto 6); 

    ula_op_b_selected_s <= "1111111" & (ir_out_s(8 downto 0)) when alusrcb_s="00" and ir_out_s(8)='1' else --addi -- ext p imm
                           "0000000" & (ir_out_s(8 downto 0)) when alusrcb_s="00" and ir_out_s(8)='0' else
                           "1111111111" & (ir_out_s(8 downto 3)) when alusrcb_s="01" and ir_out_s(8)='1' else --lw, sw --offset
                           "0000000000" & (ir_out_s(8 downto 3)) when alusrcb_s="01" and ir_out_s(8)='0' else
                           reg_b_out_s;-- reg b   
    
    wr_data_s <= ram_out_s when wrdata_sel_s='1' else
                 data_wr_s;    
    
end architecture;