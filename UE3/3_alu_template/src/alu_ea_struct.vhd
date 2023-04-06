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
  component adder
    port(a, b:    in      std_ulogic_vector(31 downto 0);
         cin:     in      std_ulogic;
         s:       out     std_ulogic_vector(31 downto 0));
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
  signal logic_select, adder_logic_select, msb, final_select: std_ulogic;
begin
  b_xored <= (b xor (31 downto 0 => mode(0)));

  adder_result <= a;--add: adder port map(a, b_xored, mode(0), adder_result);
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
