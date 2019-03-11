-- author: Furkan Cayci, 2018
-- description: hdmi out testbench

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_hdmi_out is
end tb_hdmi_out;

architecture rtl of tb_hdmi_out is

	-- enable GHDL simulation support
	-- disable this when using Vivado
	--   OSERDESE2 is normally used for 7-series
	--   but since it is encrypted, GHDL cannot simulate it
	--   Thus, this will downgrade it to OSERDESE1
	--   for simulation under GHDL
	constant GHDL_SIM : boolean := false;

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	constant clk_period : time := 8 ns;
	constant reset_time : time :=   20 * clk_period;
	constant hsync_time : time := 1648 * clk_period;
	constant frame_time : time :=  750 * hsync_time;

	-- interface ports / generics
	constant RESOLUTION : string := "HD720P"; -- HD720P, SVGA, VGA
	constant GEN_PATTERN : boolean := false;  -- generate pattern or objects
	constant GEN_PIX_LOC : boolean := true;   -- generate location counters for x / y coordinates
	constant OBJECT_SIZE : natural := 16;     -- size of the objects. should be higher than 11
	constant PIXEL_SIZE : natural := 24;      -- RGB pixel total size. (R + G + B)

	signal clk_p, clk_n : std_logic;
	signal data_p, data_n : std_logic_vector(2 downto 0);

begin

	-- clock generate
	uut0: entity work.hdmi_out
	  port map(clk=>clk, rst=>rst, clk_p=>clk_p, clk_n=>clk_n,
	           data_p=>data_p, data_n=>data_n);

	process
	begin
		--for i in 0 to 2 * frame_time / clk_period loop
			wait for clk_period/2;
			clk <= not clk;
		--end loop;
		--wait;
	end process;

	process
	begin
		rst <= '1';
		wait for reset_time;
		rst <= '0';
		wait for frame_time;
		wait;
	end process;

end rtl;
