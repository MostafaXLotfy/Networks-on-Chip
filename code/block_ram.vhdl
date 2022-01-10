library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_unsigned.all;

ENTITY block_ram IS 
    PORT(d_in : IN std_logic_vector (7 downto 0);
    ADDRA,ADDRB :IN std_logic_vector (3 downto 0);
    WEA,REA,CLKA,CLKB :IN std_logic;
    d_out : OUT std_logic_vector (7 downto 0));
END ENTITY block_ram;

ARCHITECTURE behave OF block_ram IS
    TYPE wrm IS ARRAY (0 to 31) OF std_logic_vector (7 downto 0);
    SIGNAl word : wrm;
BEGIN
    wm : PROCESS (WEA,ADDRA,CLKA,d_in) IS
    BEGIN 
        IF CLKA'event and CLKA = '1' AND WEA = '1' THEN 
            word(conv_integer(ADDRA)) <= d_in;
        END IF;
    END PROCESS wm;

    rm : PROCESS (REA,ADDRB,CLKB,d_in) IS
    BEGIN 
        IF CLKB'event and CLKB = '1' Then
            IF REA = '1' THEN 
                d_out <= word(conv_integer(ADDRB));
            end if;
        end if;
    END PROCESS rm;
END;

