library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity barrel is
  generic(width : integer := 8);
  port(n:     in  std_ulogic_vector(width-1 downto 0);
       shamt: in  std_ulogic_vector(2 downto 0);
       y:     out std_ulogic_vector(width-1 downto 0));
end;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity MUX2 is
  port(a, b, s: in  std_ulogic;
       y:       out std_ulogic);
end;

architecture structural of MUX2 is
begin
  y <= (a and (not s)) or (b and s);
end;

architecture structural of barrel is
    component MUX2 --Wiederholung der Komponente, damit wir sie nutzen können
        port(a, b, s: in std_ulogic;
            y: out std_ulogic);
    end component;

    -- Signal-Verbindungen für die 2-zu-1 Multiplexer
    signal h, j: std_ulogic_vector(width-1 downto 0);
begin
    mux00: MUX2 port map(n(0), '0',  shamt(0), h(0));
    gen_mux01_09: for i in 1 to width-1 generate
      mux01_09: MUX2 port map(n(i), n(i-1),  shamt(0), h(i)); -- Input vom Eingabevektor n, Output nach Vektor h
    end generate;

    mux10: MUX2 port map(h(0), '0',  shamt(1), j(0));
    mux11: MUX2 port map(h(1), '0',  shamt(1), j(1));
    gen_mux12_19: for i in 2 to width-1 generate
      mux12_19: MUX2 port map(h(i), h(i-2),  shamt(1), j(i)); -- Input vom Vektor h, Output nach Vekor j
    end generate;

    mux20: MUX2 port map(j(0), '0',  shamt(2), y(0));
    mux21: MUX2 port map(j(1), '0',  shamt(2), y(1));
    mux22: MUX2 port map(j(2), '0',  shamt(2), y(2));
    mux23: MUX2 port map(j(3), '0',  shamt(2), y(3));
    gen_mux24_27: for i in 4 to width-1 generate
      mux24_27: MUX2 port map(j(i), j(i-4),  shamt(2), y(i)); -- Input vom Vektor j, Output nach Ausgabevektor y
    end generate;
end structural;