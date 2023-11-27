library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity keypad2seg is
    port (
        clk : in std_logic;
        data : in std_logic_vector(0 to 3);
        cath : out std_logic_vector(0 to 7)
    );
end keypad2seg;

architecture main of keypad2seg is

    signal cath_int : std_logic_vector(0 to 6);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            case data is
                when "0100" => cath_int <= "1001111"; -- 1
                when "0101" => cath_int <= "1001100"; -- 4
                when "0110" => cath_int <= "0001111"; -- 7
                when "0111" => cath_int <= "1100010"; -- 0/*/enter
                when "1000" => cath_int <= "0010010"; -- 2
                when "1001" => cath_int <= "0100100"; -- 5
                when "1010" => cath_int <= "0000000"; -- 8
                when "1011" => cath_int <= "0000001"; -- F/0
                when "1100" => cath_int <= "0000110"; -- 3
                when "1101" => cath_int <= "0100000"; -- 6
                when "1110" => cath_int <= "0001100"; -- 9
                when "1111" => cath_int <= "0011100"; -- E/#/clear
                when "0000" => cath_int <= "0001000"; -- A
                when "0001" => cath_int <= "1100000"; -- B
                when "0010" => cath_int <= "0110001"; -- C
                when "0011" => cath_int <= "1000010"; -- D
            end case;
        end if;
    end process;

    cath <= cath_int & '1';
end architecture;
