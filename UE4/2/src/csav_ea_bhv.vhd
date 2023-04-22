library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity CSavA is
  port(a, b, c: in STD_ULOGIC_VECTOR(31 downto 0);
       cout, s: out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture behav of CSavA is
  component FA 
    port(a,b,cin: in STD_ULOGIC;
         cout,s: out STD_ULOGIC);
  end component;
  signal void: STD_ULOGIC;
begin
  cout(0) <= '0';
  ffas: for i in 0 to 30 generate
    fa_i: FA port map(a(i), b(i), c(i), cout(i+1), s(i));
  end generate;
  fa_n: FA port map(a(31), b(31), c(31), void, s(31));
end; 