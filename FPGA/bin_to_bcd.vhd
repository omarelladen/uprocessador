library ieee;  
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity bin_to_bcd is 
port ( 
  in_binary :  in std_logic_vector(15 downto 0); 
  digit_0   : out std_logic_vector( 3 downto 0); 
  digit_1   : out std_logic_vector( 3 downto 0); 
  digit_2   : out std_logic_vector( 3 downto 0)
); 
end entity; 


architecture a_bin_to_bcd of bin_to_bcd is 
begin 
process(in_binary) 
  variable s_digit_0 : unsigned( 3 downto 0); 
  variable s_digit_1 : unsigned( 3 downto 0); 
  variable s_digit_2 : unsigned( 3 downto 0); 
  
begin 
  s_digit_2 := "0000"; 
  s_digit_1 := "0000"; 
  s_digit_0 := "0000"; 

  for i in 15 downto 0 loop 
	 if (s_digit_2 >= 5) then s_digit_2 := s_digit_2 + 3; end if; 
	 if (s_digit_1 >= 5) then s_digit_1 := s_digit_1 + 3; end if; 
	 if (s_digit_0 >= 5) then s_digit_0 := s_digit_0 + 3; end if; 
	 s_digit_2 := s_digit_2 sll 1; s_digit_2(0) := s_digit_1(3); 
	 s_digit_1 := s_digit_1 sll 1; s_digit_1(0) := s_digit_0(3); 
	 s_digit_0 := s_digit_0 sll 1; s_digit_0(0) := in_binary(i); 
  end loop; 

  digit_0 <=  std_logic_vector(s_digit_0); 
  digit_1 <=  std_logic_vector(s_digit_1); 
  digit_2 <=  std_logic_vector(s_digit_2); 

end process; 

end architecture; 