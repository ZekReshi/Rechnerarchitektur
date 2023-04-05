library IEEE; use IEEE.STD_LOGIC_1164.all;
entity adder is
  port(a,b: in  std_ulogic_vector(7 downto 0);
       c:   in  std_ulogic;
       s:   out std_ulogic_vector(8 downto 0));
end;
