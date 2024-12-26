library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port (
        clk, rst : in std_logic;
        instr : in unsigned(18 downto 0);
        z_flag_in , n_flag_in, v_flag_in : in std_logic;
        pc_wr, irwrite, regwrite, memtoreg, regzero, alusrcb: out std_logic;
        aluop : out unsigned(1 downto 0);
        state : out unsigned(1 downto 0);
        pcsource : out unsigned(1 downto 0)
    );
end entity;

architecture a_UC of UC is
    signal state_s : unsigned(1 downto 0); -- pro process
    --"vars" interm pra mlr org:
    signal opcode_s : unsigned(3 downto 0);    
    signal funct_s : unsigned(2 downto 0);     
    signal flag_cond_s, pcwrcond_s : std_logic;

begin
    process(clk)
    begin
        if rst='1' then 
            state_s <= "00";
        elsif(rising_edge(clk)) then ---limitar tamanho do jump
            if(state_s = "11" or (state_s="10" and opcode_s="0011") or (state_s="11" and opcode_s="0010")) or (state_s="10" and opcode_s="0001") then --dps mudar maximo n de estados (5 (000-100)) --reseta antes do max de estados dependendo da instr
                state_s <= "00";  --ld                                  --add                                 --jump
            else
                state_s <= state_s + 1;
            end if;
        end if;
    end process;

    state <= state_s;


    --OR vale 1 qnd é avanco normal ou jump (determinados aqui), ou em branch com o pcwrcond mais abaixo e flags
    pc_wr <= '1' when state_s="00" else --avanco normal
             '1' when (state_s="10" and opcode_s="0001") else -- jump
             --or
             '1' when (flag_cond_s='1' and pcwrcond_s='1') else
             '0';
             
    irwrite <= '1' when state_s = "00" else
               '0';
    -- no estado 01 n mexe em nenhum controle por enquanto, soh pra fluir os dados    
    
    -- instr       
    opcode_s <= instr(18 downto 15);
    funct_s <= instr(14 downto 12);

    


    -- op da ula
    aluop <= "00" when opcode_s="0010" and funct_s="000" else --add
             "01" when opcode_s="0010" and funct_s="001" else --sub
             "01" when opcode_s="0010" and funct_s="011" else --cmp  (faz sub)
             "01" when opcode_s="0011" and funct_s="010" else --cmpi (faz sub)
             "00" when opcode_s="0010" and funct_s="010" else --mv
             "00"; --quis deixar explicitas as operacoes acima

    -- sel do mux para write data do reg file
    memtoreg <= '0' when opcode_s="0010" else -- R
                '1' when opcode_s="0011" else --ld
                '0'; -- explicito

    regzero <= '0' when (opcode_s="0010" and funct_s="010") else --ld
               '1';
 
    alusrcb <= '1' when (opcode_s="0011" and (funct_s="000" or funct_s="010")) else ---- addi ou cmpi
               '0';
    


    

    --outra cond pra porta AND vem das flags
    flag_cond_s <= '1' when (opcode_s="0100") and (funct_s="000") and (v_flag_in='1' and n_flag_in /= z_flag_in) else --ble
                   '1' when (opcode_s="0100") and (funct_s="001") and (n_flag_in /= v_flag_in) else --blt
                   '0';

    pcwrcond_s <= '1' when (state_s="010" and opcode_s="0100") else
                  '0';

    regwrite <= '1' when opcode_s="0010" and state_s = "11" else --add
            '1' when opcode_s="0011" and state_s = "10" else --ld
            '0';-- dps nos load pd ter o write no 4o estado

    pcsource <= "10" when (opcode_s="0100" and state_s="10") else -- branch
                "01" when (opcode_s="0001" and state_s/="00") else -- jump
                "00"; -- contagem normal

end architecture;