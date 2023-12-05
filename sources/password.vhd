library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity password is
    port (
        enable : in std_logic;
        keypress : in std_logic;
        key : in std_logic_vector(0 to 3);
        password : out std_logic_vector(0 to 15);
        entered : out std_logic
     );
end password;

architecture main of password is

    constant enter_key : std_logic_vector(0 to 3) := "0000";
    constant clear_key : std_logic_vector(0 to 3) := "0011";

    signal passint : std_logic_vector(0 to 15) := "0000" & "0000" & "0000" & "0000";

begin

    process(keypress)
    begin
        if rising_edge(keypress) then
            if enable = '1' then
                entered <= '0';
                case key is
                    when enter_key =>
                        password <= passint;
                        entered <= '1';
                    when clear_key =>
                        passint <= "0000" & "0000" & "0000" & "0000";
                    when others =>
                        passint <= key & passint(0 to 11);
                end case;
            else
                passint <= "0000" & "0000" & "0000" & "0000";
            end if;
        end if;
    end process;

end architecture;
