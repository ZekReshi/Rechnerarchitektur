library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity m4to2 is
  port(a,b,c,d: in STD_ULOGIC_VECTOR(31 downto 0);
       x, y:    out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture behav of m4to2 is
  component CSavA
    port(a, b, c: in STD_ULOGIC_VECTOR(31 downto 0);
         cout, s: out STD_ULOGIC_VECTOR(31 downto 0));
  end component;
  signal cout, s: STD_ULOGIC_VECTOR(31 downto 0);
begin
  csava_1: CSavA port map(a, b, c, cout, s);
  csava_2: CSavA port map(cout, s, d, x, y);
end;