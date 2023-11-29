library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;

-- the idea behind this detector is that a sequence is correct until it isn't, after which it will never be correct
-- so the password entered so far can be correct. then all you need to worry about is the characters
-- in the stored password that haven't been checked. if the are characters remaining then the entered password
-- is partially correct in reference to the full password. iow you put in half the correct password.
-- if there are no remaining characters in the stored password then it must be the complete, correct password.

-- when an incorrect character is input then stop checking successive inputs
    -- wrong state doesn't check
    -- fixes the concern with longer input then password by just handling one case where (index = pas_len) and setting the state to wrong

-- something to think about is how to store the password(s). a signal would technically work but it feels wrong

-- have a huge buffer filled with "0011" because that's the enter char and it isn't really a char that can be input

entity sequence is
    port (
        reset : in std_logic;
        enable : in std_logic; -- this is so you don't always do password checking. might not be necessary but feels useful
        keypress : in std_logic; -- whether a key was pressed
        keyin : in std_logic_vector(0 to 3); -- the last key pressed
        password : in std_logic_vector(0 to 15);
        detected : out std_logic := '0' -- whether the correct sequence has been detected
    );
end sequence;

architecture main of sequence is

    constant enter_key : std_logic_vector(0 to 3) := "0000";

    signal tempass : std_logic_vector(0 to 15) := password;
    signal state : std_logic := '1';

begin

    process(keypress)
        variable passchar : std_logic_vector(0 to 3);
    begin
        if rising_edge(keypress) then

            if reset = '1' then

                tempass <= password;
                passchar := tempass(0 to 3);
                state <= '1';
                detected <= '0';

            elsif enable = '1' then

                passchar := tempass(0 to 3);
                tempass <= tempass(4 to 15) & enter_key;

                if keyin = enter_key and passchar = enter_key then
                    detected <= state;
                elsif keyin /= passchar then
                    state <= '0';
                end if;

            end if;
        end if;
    end process;

end architecture;
