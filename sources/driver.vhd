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
        door0 : out std_logic;
        lock0 : out std_logic;
        door1 : out std_logic;
        lock1 : out std_logic;
        door2 : out std_logic;
        lock2 : out std_logic;
        door3 : out std_logic;
        lock3 : out std_logic
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
            detected : out std_logic
        );
    end component;

    -- component password is
        -- port (
            -- keypress : in std_logic;
            -- key : in std_logic_vector(0 to 3);
            -- password : out std_logic_vector(0 to 15);
            -- entered : out std_logic
         -- );
    -- end component;

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

    component servoman is
        port (
            clk : in std_logic;
            enable : in std_logic;
            open0 : in std_logic;
            open1 : in std_logic;
            open2 : in std_logic;
            open3 : in std_logic;
            door0 : out std_logic;
            lock0 : out std_logic;
            door1 : out std_logic;
            lock1 : out std_logic;
            door2 : out std_logic;
            lock2 : out std_logic;
            door3 : out std_logic;
            lock3 : out std_logic
         );
    end component;

    constant enter_key : std_logic_vector(0 to 3) := "0000";
    constant clear_key : std_logic_vector(0 to 3) := "0011";

    signal passwd0 : std_logic_vector(0 to 15) := "0000" & "0000" & "0000" & "0000";
    signal passwd1 : std_logic_vector(0 to 15) := "0000" & "0000" & "0000" & "0000";

    signal an_int : std_logic_vector(0 to 3) := "1110";
    signal clk40us, clk500ms : std_logic := '0';
    signal keypress, checked, detected0, detected1, clear, entered, mainpass, pass1 : std_logic := '0';
    signal key, kseg, kseq, kcar : std_logic_vector(0 to 3);
    signal seg_count : integer range 0 to 3 := 0;
    signal tmp_cath : std_logic_vector(0 to 7) := "11111111";
    signal cathodes : std_logic_vector(0 to 31) := "11111111111111111111111111111111"; -- "11000001110001011100010111000001"; -- change this before it gets you in shit

begin

    Clk0 : bclk port map (clk, 4000, clk40us);
    Key0 : keypad port map (clk, ay, ax, key, keypress);
    Seg0 : keypad2seg port map (clk, key, tmp_cath);
    Seq0 : sequence port map (clear, mainpass, keypress, key, passwd0, detected0);
    Seq1 : sequence port map (clear, pass1, keypress, key, passwd1, detected1);
    -- Pas0 : password port map (keypress, key, passwd0, entered);
    Srvo : servoman port map (clk, disp, detected0, detected1, '0', '0', door0, lock0, door1, lock1, door2, lock2, door3, lock3);

    passwd0 <= "1000" & "0101" & "1010" & "0110"; -- 2487
    passwd1 <= "0100" & "1000" & "1100" & "0000"; -- 123
    mainpass <= disp and not detected0;
    pass1 <= disp and detected0;

    process(keypress)
    begin
        if rising_edge(keypress) then
            case key is
                when enter_key =>
                    cathodes <= "11111111111111111111111111111111";
                when clear_key =>
                    cathodes <= "11111111111111111111111111111111";
                when others =>
                    if disp = '1' then
                        cathodes <= (cathodes(8 to 31) & tmp_cath);
                    end if;
            end case;
        end if;
    end process;

    clear <= '1' when key = clear_key else '0';

    process(clk40us)
    begin
        if rising_edge(clk40us) then
            case an_int is
                when "0111" =>
                    an_int <= "1110";
                    cath <= cathodes(24 to 31);
                when "1110" =>
                    an_int <= "1101";
                    cath <= cathodes(16 to 23);
                when "1101" =>
                    an_int <= "1011";
                    cath <= cathodes(8 to 15);
                when "1011" =>
                    an_int <= "0111";
                    cath <= cathodes(0 to 7);
                when others =>
                    an_int <= "0111";
            end case;
        end if;
    end process;

    an <= an_int when disp = '1' else "1111";

end architecture;
