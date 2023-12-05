library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity servoman is
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
        lock3 : out std_logic;
        opened0 : out std_logic;
        opened1 : out std_logic;
        opened2 : out std_logic;
        opened3 : out std_logic
     );
 end servoman;

architecture main of servoman is

    component bclk is
        port (
            clkin : in std_logic;
            period : in integer;
            clkout : out std_logic
         );
    end component;

    component servo is
        port (
            clk : in std_logic;
            angle : in std_logic;
            pin : out std_logic
         );
    end component;

    type states is (trans, timer, sod0, sol0, sod1, sol1, sod2, sol2, sod3, sol3, scd0, scl0, scd1, scl1, scd2, scl2, scd3, scl3, scdi, scli); -- state_open_door_0, state_open_lock_0, ... , state_close_door_0, etc
    signal state, next_state : states := trans;

    signal clk1ms : std_logic := '0';
    signal ad0, al0, ad1, al1, ad2, al2, ad3, al3 : std_logic := '1'; -- activate_door_0, activate_lock_0, etc

begin

    Cl0 : bclk port map (clk, 100000, clk1ms);

    SD0 : servo port map (clk, ad0, door0);
    SL0 : servo port map (clk, al0, lock0);
    SD1 : servo port map (clk, ad1, door1);
    SL1 : servo port map (clk, al1, lock1);
    SD2 : servo port map (clk, ad2, door2);
    SL2 : servo port map (clk, al2, lock2);
    SD3 : servo port map (clk, ad3, door3);
    SL3 : servo port map (clk, al3, lock3);

    opened0 <= al0;
    opened1 <= al1;
    opened2 <= al2;
    opened3 <= al3;

    process(clk1ms)
        variable count : integer := 0;
    begin
        if rising_edge(clk1ms) then
            case state is

                when trans =>
                    if open0 = '1' then
                        if ad0 = '0' then
                            state <= sol0;
                        else

                            if open1 = '1' then
                                if ad1 = '0' then
                                    state <= sol1;
                                end if;
                            elsif al1 = '1' then
                                state <= scd1;
                            end if;

                            if open2 = '1' then
                                if ad2 = '0' then
                                    state <= sol2;
                                end if;
                            elsif al2 = '1' then
                                state <= scd2;
                            end if;

                            if open3 = '1' then
                                if ad3 = '0' then
                                    state <= sol3;
                                end if;
                            elsif al3 = '1' then
                                state <= scd3;
                            end if;

                        end if;
                    elsif al0 = '1' then
                        state <= scdi;
                    end if;

                when timer =>
                    if count >= 500 then
                        count := 0;
                        state <= next_state;
                    else
                        count := count + 1;
                    end if;

                when sol0 =>
                    al0 <= '1';
                    next_state <= sod0;
                    state <= timer;

                when sod0 =>
                    ad0 <= '1';
                    state <= trans;

                when scd0 =>
                    ad0 <= '0';
                    next_state <= scl0;
                    state <= timer;

                when scl0 =>
                    al0 <= '0';
                    state <= trans;

                when sol1 =>
                    al1 <= '1';
                    next_state <= sod1;
                    state <= timer;

                when sod1 =>
                    ad1 <= '1';
                    state <= trans;

                when scd1 =>
                    ad1 <= '0';
                    next_state <= scl1;
                    state <= timer;

                when scl1 =>
                    al1 <= '0';
                    state <= trans;

                when sol2 =>
                    al2 <= '1';
                    next_state <= sod2;
                    state <= timer;

                when sod2 =>
                    ad2 <= '1';
                    state <= trans;

                when scd2 =>
                    ad2 <= '0';
                    next_state <= scl2;
                    state <= timer;

                when scl2 =>
                    al2 <= '0';
                    state <= trans;

                when sol3 =>
                    al3 <= '1';
                    next_state <= sod3;
                    state <= timer;

                when sod3 =>
                    ad3 <= '1';
                    state <= trans;

                when scd3 =>
                    ad3 <= '0';
                    next_state <= scl3;
                    state <= timer;

                when scl3 =>
                    al3 <= '0';
                    state <= trans;

                when scdi =>
                    ad1 <= '0';
                    ad2 <= '0';
                    ad3 <= '0';
                    next_state <= scli;
                    state <= timer;

                when scli =>
                    al1 <= '0';
                    al2 <= '0';
                    al3 <= '0';
                    next_state <= scd0;
                    state <= timer;

                when others =>
                    state <= trans;

            end case;
        end if;
    end process;

end main;
