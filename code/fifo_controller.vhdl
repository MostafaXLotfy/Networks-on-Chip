library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_controller is
    port (
	    reset, rdclk, wrclk, rreq, wreq: in std_logic ;
	    write_valid, read_valid: out std_logic;
	    wr_ptr, rd_ptr: out std_logic_vector (3 downto 0);
	    empty, full: out std_logic
	 );
end entity fifo_controller;
architecture behav of fifo_controller is
    component gray_counter is 
	port 
	(
	    Clock, Reset, En: in std_logic;
	    count_out: out std_logic_vector(3 downto 0)
	);
    end component gray_counter;
    for all: gray_counter use entity work.gray_counter(behav);
    component gray_to_binary_convertor is
	Port ( gray_in : in STD_LOGIC_VECTOR (3 downto 0);
	       bin_out : out STD_LOGIC_VECTOR (3 downto 0)
	     );
    end component gray_to_binary_convertor;
	for all: gray_to_binary_convertor use entity work.gray_to_binary_convertor(behav);
    -- gray counters signals
    signal read_counter, write_counter: std_logic_vector(3 downto 0);
    -- binary counters signals
    signal b_read_counter, b_write_counter: std_logic_vector(3 downto 0);
    -- signals for write_valid and read_valid
    signal read_signal, write_signal: std_logic;
	signal temp_empty, temp_full :std_logic;
begin
    gray_read_counter: gray_counter port map  (rdclk, reset, read_signal, read_counter);
    gtay_write_counter: gray_counter port map (wrclk, reset, write_signal, write_counter);

    read_convertor: gray_to_binary_convertor port map (read_counter, b_read_counter);
	write_convertor: gray_to_binary_convertor port map (write_counter, b_write_counter);

	empty_full: process (rdclk,wrclk, reset, b_read_counter, b_write_counter) is
	begin
    if rdclk = '1' then
		if reset = '1' then
			temp_full <= '0';
			temp_empty <= '1';
			elsif b_write_counter = b_read_counter then
				temp_full  <= '0';
				temp_empty <= '1';
			elsif unsigned(b_write_counter) + 1 = unsigned(b_read_counter) then
				temp_full <= '1';
				temp_empty <= '0';
			else
			temp_empty <= '0';
			temp_full  <= '0';
		end if;
	end if;
	end process;

    process (rdclk, rreq, temp_empty) is
	begin
			if rdclk = '1'  then
				if rreq = '1' and temp_empty = '0' then
					read_signal <= '1';
				else
					read_signal <= '0';
				end if;
			end if;
	end process;

	process (wrclk, wreq, temp_full) is
	begin
			if wrclk = '1' then
				if wreq = '1' and temp_full = '0' then
					write_signal <= '1';
				else 
					write_signal <= '0';
				end if;
			end if;
	end process;
	read_valid <= read_signal;
	write_valid <= write_signal;
	empty <= temp_empty;
	full <= temp_full;
	wr_ptr <= b_write_counter;
	rd_ptr <= b_read_counter;
end architecture behav;
