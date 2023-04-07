library IEEE; use IEEE.STD_LOGIC_1164.all;
entity adder is
  port(a,b: in  std_ulogic_vector(7 downto 0);
       c:   in  std_ulogic;
       s:   out std_ulogic_vector(8 downto 0));
end;
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity cla_gen is
  generic(width:integer);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
       cin:  in  std_ulogic;
       sum:  out std_ulogic_vector(width downto 0));

end;
library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux_gen is
  generic(width: integer);
  port(a, b: in  std_ulogic_vector(width-1 downto 0);
  sel:  in  std_ulogic;
  selected:  out std_ulogic_vector(width-1 downto 0));
end;

architecture behavioral of mux_gen is
  begin
    process (a,b,sel)
    begin
      if(sel ='0') then
        selected <=a;
      else
        selected <=b;
      end if;
      end process;
  end behavioral;

architecture structural of cla_gen is
  component cla_gen
    generic(width:integer);
      port(a, b: in  std_ulogic_vector(width-1 downto 0);
        cin:  in  std_ulogic;
        sum:  out std_ulogic_vector(width downto 0));
  end component;
  component mux_gen
    generic(width: integer);
    port(a, b: in  std_ulogic_vector(width-1 downto 0);
    sel:  in  std_ulogic;
    selected:  out std_ulogic_vector(width-1 downto 0));
  end component;
  constant old_width:integer := width;
  signal sc: std_ulogic_vector(old_width/2 downto 0);
  signal snc: std_ulogic_vector(old_width/2 downto 0);
  signal sl: std_ulogic_vector(old_width/2 downto 0);
begin
    o1: if old_width > 1 generate 
      cla_add_low:cla_gen generic map(width => old_width/2) port map(
        a(old_width/2-1 downto 0),b(old_width/2-1 downto 0),cin,sl);
      cla_add_high_carry: cla_gen generic map(width => old_width/2) port map(
        a(old_width-1 downto old_width/2),b(old_width-1 downto old_width/2)
        ,'1',sc);
      cla_add_high_no_carry: cla_gen generic map(width => old_width/2) port map(
        a(old_width-1 downto old_width/2),b(old_width-1 downto old_width/2)
        ,'0',snc);
        high_mux: mux_gen generic map(width => old_width/2+1) port map(    
        snc,
        sc,
        sl(old_width/2),
        sum(old_width downto old_width/2));
        sum(old_width/2-1 downto 0) <=sl(old_width/2-1 downto 0);
      else generate
        sum(0) <= a(0) xor b(0) xor cin;
        sum(1) <= (a(0) and b(0)) or (b(0) and cin) or (a(0) and cin);
    end generate;
    
  end;
  
architecture structural of adder is
  component cla_gen
    generic(width:integer);
      port(a, b: in  std_ulogic_vector(width-1 downto 0);
        cin:  in  std_ulogic;
        sum:  out std_ulogic_vector(width downto 0));
  end component;
begin
  cla_add: cla_gen generic map(width => 8) port map (a,b,c,s);
end;




