library ieee;
use ieee.std_logic_1164.all;

entity gpio_tb is
generic (dw : integer:= 32;
         aw : integer:= 8;
		 gw : integer:= 31);
end gpio_tb;

architecture behav of gpio_tb is
component gpio_top
port (
	  wb_clk_i: in std_logic;
	  wb_rst_i: in std_logic;
	  wb_cyc_i: in std_logic;
	  aux_i: in std_logic_vector (gw-1 downto 0);
	  ext_pad_i: in std_logic_vector (gw-1 downto 0);
	  clk_pad_i: in std_logic;
	  wb_adr_i: in std_logic_vector (aw-1 downto 0); 
	  wb_dat_i: in std_logic_vector (dw-1 downto 0);
	  wb_sel_i: in std_logic_vector (3 downto 0); 
	  wb_we_i: in std_logic; 
	  wb_stb_i: in std_logic;
	  wb_dat_o: out std_logic_vector (dw-1 downto 0); 
	  wb_ack_o: out std_logic; 
	  wb_err_o: out std_logic; 
	  wb_inta_o: out std_logic;
	  ext_pad_o: out std_logic_vector (gw-1 downto 0);
	  ext_padoe_o: out std_logic_vector (gw-1 downto 0)
	 );
end component;

  signal wb_clk_i: std_logic;
  signal wb_rst_i: std_logic;
  signal wb_cyc_i: std_logic;
  signal aux_i: std_logic_vector (gw-1 downto 0);
  signal ext_pad_i: std_logic_vector (gw-1 downto 0);
  signal clk_pad_i: std_logic;
  signal wb_adr_i: std_logic_vector (aw-1 downto 0); 
  signal wb_dat_i: std_logic_vector (dw-1 downto 0);
  signal wb_sel_i: std_logic_vector (3 downto 0); 
  signal wb_we_i: std_logic; 
  signal wb_stb_i: std_logic;
  signal wb_dat_o: std_logic_vector (dw-1 downto 0); 
  signal wb_ack_o: std_logic; 
  signal wb_err_o: std_logic; 
  signal wb_inta_o: std_logic;
  signal ext_pad_o: std_logic_vector (gw-1 downto 0);
  signal ext_padoe_o: std_logic_vector (gw-1 downto 0);
  signal rgpio_in: std_logic_vector (gw-1 downto 0);
  signal rgpio_out: std_logic_vector (gw-1 downto 0);
  signal rgpio_oe: std_logic_vector (gw-1 downto 0);
  signal rgpio_inte: std_logic_vector (gw-1 downto 0);
  signal rgpio_ptrig: std_logic_vector (gw-1 downto 0);
  signal rgpio_aux: std_logic_vector (gw-1 downto 0);
  signal rgpio_ctrl: std_logic_vector (1 downto 0);
  signal rgpio_ints: std_logic_vector (gw-1 downto 0);
  signal rgpio_eclk: std_logic_vector (gw-1 downto 0);
  signal rgpio_nec: std_logic_vector (gw-1 downto 0);
  signal sync, ext_pad_s: std_logic_vector (gw-1 downto 0);
  signal rgpio_out_sel: std_logic;
  signal rgpio_oe_sel: std_logic;
  signal rgpio_inte_sel: std_logic;
  signal rgpio_ptrig_sel: std_logic;
  signal rgpio_aux_sel: std_logic;
  signal rgpio_ctrl_sel: std_logic;
  signal rgpio_ints_sel: std_logic;
  signal rgpio_eclk_sel: std_logic;
  signal rgpio_nec_sel: std_logic;
  signal full_decoding: std_logic;
  signal in_muxed: std_logic_vector (gw-1 downto 0);
  signal wb_ack: std_logic;
  signal wb_err: std_logic;
  signal wb_inta: std_logic;
  signal wb_dat: std_logic_vector (dw-1 downto 0);
  signal out_pad: std_logic_vector (gw-1 downto 0);
  signal extc_in: std_logic_vector (gw-1 downto 0);
  signal pext_clk: std_logic_vector (gw-1 downto 0);
  signal pextc_sampled: std_logic_vector (gw-1 downto 0);
  signal nextc_sampled: std_logic_vector (gw-1 downto 0);
  signal sync_clk, clk_s, clk_r, pedge, nedge : std_logic;
  signal pedge_vec, nedge_vec, in_lach: std_logic_vector (gw-1 downto 0);
  signal syn_extc, extc_s: std_logic_vector (gw-1 downto 0);
  signal syn_pclk, ext_pad_spc: std_logic_vector (gw-1 downto 0);
  signal clk_n: std_logic;
  signal syn_nclk, ext_pad_snc: std_logic_vector (gw-1 downto 0);

  constant clock_period : time := 10 ns;

begin 

uut: gpio_top
port map (
          wb_clk_i => wb_clk_i,
	      wb_rst_i => wb_rst_i,
	      wb_cyc_i => wb_cyc_i,
	      aux_i => aux_i,
	      ext_pad_i => ext_pad_i,
	      clk_pad_i => clk_pad_i,
	      wb_adr_i => wb_adr_i,
	      wb_dat_i => wb_dat_i,
	      wb_sel_i => wb_sel_i,
	      wb_we_i => wb_we_i,
	      wb_stb_i => wb_stb_i,
	      wb_dat_o => wb_dat_o,
	      wb_ack_o => wb_ack_o,
	      wb_err_o => wb_err_o,
	      wb_inta_o => wb_inta_o,
	      ext_pad_o => ext_pad_o,
	      ext_padoe_o => ext_padoe_o
		 );

clock: process 
begin

wb_clk_i <= '1';
wait for clock_period / 2;

wb_clk_i <= '0';
wait for clock_period / 2;

end process;

stim_proc: process
begin

wb_rst_i <= '1';  ext_pad_i <= "0000000" & x"000004";  clk_pad_i <= '1';  aux_i <= "0000000" & x"000123"; 
wait for 10 ns;

wb_rst_i <= '0';  ext_pad_i <= "0000000" & x"000004";  clk_pad_i <= '1'; aux_i <= "0000000" & x"000123"; 
wait for 30 ns;

clk_pad_i <= '0';
wait for 20 ns;

wb_rst_i <= '1';
wait for 10 ns;

wb_rst_i <= '0';
wait for 30 ns;

wb_adr_i <= "00000001";
wait for 30 ns;

wb_cyc_i <= '1';  wb_stb_i <= '1';
wait for 10 ns;

wb_cyc_i <= '1';  wb_stb_i <= '1';  full_decoding <= '0';  wb_sel_i <= "0111";
wait for 30 ns;

--RGPIO_IN register 
wb_rst_i <= '1';   wb_adr_i <= "00000000"; 
wait for 20 ns;
wb_rst_i <= '0';  in_muxed <= "0000000" & x"000085";  wb_adr_i <= "00000000";
wait for 40 ns;

--RGPIO_OUT register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_out_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000056";  wb_adr_i <= "00000100"; 
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00005600";  wb_adr_i <= "00000100";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00560000";  wb_adr_i <= "00000100";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"56000000";  wb_adr_i <= "00000100";
wait for 30 ns;

--RGPIO_OE register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_oe_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000012";  wb_adr_i <= "00001000";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00001200";  wb_adr_i <= "00001000";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00120000";  wb_adr_i <= "00001000";
wait for 10 ns; 
wb_sel_i <= "0001";  wb_dat_i <= x"12000000";  wb_adr_i <= "00001000";
wait for 30 ns;

--RGPIO_INTE register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_inte_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000023";  wb_adr_i <= "00001100";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00002300";  wb_adr_i <= "00001100";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00230000";  wb_adr_i <= "00001100";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"23000000";  wb_adr_i <= "00001100";
wait for 30 ns;

--RGPIO_PTRIG register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_ptrig_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000011";  wb_adr_i <= "00010000";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00001100";  wb_adr_i <= "00010000";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00110000";  wb_adr_i <= "00010000";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"11000000";  wb_adr_i <= "00010000";
wait for 30 ns;

--RGPIO_AUX register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_aux_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000021";  wb_adr_i <= "00010100";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00002100";  wb_adr_i <= "00010100";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00210000";  wb_adr_i <= "00010100";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"21000000";  wb_adr_i <= "00010100";
wait for 30 ns;

--RGPIO_CTRL register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_ctrl_sel <= '1'; wb_we_i <= '1';   wb_dat_i <= x"00000003";  wb_adr_i <= "00011000";
wait for 30 ns;

--RGPIO_INTS register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_ints_sel <= '1'; wb_we_i <= '1';   wb_dat_i <= x"00000123";  wb_adr_i <= "00011100";
wait for 30 ns;

--RGPIO_ECLK register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_eclk_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000031";  wb_adr_i <= "00100000";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00003100";  wb_adr_i <= "00100000";
wait for 10 ns; 
wb_sel_i <= "0011";  wb_dat_i <= x"00310000";  wb_adr_i <= "00100000";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"31000000";  wb_adr_i <= "00100000";
wait for 30 ns;

--RGPIO_NEC register
wb_rst_i <= '1'; 
wait for 20 ns;
wb_rst_i <= '0'; rgpio_nec_sel <= '1'; wb_we_i <= '1';  wb_sel_i <= "1111";  wb_dat_i <= x"00000042";  wb_adr_i <= "00100100";
wait for 10 ns;
wb_sel_i <= "0111";  wb_dat_i <= x"00004200";  wb_adr_i <= "00100100";
wait for 10 ns;
wb_sel_i <= "0011";  wb_dat_i <= x"00420000";  wb_adr_i <= "00100100";
wait for 10 ns;
wb_sel_i <= "0001";  wb_dat_i <= x"42000000";  wb_adr_i <= "00100100"; 
wait for 10 ns;

end process;

end;

