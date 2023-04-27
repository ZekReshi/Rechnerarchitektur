library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cra is
    generic(width: integer);
    port(a, b: in STD_ULOGIC_VECTOR(width-1 downto 0);
        cin: in STD_ULOGIC;
        cout: out STD_ULOGIC;
        sum: out STD_ULOGIC_VECTOR(width-1 downto 0));
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
architecture bhv of cra is
    component full_adder
      port(a, b,cin: in  std_ulogic;
        cout:  out  std_ulogic;
        res:  out std_ulogic);
    end component;
    component half_adder
    port(a, b: in  std_ulogic;
      cout:  out  std_ulogic;
      res:  out std_ulogic);
    end component;
  signal carries: std_ulogic_vector(width-1 downto 0);
begin
    ha_0: half_adder port map(a(0),b(0),carries(0),sum(0));
    lo: for I in 1 to width-1 generate
      fa_N: full_adder port map (a(I),b(I),carries(I-1),carries(I),sum(I));
      end generate;
    cO: cout <= carries(width-1);
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity half_adder is 
  port(a, b: in  std_ulogic;
      cout:  out  std_ulogic;
      res:  out std_ulogic);
end;
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder is 
  port(a, b,cin: in  std_ulogic;
      cout:  out  std_ulogic;
      res:  out std_ulogic);
      end;


architecture structural of half_adder is
begin
    cC:cout<= a and b;
    cR:res<= a xor b;
end;

architecture structural of full_adder is
  component half_adder
  port(a, b: in  std_ulogic;
    cout:  out  std_ulogic;
    res:  out std_ulogic);
  end component;
  signal ab_temp:std_ulogic;
  signal axb_temp: std_ulogic;
  signal bcin_temp: std_ulogic;
  begin
      cAB: half_adder port map(a,b,ab_temp,axb_temp);
      cBC: half_adder port map(axb_temp,cin,bcin_temp,res);
      cCO: cout <= ab_temp or bcin_temp;
  end;
  