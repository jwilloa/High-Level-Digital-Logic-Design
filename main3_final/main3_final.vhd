----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2020 14:04:48
-- Design Name: 
-- Module Name: main3_final - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY main3_final is

    PORT ( --sw   : in  STD_LOGIC_VECTOR (0 downto 0);
           btnU : in  STD_LOGIC;
           btnD : in  STD_LOGIC;
           btnC : in  STD_LOGIC;
           clk  : in  STD_LOGIC; 
           dp   : out STD_LOGIC;
           led0 : out STD_LOGIC;
           led1 : out STD_LOGIC;
           led2 : out STD_LOGIC;
           led3 : out STD_LOGIC;
           an   : out STD_LOGIC_VECTOR (3 downto 0);           
           seg  : out STD_LOGIC_VECTOR (6 downto 0));
END main3_final;

ARCHITECTURE Behavioral of main3_final is

SIGNAL d0, d1, d2, d3             : STD_LOGIC_VECTOR (3 downto 0); -- Signal inputs for seven segment decoder 
SIGNAL dir_four_digits            : STD_LOGIC;                     -- Signal line from 1Hz clock to four digits block 
SIGNAL div_line, deb_line         : STD_LOGIC;                     -- div_line (output signla from one sec clock divider) & deb_line (output signal from D_Latch) 
SIGNAL c01, c02, c03              : STD_LOGIC; 
SIGNAL D_latch, res_sig           : STD_LOGIC;
SIGNAL pos_overflow, neg_overflow : STD_LOGIC;

begin
  
    -- LED output to let user know when certain boundaries are hit
    led0 <= div_line;
    led1 <= neg_overflow;
    led2 <= pos_overflow;
    led3 <= D_latch;

    -- Clock divider for anodes
    clock_divider      : ENTITY work.clock_divider(Behavioral) GENERIC MAP(count_end => 208334) --208334 (1hz)
    PORT MAP (
              clk_in    => clk,
              clock_out => dir_four_digits);

    -- Clock divider for one second count
    clock_divider_1sec : ENTITY work.clock_divider(Behavioral) GENERIC MAP(count_end => 50000000) --1 seconds
    PORT MAP (
              clk_in    => clk,
              clock_out => div_line); --reset => '0',

    -- Clock divider for d_latch
    clock_divider_deb : ENTITY work.clock_divider(Behavioral) GENERIC MAP(count_end => 10000000) -- latch clock
    PORT MAP (
              clk_in    => clk,
              clock_out => deb_line); --reset => '0',

    -- Instantiating d_latch
    latch : ENTITY work.latch(Behavioral)
    PORT MAP (
              D      => btnC,
              clk_in => deb_line,
              qout   => D_latch); --enable => '1',

    -- Instantiating the state machines
    state_0 : ENTITY work.counter GENERIC MAP (width => 4, modulo => 10)
    PORT MAP (
              clk         => clk,
              one_sec_clk => div_line,
              set         => D_latch,
              increase    => '0',
              decrease    => '0',
              reset_in    => res_sig,
              c_in        => '1',
              c_out       => c01,
              reset_out   => OPEN,
              c_up_out    => OPEN,
              c_dwn_out   => OPEN,
              STD_LOGIC_VECTOR(state_driver) => d0
              );

    state_1 : ENTITY work.counter GENERIC MAP (width => 4, modulo => 6)
    PORT MAP (
              clk         => clk,
              one_sec_clk => div_line,
              set         => D_latch,
              increase    => '0',
              decrease    => '0',
              reset_in    => res_sig,
              c_in        => c01,
              c_out       => c02,
              reset_out   => OPEN,
              c_up_out    => OPEN,
              c_dwn_out   => OPEN,
              STD_LOGIC_VECTOR(state_driver) => d1
              );

    state_2 : ENTITY work.counter GENERIC MAP (width => 4, modulo => 10)
    PORT MAP (
              clk         => clk,
              one_sec_clk => div_line,
              set         => D_latch,
              increase    => btnU,
              decrease    => btnD,
              reset_in    => '0',
              reset_out   => res_sig,
              c_in        => c02,
              c_out       => c03,
              c_up_out    => pos_overflow,
              c_dwn_out   => neg_overflow,
              STD_LOGIC_VECTOR(state_driver) => d2
              );

    state_3 : ENTITY work.counter GENERIC MAP (width => 4, modulo => 6)
    PORT MAP (
              clk         => clk,
              one_sec_clk => div_line,
              set         => D_latch,
              increase    => pos_overflow,
              decrease    => neg_overflow,
              reset_in    => '0',
              c_in        => c03,
              reset_out   => OPEN,
              c_out       => OPEN,
              c_up_out    => OPEN,
              c_dwn_out   => OPEN,
              STD_LOGIC_VECTOR(state_driver) => d3
              );

    -- Instantiating the four digits component to decode state digits
    four_digits: ENTITY work.four_digits(Behavioral)
    PORT MAP (
              D3  => d3,
              D2  => d2,
              D1  => d1,
              D0  => d0,
              seg => seg,
              an  => an,
              dp  => dp,
              ck  => dir_four_digits
              );

END Behavioral;