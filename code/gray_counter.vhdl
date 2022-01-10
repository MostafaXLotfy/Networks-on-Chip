library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gray_counter is
    port 
    (
	Clock, Reset, En: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
    );
end entity gray_counter;

architecture behav of gray_counter is
    signal counter: unsigned (3 downto 0);
begin
    clock_tick: process(Reset, clock, En) is
	begin
		if Clock'event and Clock = '1' then
			if Reset = '1' then
					counter <= "0000";
			elsif En = '1' then
				counter <= counter + 1;
			end if;
		end if;
	end process clock_tick;
	count_out(3) <= counter(3);
	count_out(2) <= counter (2) xor counter(3);
	count_out(1) <= counter (1) xor counter(2);
	count_out(0) <= counter (0) xor counter(1);
end architecture;
