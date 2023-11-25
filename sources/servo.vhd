library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

entity servo is
    port (
        clk: in std_logic;
        angle: in std_logic;
        pin: out std_logic
    );
end entity;

architecture main of servo is

    component bclk is
        port (
            clkin: in std_logic;
            period: in integer;
            clkout: out std_logic
        );
    end component;

    component pwm is
        port (
            clk: in std_logic;
            period: in integer;
            duty: in integer;
            sig: out std_logic
        );
    end component;

    signal clkp: std_logic;
    signal duty: integer;

begin

    Cp: bclk port map (clk, 50000, clkp);
    P: pwm port map (clkp, 20, duty, pin);
    duty <= 2 when angle = '1' else 1;

end main;