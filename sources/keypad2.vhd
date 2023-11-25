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

    component bclk is
        port (
            clkin : in std_logic;
            period : in integer;
            clkout : out std_logic
        );
    end component;

    component pwm is
        port (
            clk : in std_logic;
            period : in integer;
            duty : in integer;
            sig : out std_logic
        );
    end component;

    signal clk10us : std_logic := '0';
    signal check, noinput, keypress_int : std_logic := '0';
    signal xcoord : std_logic_vector(0 to 3) := not "0001";
    signal last_pos, new_pos : std_logic_vector(0 to 3);
    signal xycase : std_logic_vector(0 to 7) := "00000000";
    signal timer : integer := 0;
    signal state_input, prev_state, state, next_state : natural range 0 to 3 := 0; -- start at 3 so it can be immediately changed back to 0

begin

    C : bclk port map (clk, 1000, clk10us);
    P : pwm port map (clk, 500, 10, check);

    ax <= xcoord;
    xycase <= xcoord & ay;
    pos <= new_pos;
    keypress <= keypress_int;

    process(clk10us)
    begin
        if rising_edge(clk10us) then
            if check = '0' then
                -- xcoord <= xcoord(1 to 3) & xcoord(0);
                prev_state <= state;
                state <= next_state;
                case state is
                    when 0 =>
                        next_state <= 1;
                        xcoord <= "1110";
                    when 1 =>
                        next_state <= 2;
                        xcoord <= "1101";
                    when 2 =>
                        next_state <= 3;
                        xcoord <= "1011";
                    when 3 =>
                        next_state <= 0;
                        xcoord <= "0111";
                end case;
            else
                case xycase is
                    when "11101110" =>
                        new_pos <= "0000";
                        noinput <= '0';
                        state_input <= 0;
                    when "11101101" =>
                        new_pos <= "0001";
                        noinput <= '0';
                        state_input <= 0;
                    when "11101011" =>
                        new_pos <= "0010";
                        noinput <= '0';
                        state_input <= 0;
                    when "11100111" =>
                        new_pos <= "0011";
                        noinput <= '0';
                        state_input <= 0;
                    when "11011110" =>
                        new_pos <= "0100";
                        noinput <= '0';
                        state_input <= 1;
                    when "11011101" =>
                        new_pos <= "0101";
                        noinput <= '0';
                        state_input <= 1;
                    when "11011011" =>
                        new_pos <= "0110";
                        noinput <= '0';
                        state_input <= 1;
                    when "11010111" =>
                        new_pos <= "0111";
                        noinput <= '0';
                        state_input <= 1;
                    when "10111110" =>
                        new_pos <= "1000";
                        noinput <= '0';
                        state_input <= 2;
                    when "10111101" =>
                        new_pos <= "1001";
                        noinput <= '0';
                        state_input <= 2;
                    when "10111011" =>
                        new_pos <= "1010";
                        noinput <= '0';
                        state_input <= 2;
                    when "10110111" =>
                        new_pos <= "1011";
                        noinput <= '0';
                        state_input <= 2;
                    when "01111110" =>
                        new_pos <= "1100";
                        noinput <= '0';
                        state_input <= 3;
                    when "01111101" =>
                        new_pos <= "1101";
                        noinput <= '0';
                        state_input <= 3;
                    when "01111011" =>
                        new_pos <= "1110";
                        noinput <= '0';
                        state_input <= 3;
                    when "01110111" =>
                        new_pos <= "1111";
                        noinput <= '0';
                        state_input <= 3;
                    when others =>
                        if prev_state = state_input then
                            noinput <= '1';
                        end if;
                end case;
            end if;

            if last_pos = new_pos and noinput = '0' then
                timer <= timer + 1;
                if timer >= 7500 then
                    keypress_int <= '1';
                    timer <= 0;
                else
                    keypress_int <= '0';
                end if;
            else
                keypress_int <= '0';
                timer <= 0;
            end if;

            last_pos <= new_pos;
        end if;
    end process;

end architecture;
