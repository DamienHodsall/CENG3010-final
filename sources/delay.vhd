library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity delay is
    port (
        clk : in std_logic;
        ms : in integer;
        sigin : in std_logic;
        sigout : out std_logic
     );
end delay;

architecture main of delay is

    component bclk is
        port (
            clkin : in std_logic;
            period : in integer;
            clkout : out std_logic
         );
    end component;

    signal buffint : std_logic_vector(0 to 1000);
    signal clk1ms : std_logic := '0';

begin

    C : bclk port map (clk, 100000, clk1ms);

    process(clk1ms)
    begin
        if rising_edge(clk1ms) then
            buffint <= sigin & buffint(0 to 999);
            sigout <= buffint(ms);
        end if;
    end process;

end main;
