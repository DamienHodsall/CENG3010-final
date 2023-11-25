library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bclk is
    port (
        clkin: in std_logic;
        period: in integer;
        clkout: out std_logic
    );
end entity;

architecture main of bclk is

    signal count: integer := 0;
    signal clkint: std_logic := '0';

begin

    process(clkin)
    begin
        count <= count + 1;
        if rising_edge(clkin) then
            if count >= period then
                count <= 0;
                clkint <= not clkint;
            end if;
        end if;
    end process;

    clkout <= clkint;

end main;