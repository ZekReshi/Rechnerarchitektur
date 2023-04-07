-- COPIED FROM 1_adder_template
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
-- END COPY


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux is
  port(a, b:      in      std_ulogic_vector(31 downto 0);
       s:         in      std_ulogic;
       r:         out     std_ulogic_vector(31 downto 0));
end;

architecture structural of mux is
begin
  r <= (a and (not (31 downto 0 => s))) or (b and (31 downto 0 => s));
end;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity nor32 is
  port(a:         in      std_ulogic_vector(31 downto 0);
       r:         out     std_ulogic);
end;

architecture structural of nor32 is
  signal nor16: std_ulogic_vector(15 downto 0);
  signal nor8: std_ulogic_vector(7 downto 0);
  signal nor4: std_ulogic_vector(3 downto 0);
  signal nor2: std_ulogic_vector(1 downto 0);
begin
  n16: for I in 0 to 15 generate
    nor16(I) <= a(2*I) or a(2*I+1);
  end generate;
  n8: for I in 0 to 7 generate
    nor8(I) <= nor16(2*I) or nor16(2*I+1);
  end generate;
  n4: for I in 0 to 3 generate
    nor4(I) <= nor8(2*I) or nor8(2*I+1);
  end generate;
  n2: for I in 0 to 1 generate
    nor2(I) <= nor4(2*I) or nor4(2*I+1);
  end generate;
  r <= nor2(0) nor nor2(1);
end;


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity alu is
  port(a, b:      in      std_ulogic_vector(31 downto 0);
       mode:      in      std_ulogic_vector(2 downto 0);
       result:    buffer  std_ulogic_vector(31 downto 0);
       zero, neg: buffer  std_ulogic);
end;

architecture structural of alu is
  component cla_gen
    generic(width:integer);
      port(a, b:  in      std_ulogic_vector(width-1 downto 0);
           cin:     in      std_ulogic;
           sum:       out     std_ulogic_vector(width downto 0));
  end component;
  component mux
    port(a, b:    in      std_ulogic_vector(31 downto 0);
         s:       in      std_ulogic;
         r:       out     std_ulogic_vector(31 downto 0));
  end component;
  component nor32
    port(a:       in      std_ulogic_vector(31 downto 0);
         r:       out     std_ulogic);
  end component;
  signal b_xored, and_result, or_result, adder_result, logic_result, adder_logic_result, expanded_msb, final_result: std_ulogic_vector(31 downto 0);
  signal adder_result_untruncated: std_ulogic_vector(32 downto 0);
  signal logic_select, adder_logic_select, msb, final_select: std_ulogic;
begin
  b_xored <= (b xor (31 downto 0 => mode(0)));

  add: cla_gen generic map(width => 32) port map(a, b_xored, mode(0), adder_result_untruncated);
  adder_result <= adder_result_untruncated(31 downto 0);
  and_result <= a and b_xored;
  or_result <= a or b_xored;

  logic_select <= mode(1);
  mux_logic: mux port map(and_result, or_result, logic_select, logic_result);

  adder_logic_select <= mode(1) nor mode(2);
  mux_adder_logic: mux port map(logic_result, adder_result, adder_logic_select, adder_logic_result);

  msb <= adder_logic_result(31);
  expanded_msb <= (0 => msb, others => '0');

  final_select <= mode(1) and mode(2);
  mux_final: mux port map(adder_logic_result, expanded_msb, final_select, final_result);

  result <= final_result;
  neg <= msb;
  n32: nor32 port map(result, zero);
end;
