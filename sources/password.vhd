library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity password is
    port (
        keypress : in std_logic;
        key : in std_logic_vector(0 to 3);
        password : out std_logic_vector(0 to 15);
        entered : out std_logic
     );
end password;

architecture main of password is

    signal passint : std_logic_vector(0 to 15);

begin

    process(keypress)
    begin
        if rising_edge(keypress) then
            null;
        end if;
    end process;

end architecture;
