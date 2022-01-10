library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY testbench IS
END ENTITY;

ARCHITECTURE behave OF testbench IS 
SIGNAL datai1,datai2,datai3,datai4,datao1,datao2,datao3,datao4 : std_logic_vector(7 DOWNTO 0);
SIGNAL wr1,wr2,wr3,wr4,wclock,rclock,rst : std_logic;

component Router is
    port(
	datai1, datai2, datai3, datai4: in std_logic_vector(7 downto 0);
	wr1, wr2, wr3, wr4: in std_logic;
	datao1, datao2, datao3, datao4: out std_logic_vector(7 downto 0);
	wrclk, rdclk: in std_logic;
	rst: in std_logic
	);
end component Router;
for dut: Router use entity work.Router(behav);
constant clock_period : time := 20 ns;
BEGIN 
dut: Router port map( datai1, datai2, datai3, datai4,
					   wr1, wr2, wr3, wr4,
					   datao1, datao2, datao3, datao4,
					   wclock, rclock, rst);
wclk: PROCESS IS 
BEGIN
	wclock <= '0';
	wait for clock_period / 2 ;
	wclock <= '1';
	wait for clock_period / 2 ;
END PROCESS wclk;

rclk: PROCESS IS
BEGIN
	rclock <= '0';
	wait for clock_period / 2 ;
	rclock <= '1';
	wait for clock_period / 2 ;
END PROCESS rclk;

p1: PROCESS IS
BEGIN
	rst <= '1';
	wait for clock_period;
	rst <= '0';
	wr1 <= '1';wr2 <= '1';wr3 <= '1';wr4 <= '1';
	datai1 <= "11001000";
	datai2 <= "10010001";
	datai3 <= "01010110";
	datai4 <= "10001011";
	wait for clock_period;
	datai1 <= "11011011";
	datai2 <= "10010000";
	datai3 <= "01110101";
	datai4 <= "10001110";
	wait for clock_period;
	datai1 <= "11011010";
	datai2 <= "10110011";
	datai3 <= "11110100";
	datai4 <= "00001001";
	wait for clock_period;
	datai1 <= "11001101";
	datai2 <= "11001010";
	datai3 <= "01010111";
	datai4 <= "10111100";
	wait;
END PROCESS p1;

assert_proc: PROCESS(datao1, datao2, datao3, datao4) IS
	BEGIN
		if datao1'event then
			assert datao1(1 downto 0) = "00" report "wrong output from port1 the address should be 00" severity error;
		end if;
		if datao2'event then
			assert datao2(1 downto 0) = "01" report "wrong output from port2 the address should be 01" severity error;
		end if;
		if datao3'event then
			assert datao3(1 downto 0) = "10" report "wrong output from port3 the address should be 10" severity error;
		end if;
		if datao4'event then
			assert datao4(1 downto 0) = "11" report "wrong output from port4 the address should be 11" severity error;
		end if;
	END PROCESS;
END ARCHITECTURE;











