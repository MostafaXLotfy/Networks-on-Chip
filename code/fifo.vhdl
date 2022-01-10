library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    port (
	    reset, rdclk, wrclk, rreq, wreq: in std_logic ;
	    data_in : in std_logic_vector(7 downto 0);
	    data_out : out std_logic_vector(7 downto 0);
	    empty, full: out std_logic
	 );
end entity fifo ;

architecture behav of fifo is

component fifo_controller is
port (
	    reset, rdclk, wrclk, rreq, wreq: in std_logic ;
	    write_valid, read_valid: out std_logic;
	    wr_ptr, rd_ptr: out std_logic_vector (3 downto 0);
	    empty, full: out std_logic
	 );
 end component fifo_controller ;
 for all: fifo_controller use entity work.fifo_controller(behav);
    

component block_ram IS 
	PORT(
		d_in : IN std_logic_vector (7 downto 0);
		ADDRA,ADDRB :IN std_logic_vector (3 downto 0);
		WEA,REA,CLKA,CLKB :IN std_logic;
		d_out : OUT std_logic_vector (7 downto 0)
	    );
END component block_ram;
for all : block_ram use entity work.block_ram(behave);
signal write_valid, read_valid:std_logic;
signal wr_ptr, rd_ptr:std_logic_vector(3 downto 0);
begin
 controller: fifo_controller port map  (reset,rdclk, wrclk, rreq, wreq, write_valid, read_valid, wr_ptr, rd_ptr, empty, full);
 ram: block_ram port map (data_in, wr_ptr, rd_ptr, write_valid, read_valid, wrclk, rdclk, data_out);
end architecture behav;
