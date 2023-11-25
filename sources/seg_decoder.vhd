library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity seg_decoder is
    port (
        clk : in std_logic;
        dec : in std_logic;
        data : in std_logic_vector(0 to 3);
        cath : out std_logic_vector(0 to 7)
    );
end seg_decoder;

architecture main of seg_decoder is

    signal cath_int : std_logic_vector(0 to 6);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            case data is
                when "0000" => cath_int <= "0000001";
                when "0001" => cath_int <= "1001111";
                when "0010" => cath_int <= "0010010";
                when "0011" => cath_int <= "0000110";
                when "0100" => cath_int <= "1001100";
                when "0101" => cath_int <= "0100100";
                when "0110" => cath_int <= "0100000";
                when "0111" => cath_int <= "0001111";
                when "1000" => cath_int <= "0000000";
                when "1001" => cath_int <= "0001100";
                when "1010" => cath_int <= "0001000";
                when "1011" => cath_int <= "1100000";
                when "1100" => cath_int <= "0110001";
                when "1101" => cath_int <= "1000010";
                when "1110" => cath_int <= "0110000";
                when "1111" => cath_int <= "0111000";
            end case;
        end if;
    end process;

    cath <= cath_int & (not dec);

end architecture;