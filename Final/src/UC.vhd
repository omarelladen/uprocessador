library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk, rst : in std_logic;
        instr : in unsigned(18 downto 0);
        z_flag_in , n_flag_in, v_flag_in : in std_logic;
        pc_wr, irwrite, regwrite, memtoreg, memwrite, wrdata_sel, readregb_sel: out std_logic;  -- melhor _nomes
        aluop, pcsource, regzero, alusrcb : out unsigned(1 downto 0);
        flag_wr_en : out std_logic
    );
end entity;


architecture a_UC of UC is
    signal state_s : unsigned(2 downto 0);
    signal opcode_s : unsigned(3 downto 0);    
    signal funct_s : unsigned(2 downto 0);
    signal flag_cond_s, pcwrcond_s, add_op, addi_op, sub_op, cmp_op, cmpi_op, jump_op, ble_op, blt_op, mv_op, ld_op, lw_op, sw_op, nop_op : std_logic;

begin
    process(clk)
    begin
        if rst='1' then
            state_s <= "000";
        elsif(rising_edge(clk)) then
            if state_s="100" or                        ----lw
              (state_s="001" and nop_op='1') or         --sw
              (state_s="011" and sw_op='1') or         --sw
              (state_s="010" and ld_op='1') or         --ld
              (state_s="011" and opcode_s="0010") or   --R menos cmp
              (state_s="011" and addi_op='1') or       --addi
              (state_s="010" and jump_op='1') or       --jump
              (state_s="010" and cmp_op='1') or        --cmp
              (state_s="010" and cmpi_op='1') or       --cmpi
              (state_s="010" and opcode_s="0100") then --ble, blt   --------------- igual se for 010 ou 011 -- pula pra inst anterior aa desejada, pq em seguida vai avancaar pc+1 ---- ver se isso n vai executar algo indesejado
                state_s <= "000";                                                    
            else
                state_s <= state_s + 1;
            end if;
        end if;
    end process;


    -- instr     
    opcode_s <= instr(18 downto 15);
    funct_s <= instr(14 downto 12);

    nop_op  <= '1' when instr="0000000000000000000" else '0';----------------------------- usar (n to usando)
    jump_op <= '1' when opcode_s="0001" and funct_s="000" else '0';
    add_op  <= '1' when opcode_s="0010" and funct_s="000" else '0';
    sub_op  <= '1' when opcode_s="0010" and funct_s="001" else '0';
    mv_op   <= '1' when opcode_s="0010" and funct_s="010" else '0';
    cmp_op  <= '1' when opcode_s="0010" and funct_s="011" else '0';
    addi_op <= '1' when opcode_s="0011" and funct_s="000" else '0';
    ld_op   <= '1' when opcode_s="0011" and funct_s="001" else '0';
    cmpi_op <= '1' when opcode_s="0011" and funct_s="010" else '0';
    ble_op  <= '1' when opcode_s="0100" and funct_s="000" else '0';
    blt_op  <= '1' when opcode_s="0100" and funct_s="001" else '0';
    lw_op   <= '1' when opcode_s="0101" and funct_s="000" else '0';
    sw_op   <= '1' when opcode_s="0101" and funct_s="001" else '0';


    pc_wr <= '1' when state_s="000" else --avanco normal
             '1' when (state_s="010" and jump_op ='1') else -- jump
             --or
             '1' when (flag_cond_s='1' and pcwrcond_s='1') else
             '0';
           
    irwrite <= '1' when state_s = "000" else
               '0';
    -- no estado 01 n mexe em nenhum controle por enquanto, soh pra fluir os dados    
    
    -- op da ula
    aluop <= "01" when sub_op ='1' else --sub
             "01" when cmp_op ='1' else --cmp
             "01" when cmpi_op='1' else --cmpi
             "00" when add_op ='1' else --add
             "00" when addi_op='1' else --addi
             "00" when mv_op  ='1' else --mv
             "00" when opcode_s="0101" else --lw,sw
             "00"; -- explicito

    -- sel do mux para write data do reg file
    memtoreg <= '1' when ld_op='1' else                    -- ld
                '0' when opcode_s="0010" else              -- R            
                '0' when (addi_op='1' or cmpi_op='1') else -- addi,cmpi
                '0'; -- explicito

    regzero <= "00" when mv_op ='1' else      --mv
               "01" when opcode_s="0101" else --lw, sw
               "10";
 
    alusrcb <= "00" when addi_op='1' else --addi
               "00" when cmpi_op='1' else --cmpi
               "01" when opcode_s="0101" else
               "10";
    ---- ?mudar inst pra reaproveitar 1o reg da instr pra fazer soma ou aumentar tamanho da entr do mux do reg a (e add aqui alusrca) - dps tmb colocar opcao da cte menor pra fazer imm

    flag_cond_s <= '1' when ble_op ='1' and (v_flag_in='1' or n_flag_in /= z_flag_in) else --ble
                   '1' when blt_op ='1' and (n_flag_in /= v_flag_in) else                  --blt
                   '0';

    pcwrcond_s <= '1' when (state_s="010" and opcode_s="0100") else --branch
                  '0';

    regwrite <= '1' when add_op ='1' and state_s="011" else --add
                '1' when sub_op ='1' and state_s="011" else --sub
                '1' when addi_op='1' and state_s="011" else --addi
                '1' when ld_op  ='1' and state_s="010" else --ld
                '1' when mv_op  ='1' and state_s="011" else --mv
                '1' when lw_op  ='1' and state_s="100" else --lw
                '0';

    pcsource <= "10" when (opcode_s="0100" and state_s ="010") else -- branch ------------------------ se n atender cond da branch o pc vai deixar de avancar??
                "01" when (jump_op='1'     and state_s/="000") else -- jump
                "00"; -- contagem normal

    --atualizacao de flag pra branch apenas em op de ula
    flag_wr_en <= '1' when add_op ='1' else --add
                  '1' when addi_op='1' else --addi
                  '1' when sub_op ='1' else --sub
                  '1' when cmp_op ='1' else --cmp 
                  '1' when cmpi_op='1' else --cmpi
                  '1' when mv_op  ='1' else --mv
                  '0';

    memwrite <= '1' when sw_op='1' and state_s="011" else --sw
                '0';
            
    -- MUX
    wrdata_sel <= '1' when lw_op='1' else --sw
                  '0';   

    -- MUX
    readregb_sel <= '1' when opcode_s="0101" else
                    '0';
 
end architecture;