library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity driver is
    port (
        clk : in std_logic;
        disp : in std_logic;
        ay : in std_logic_vector(0 to 3);
        ax : out std_logic_vector(0 to 3);
        cath : out std_logic_vector(0 to 7);
        an : out std_logic_vector(0 to 3);
        ledout : out std_logic;
        servout : out std_logic;
        servout1 : out std_logic
    );
end driver;

architecture main of driver is

    component bclk is
        port (
            clkin : in std_logic;
            period : in integer;
            clkout : out std_logic
        );
    end component;

    component keypad is
        port (
            clk : in std_logic;
            ay : in std_logic_vector(0 to 3);
            ax : out std_logic_vector(0 to 3);
            pos : out std_logic_vector(0 to 3);
            keypress : out std_logic
        );
    end component;

    component keypad2seg is
        port (
            clk : in std_logic;
            data : in std_logic_vector(0 to 3);
            cath : out std_logic_vector(0 to 7)
        );
    end component;

    component sequence is
        port (
            reset : in std_logic;
            enable : in std_logic;
            keypress : in std_logic;
            keyin : in std_logic_vector(0 to 3);
            password : in std_logic_vector(0 to 15);
            checked : out std_logic;
            detected : out std_logic
        );
    end component;

    component password is
        port (
            keypress : in std_logic;
            key : in std_logic_vector(0 to 3);
            password : out std_logic_vector(0 to 15);
            entered : out std_logic
         );
    end component;

    component servo is
        port (
            clk : in std_logic;
            angle : in std_logic;
            pin : out std_logic
        );
    end component;

    component delay is
        port (
            clk : in std_logic;
            ms : in integer;
            sigin : in std_logic;
            sigout : out std_logic
         );
    end component;

    signal passwd : std_logic_vector(0 to 15) := "0000" & "0000" & "0000" & "0000";

    signal an_int : std_logic_vector(0 to 3) := "1110";
    signal clk40us, clk500ms : std_logic := '0';
    signal keypress, checked, detected, detected1, button, entered : std_logic := '0';
    signal key, kseg, kseq, kcar : std_logic_vector(0 to 3);
    signal seg_count : integer range 0 to 3 := 0;
    signal tmp_cath : std_logic_vector(0 to 7) := "11111111";
    signal cathodes : std_logic_vector(0 to 31) := "11111111111111111111111111111111"; -- "11000001110001011100010111000001"; -- change this before it gets you in shit

begin

    Clk0 : bclk port map (clk, 4000, clk40us);
    Key0 : keypad port map (clk, ay, ax, key, keypress);
    Seg0 : keypad2seg port map (clk, key, tmp_cath);
    Seq0 : sequence port map (button, disp, keypress, key, passwd, checked, detected);
    Pas0 : password port map (keypress, key, passwd, entered);
    Srv0 : servo port map (clk, detected, servout);
    Srv1 : servo port map (clk, detected1, servout1);
    Del0 : delay port map (clk, 500, detected, detected1);

    ledout <= checked;
    passwd <= "1000" & "0101" & "1010" & "0110";

    process(keypress)
    begin
        if rising_edge(keypress) then
            case key is
                when "0000" => -- enter key
                    null;
                when "0011" => -- clear key
                    cathodes <= "11111111111111111111111111111111";
                when others =>
                    cathodes <= (cathodes(8 to 31) & tmp_cath);
            end case;
        end if;
    end process;

    button <= '1' when key = "0011" else '0';

    process(clk40us)
    begin
        if rising_edge(clk40us) then
            case seg_count is
                when 0 =>
                    seg_count <= 1;
                    an_int <= "1110";
                    cath <= cathodes(24 to 31);
                when 1 =>
                    seg_count <= 2;
                    an_int <= "1101";
                    cath <= cathodes(16 to 23);
                when 2 =>
                    seg_count <= 3;
                    an_int <= "1011";
                    cath <= cathodes(8 to 15);
                when 3 =>
                    seg_count <= 0;
                    an_int <= "0111";
                    cath <= cathodes(0 to 7);
                when others =>
                    seg_count <= 0;
                    an_int <= "1111";
                    cath <= "11111111";
            end case;
        end if;
    end process;

    an <= an_int when disp = '1' else "1111";

end architecture;
