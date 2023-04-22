library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity mult is 
  port(a:   in STD_ULOGIC_VECTOR(15 downto 0);
       b:   in STD_ULOGIC_VECTOR(15 downto 0);
       y:   out STD_ULOGIC_VECTOR(31 downto 0));
end;

architecture behav of mult is 
  component m4to2
    port(a,b,c,d: in STD_ULOGIC_VECTOR(31 downto 0);
         x, y:    out STD_ULOGIC_VECTOR(31 downto 0));
  end component;
  component ADDER
    port(a,b: in STD_ULOGIC_VECTOR(31 downto 0);
         s: out STD_ULOGIC_VECTOR(31 downto 0));
  end component;
  signal pp_0, pp_1, pp_2, pp_3, pp_4, pp_5, pp_6, pp_7, pp_8, pp_9, pp_10, pp_11, pp_12, pp_13, pp_14, pp_15, 
    cout_1, s_1, cout_2, s_2, cout_3, s_3, cout_4, s_4, cout_12, s_12, cout_34, s_34, cout_1234, s_1234: STD_ULOGIC_VECTOR(31 downto 0);
begin
    pp_0 <= (15 downto 0 => (b and (15 downto 0 => a(0))), others => '0');
    pp_1 <= (16 downto 1 => (b and (15 downto 0 => a(1))), others => '0');
    pp_2 <= (17 downto 2 => (b and (15 downto 0 => a(2))), others => '0');
    pp_3 <= (18 downto 3 => (b and (15 downto 0 => a(3))), others => '0');
    pp_4 <= (19 downto 4 => (b and (15 downto 0 => a(4))), others => '0');
    pp_5 <= (20 downto 5 => (b and (15 downto 0 => a(5))), others => '0');
    pp_6 <= (21 downto 6 => (b and (15 downto 0 => a(6))), others => '0');
    pp_7 <= (22 downto 7 => (b and (15 downto 0 => a(7))), others => '0');
    pp_8 <= (23 downto 8 => (b and (15 downto 0 => a(8))), others => '0');
    pp_9 <= (24 downto 9 => (b and (15 downto 0 => a(9))), others => '0');
    pp_10 <= (25 downto 10 => (b and (15 downto 0 => a(10))), others => '0');
    pp_11 <= (26 downto 11 => (b and (15 downto 0 => a(11))), others => '0');
    pp_12 <= (27 downto 12 => (b and (15 downto 0 => a(12))), others => '0');
    pp_13 <= (28 downto 13 => (b and (15 downto 0 => a(13))), others => '0');
    pp_14 <= (29 downto 14 => (b and (15 downto 0 => a(14))), others => '0');
    pp_15 <= (30 downto 15 => (b and (15 downto 0 => a(15))), others => '0');

    m4to2_1: m4to2 port map(pp_0, pp_1, pp_2, pp_3, cout_1, s_1);
    m4to2_2: m4to2 port map(pp_4, pp_5, pp_6, pp_7, cout_2, s_2);
    m4to2_3: m4to2 port map(pp_8, pp_9, pp_10, pp_11, cout_3, s_3);
    m4to2_4: m4to2 port map(pp_12, pp_13, pp_14, pp_15, cout_4, s_4);

    m4to2_12: m4to2 port map(cout_1, s_1, cout_2, s_2, cout_12, s_12);
    m4to2_34: m4to2 port map(cout_3, s_3, cout_4, s_4, cout_34, s_34);
    
    m4to2_1234: m4to2 port map(cout_12, s_12, cout_34, s_34, cout_1234, s_1234);

    add: ADDER port map(cout_1234, s_1234, y);
end;