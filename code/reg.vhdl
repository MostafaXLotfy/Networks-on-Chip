library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY reg IS
port(Data_in : IN std_logic_vector (7 downto 0);
Clock : IN std_logic;
Data_out : OUT std_logic_vector (7 downto 0);
Clock_En : IN std_logic;
Reset : IN std_logic);
end;


ARCHITECTURE behave OF reg IS
BEGIN
process(Clock,Clock_En,Reset) IS
BEGIN 
    IF Clock'event and Clock = '1' then
        IF Reset = '1' THEN
            Data_Out <= (others =>'0') ;
        ELSIF Clock_En = '1' THEN 
            Data_out <= Data_in;
        END IF;
    END IF; 
 END PROCESS;
END;
