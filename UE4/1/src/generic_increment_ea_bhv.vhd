library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity generic_increment is
    generic(width: integer);
    port(clk, reset: in STD_ULOGIC;
            y: out STD_ULOGIC_VECTOR(width-1 downto 0));
end;

architecture proc of generic_increment is
    component cra is
        generic(width:integer);
        port(a, b: in STD_ULOGIC_VECTOR(width-1 downto 0);
        cin: in STD_ULOGIC;
        cout: out STD_ULOGIC;
        sum: out STD_ULOGIC_VECTOR(width-1 downto 0));
    end component;
    signal incr: std_ulogic_vector(width-1 downto 0):=(1 => '1',others => '0');
    signal add_base: std_ulogic_vector(width-1 downto 0);
    signal c_out: std_ulogic;
    signal res: std_ulogic_vector(width -1 downto 0);
    signal qq: STD_ULOGIC_VECTOR(width-1 downto 0):=(width -1 downto 0 => '0');

begin
    add_base <=qq;
    dA: cra generic map(width => width) port map(add_base,incr,'0',c_out,res);
    process(clk, reset)
    begin
        if clk'event and clk = '0' then
            if reset = '0' then
                qq <=res;
            end if;
            if c_out = '1' or reset ='1' then
                qq <=(width -1 downto 0 => '0');
            end if;
        end if;
    end process;
    y <=qq;

end;