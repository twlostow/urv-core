-- 
-- DSI Shield
-- Copyright (C) 2013-2014 twl <twlostow@printf.cc>
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 3 of the License, or (at your option) any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
-- 

--
-- rev1_top.vhd - top level for rev 1.1. PCB FPGA
--
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gencores_pkg.all;
use work.wishbone_pkg.all;

library unisim;
use unisim.vcomponents.all;



entity spec_top is
  generic (
    g_riscv_firmware : string  := "uart-bootloader.ram";
    g_riscv_mem_size : integer := 65536;
    g_simulation : boolean := false
    );
  port (
    button1_n_i: in std_logic := '1';
    
    clk_125m_pllref_p_i : in std_logic;  -- 125 MHz PLL reference
    clk_125m_pllref_n_i : in std_logic;

    uart_txd_o : out std_logic;
    uart_rxd_i : in  std_logic;


    leds_o: out std_logic_vector(3 downto 0)
    );

end spec_top;

architecture rtl of spec_top is

  component reset_gen
    port (
      clk_sys_i        : in  std_logic;
      rst_pcie_n_a_i   : in  std_logic;
      rst_button_n_a_i : in  std_logic;
      rst_n_o          : out std_logic);
  end component;

  component xrv_core is
    generic (
      g_internal_ram_size      : integer;
      g_internal_ram_init_file : string;
      g_simulation : boolean;
      g_address_bits           : integer;
      g_wishbone_start         : unsigned(31 downto 0));
    port (
      clk_sys_i    : in  std_logic;
      rst_n_i      : in  std_logic;
      cpu_rst_i    : in  std_logic                    := '0';
      irq_i        : in  std_logic_vector(7 downto 0) := x"00";
      dwb_o        : out t_wishbone_master_out;
      dwb_i        : in  t_wishbone_master_in;
      host_slave_i : in  t_wishbone_slave_in          := cc_dummy_slave_in;
      host_slave_o : out t_wishbone_slave_out);
  end component xrv_core;

  constant c_cnx_slave_ports  : integer := 1;
  constant c_cnx_master_ports : integer := 2;

  constant c_master_cpu : integer := 0;

  constant c_slave_gpio     : integer := 0;
  constant c_slave_uart      : integer := 1;

  signal cnx_slave_in  : t_wishbone_slave_in_array(c_cnx_slave_ports-1 downto 0);
  signal cnx_slave_out : t_wishbone_slave_out_array(c_cnx_slave_ports-1 downto 0);

  signal cnx_master_in  : t_wishbone_master_in_array(c_cnx_master_ports-1 downto 0);
  signal cnx_master_out : t_wishbone_master_out_array(c_cnx_master_ports-1 downto 0);

  constant c_cfg_base_addr : t_wishbone_address_array(c_cnx_master_ports-1 downto 0) :=
    (c_slave_gpio => x"80001000",                  -- GPIO
     c_slave_uart => x"80000000");                 -- UART


 
  constant c_cfg_base_mask : t_wishbone_address_array(c_cnx_master_ports-1 downto 0) :=
    (c_slave_gpio => x"8000f000",
     c_slave_uart => x"8000f000" );

  signal clk_125m_pllref : std_logic;
  signal pllout_clk_fb_pllref, pllout_clk_sys, clk_sys, sys_locked, sys_locked_n : std_logic;
  signal rst_n_sys, rst_sys : std_logic;

  signal dummy, gpio_out, gpio_in, gpio_oen : std_logic_vector(31 downto 0);
begin  -- rtl


 U_Buf_CLK_PLL : IBUFGDS
    generic map
    (DIFF_TERM    => true,
     IBUF_LOW_PWR => true)  -- Low power (TRUE) vs. performance (FALSE) setting for referenced
    port map
    (O  => clk_125m_pllref,             -- Buffer output
     I  => clk_125m_pllref_p_i,  -- Diff_p buffer input (connect directly to top-level port)
     IB => clk_125m_pllref_n_i);  -- Diff_n buffer input (connect directly to top-level port)

  

  cmp_sys_clk_pll : PLL_BASE
    generic map
    (BANDWIDTH          => "OPTIMIZED",
     CLK_FEEDBACK       => "CLKFBOUT",
     COMPENSATION       => "INTERNAL",
     DIVCLK_DIVIDE      => 1,
     CLKFBOUT_MULT      => 8,
     CLKFBOUT_PHASE     => 0.000,
     CLKOUT0_DIVIDE     => 7,          -- 62.5 MHz
     CLKOUT0_PHASE      => 0.000,
     CLKOUT0_DUTY_CYCLE => 0.500,
     CLKOUT1_DIVIDE     => 8,          -- not used
     CLKOUT1_PHASE      => 0.000,
     CLKOUT1_DUTY_CYCLE => 0.500,
     CLKOUT2_DIVIDE     => 8,
     CLKOUT2_PHASE      => 0.000,
     CLKOUT2_DUTY_CYCLE => 0.500,
     CLKIN_PERIOD       => 8.0,
     REF_JITTER         => 0.016)
    port map
    (CLKFBOUT => pllout_clk_fb_pllref,
     CLKOUT0  => pllout_clk_sys,
     CLKOUT1  => open,
     CLKOUT2  => open,
     CLKOUT3  => open,
     CLKOUT4  => open,
     CLKOUT5  => open,
     LOCKED   => sys_locked,
     RST      => '0',
     CLKFBIN  => pllout_clk_fb_pllref,
     CLKIN    => clk_125m_pllref);

  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  cmp_clk_sys_buf : BUFG
    port map
    (O => clk_sys,
     I => pllout_clk_sys);      

  rst_sys <= not rst_n_sys;
  sys_locked_n <= not sys_locked;
  
  U_Reset_Gen : reset_gen
    port map (
      clk_sys_i        => clk_sys,
      rst_pcie_n_a_i   => sys_locked,
      rst_button_n_a_i => button1_n_i,
      rst_n_o          => rst_n_sys);


 U_CPU: xrv_core
   generic map (
     g_internal_ram_size      => g_riscv_mem_size,
     g_internal_ram_init_file => g_riscv_firmware,
     g_simulation => g_simulation,
     g_address_bits           => 32,
     g_wishbone_start         => x"00020000")
   port map (
     clk_sys_i    => clk_sys,
     rst_n_i      => rst_n_sys,
     cpu_rst_i    => '0',
     dwb_o        => cnx_slave_in(0),
     dwb_i        => cnx_slave_out(0));
 
  U_Intercon : xwb_crossbar
    generic map (
      g_num_masters => c_cnx_slave_ports,
      g_num_slaves  => c_cnx_master_ports,
      g_registered  => true,
      g_address     => c_cfg_base_addr,
      g_mask        => c_cfg_base_mask)
    port map (
      clk_sys_i => clk_sys,
      rst_n_i   => rst_n_sys,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out);

  U_UART : xwb_simple_uart
    generic map (
      g_interface_mode      => PIPELINED,
      g_address_granularity => BYTE)
    port map (
      clk_sys_i  => clk_sys,
      rst_n_i    => rst_n_sys,
      slave_i    => cnx_master_out(c_slave_uart),
      slave_o    => cnx_master_in(c_slave_uart),
      uart_rxd_i => uart_rxd_i,
      uart_txd_o => uart_txd_o);
 
 U_GPIO : xwb_gpio_port
    generic map (
      g_interface_mode         => PIPELINED,
      g_address_granularity    => BYTE,
      g_num_pins               => 32,
      -- we don't want a 3-state output
      g_with_builtin_tristates => false)
    port map (
      clk_sys_i  => clk_sys,
      rst_n_i    => rst_n_sys,
      slave_i    => cnx_master_out(c_slave_gpio),
      slave_o    => cnx_master_in(c_slave_gpio),
      gpio_b     => dummy,
      gpio_out_o => gpio_out,
      gpio_in_i  => gpio_in,
      gpio_oen_o => gpio_oen);

   leds_o <= gpio_out(3 downto 0);
 
end rtl;

