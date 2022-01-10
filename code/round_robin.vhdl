library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY round_robin IS 
PORT ( clock : IN std_logic;
din1,din2,din3,din4 : IN std_logic_vector (7 downto 0);
dout : OUT std_logic_vector (7 downto 0));
END;

ARCHITECTURE behave OF round_robin IS
TYPE state_type IS (d1,d2,d3,d4);
SIGNAL current_state: state_type := d1;
SIGNAL next_state: state_type;
BEGIN
    clk:PROCESS (clock) IS 
    BEGIN
        IF rising_edge(clock) THEN current_state <= next_state;
        END IF;
    END PROCESS clk;
        ns: PROCESS (current_state, din1, din2, din3, din4) IS
        BEGIN
            CASE(current_state) IS 
                WHEN d1 => 
                    dout<=din1;
                    next_state <= d2;
                WHEN d2 => 
                    dout<=din2;
                    next_state <= d3;
                WHEN d3 => 
                    dout<=din3;
                    next_state <= d4;
                WHEN d4 => 
                    dout<=din4;
                    next_state <= d1;
        END CASE;
    END PROCESS ns;
END;
