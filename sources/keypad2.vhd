library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity keypad2 is
    port (
        clk : in std_logic;
        ay : in std_logic_vector(0 to 3);
        ax : out std_logic_vector(0 to 3);
        pos : out std_logic_vector(0 to 3);
        keypress : out std_logic
    );
end keypad2;

architecture main of keypad2 is

    component pwm is
        port (
            clk : in std_logic;
            period : in integer;
            duty : in integer;
            sig : out std_logic
        );
    end component;

    signal send_out, noinput, check : std_logic;
    signal col : std_logic_vector(0 to 3) := "1111";
    signal coord : std_logic_vector(0 to 7);

begin

    C : pwm port map (clk, 500, 10, check);

    coord <= col & ay;

    process(check)
    begin
        -- up part is smaller so use that to send the col data
        if rising_edge(check) then
            case col is
                when "1110" =>
                    col <= "1101";
                    send_out <= '0';
                when "1101" =>
                    col <= "1011";
                    send_out <= '0';
                when "1011" =>
                    col <= "0111";
                    send_out <= '0';
                when "0111" =>
                    col <= "1110";
                    send_out <= '1';
                when "1111" =>
                    col <= "1110";
                    send_out <= '0';
            end case;
        end if;

        -- use the falling_edge to do the logic with the result
        if falling_edge(check) then
            case coord is
                when others =>
                    null;
            end case;
        end if;
    end process;

end architecture;
