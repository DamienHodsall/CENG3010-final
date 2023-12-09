library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity test_sequence is
end entity;

architecture main of test_sequence is

    -- test four inputs for each password
    type passwordarr is array (0 to 3) of std_logic_vector(0 to 15);
    constant passwords : passwordarr := (
        "0100" & "1000" & "1100" & "0101", -- 1234
        "1000" & "1101" & "1010" & "0000", -- 248
        "1100" & "0000" & "0000" & "0000", -- 3
        "0000" & "0000" & "0000" & "0000" -- no password
    );

    -- @ for enter key
    type input is array (natural nange <>) of std_logic_vector(0 to 3);
    constant test1a : input(0 to 4) ("0101", "1100", "1000", "0100", "0000"); -- 4321@

    component sequence is
        port (
            reset : in std_logic;
            enable : in std_logic;
            keypress : in std_logic;
            keyin : in std_logic_vector(0 to 3);
            password : in std_logic_vector(0 to 15);
            detected : out std_logic := '0'
        );
    end component;

    signal reset, enable, keypress, detected : std_logic;
    signal keyin, std_logic_vector(0 to 3);
    signal password : std_logic_vector(0 to 15);

begin

    S : sequence port map (reset, enable, keypress, keyin, password, detected);

    process(clk)
    begin
        if rising_edge(clk) then
            null;
        end if;
    end process;

end architecture;
