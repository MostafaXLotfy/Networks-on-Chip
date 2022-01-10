
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY demux IS 
PORT (Sel: IN std_logic_vector (1 downto 0);
En : IN std_logic;
d_in : IN std_logic_vector ( 7 downto 0);
d_out1,d_out2,d_out3,d_out4 : OUT std_logic_vector (7 downto 0));
END;

ARCHITECTURE behave OF demux IS
BEGIN
PROCESS (Sel,En, d_in) IS 
BEGIN
	IF EN = '1' THEN
		case (sel) is 
			when "00" => d_out1 <= d_in; d_out2 <= (others => '0');d_out3 <= (others => '0');d_out4 <= (others => '0');
			when "01" => d_out2 <= d_in; d_out1 <= (others => '0');d_out3 <= (others => '0');d_out4 <= (others => '0');
			when "10" => d_out3 <= d_in; d_out2 <= (others => '0');d_out1 <= (others => '0');d_out4 <= (others => '0');
			when "11" => d_out4 <= d_in; d_out2 <= (others => '0');d_out3 <= (others => '0');d_out1 <= (others => '0');
			when others => d_out1 <= (others => '0'); d_out2 <= (others => '0');d_out3 <= (others => '0');d_out4 <= (others => '0');
		end case;
	Else
	       	d_out1 <= (others => '0');d_out2 <= (others => '0');d_out3 <= (others => '0');d_out4 <= (others => '0');
	END IF;

END PROCESS;
END;
