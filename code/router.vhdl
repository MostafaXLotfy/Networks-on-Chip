library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity router is
    port(
	datai1, datai2, datai3, datai4: in std_logic_vector(7 downto 0);
	wr1, wr2, wr3, wr4: in std_logic;
	datao1, datao2, datao3, datao4: out std_logic_vector(7 downto 0);
	wrclk, rdclk: in std_logic;
	rst: in std_logic
	);
end entity router;

architecture behav of router is

    component reg IS
	port(Data_in : IN std_logic_vector (7 downto 0);
	Clock : IN std_logic;
	Data_out : OUT std_logic_vector (7 downto 0);
	Clock_En : IN std_logic;
	Reset : IN std_logic);
    end component reg;
    for all :reg use entity work.reg(behave);
    component demux IS 
    PORT (
	    Sel: IN std_logic_vector (1 downto 0);
	    En : IN std_logic;
	    d_in : IN std_logic_vector ( 7 downto 0);
	    d_out1,d_out2,d_out3,d_out4 : OUT std_logic_vector (7 downto 0)
	);
    END component demux;
    for all :demux use entity work.demux(behave);

    component round_robin IS 
    PORT ( clock : IN std_logic;
    din1,din2,din3,din4 : IN std_logic_vector (7 downto 0);
    dout : OUT std_logic_vector (7 downto 0));
    END component round_robin;
    for all: round_robin use entity work.round_robin(behave);
    component fifo is
	port (
		reset, rdclk, wrclk, rreq, wreq: in std_logic ;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0);
		empty, full: out std_logic
	     );
    end component fifo;
	for all: fifo use entity work.fifo(behav);


    type vector_array is array (0 to 3) of std_logic_vector(7 downto 0);
    type vector_2d_array is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    type logic_2d_array is array (0 to 3, 0 to 3) of std_logic;

    signal datai_arr, datao_arr, in_buff_out: vector_array;
    signal demux_out, fifo_out: vector_2d_array;
    signal wreq, empty, full: logic_2d_array;
	signal wr_arr: std_logic_vector(0 to 3);
begin
    datai_arr <= (datai1, datai2, datai3, datai4);
    wr_arr <= (wr1, wr2, wr3, wr4);
	g1: for i in 0 to 3 generate
	in_buf: reg port map (datai_arr(i),wrclk, in_buff_out(i), wr_arr(i), rst);
	demux_i: demux port map(in_buff_out(i)(1 downto 0), wr_arr(i), in_buff_out(i),
							 demux_out(i, 0), demux_out(i, 1), demux_out(i, 2), demux_out(i, 3));
	scheduler: round_robin port map(rdclk, fifo_out(i,0), fifo_out(i, 1),
									 fifo_out(i, 2), fifo_out(i, 3), datao_arr(i));
    end generate g1;

    g2: for i in 0 to 3 generate
		g3: for j in 0 to 3 generate
					queue: fifo port map (rst, rdclk, wrclk,'1', wreq(j, i), demux_out(i, j),
										  fifo_out(j, i) ,empty(j, i), full(j, i));
		end generate g3;

	end generate g2;

	process(wrclk, rdclk, in_buff_out, datao_arr, wr_arr) is
	begin
		l1:for i in 0 to 3 loop
			l2: for j in 0 to 3 loop
				if (conv_integer(in_buff_out(j)(1 DOWNTO 0))) = i and wr_arr(j) = '1' THEN
					wreq(i, j) <= '1';
				else 
					wreq(i, j) <= '0';
				end if;
			end loop l2;
		end loop l1;												
	end process;
	datao1 <= datao_arr(0);
	datao2 <= datao_arr(1);
	datao3 <= datao_arr(2);
	datao4 <= datao_arr(3);

end  architecture behav;
