----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2022 10:26:41 PM
-- Design Name: 
-- Module Name: VGA_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_FRAME_BUFFER_TB is
end VGA_FRAME_BUFFER_TB;

architecture Behavioral of VGA_FRAME_BUFFER_TB is
    component VGA_top
    port(
    clk_100mhz: in std_logic;
    BTNC: in std_logic;
    VGA_HS, VGA_VS: out std_logic;
    VGA_R_0, VGA_R_1, VGA_R_2, VGA_R_3: out std_logic;
    VGA_G_0, VGA_G_1, VGA_G_2, VGA_G_3: out std_logic;
    VGA_B_0, VGA_B_1, VGA_B_2, VGA_B_3: out std_logic
    );
    end component;
    signal clk_100mhz: std_logic;
    signal BTNC: std_logic;
    signal VGA_HS: std_logic;
    signal VGA_VS: std_logic;
    signal VGA_R: std_logic_vector (3 downto 0);
    signal VGA_G: std_logic_vector (3 downto 0);
    signal VGA_B: std_logic_vector (3 downto 0);
    
    constant clk_period: time := 1 ns;
begin

    uut: VGA_top
    port map(
    clk_100mhz => clk_100mhz,
    BTNC => BTNC, 
    VGA_HS => VGA_HS,
    VGA_VS => VGA_VS,
    VGA_R_0 => VGA_R(0),
    VGA_R_1 => VGA_R(1),
    VGA_R_2 => VGA_R(2),
    VGA_R_3 => VGA_R(3),
    VGA_G_0 => VGA_G(0),
    VGA_G_1 => VGA_G(1),
    VGA_G_2 => VGA_G(2),
    VGA_G_3 => VGA_G(3),
    VGA_B_0 => VGA_B(0),
    VGA_B_1 => VGA_B(1),
    VGA_B_2 => VGA_B(2),
    VGA_B_3 => VGA_B(3)
    );

    clk_process: process
    begin
        clk_100mhz <= '0';
        wait for (clk_period/2);
        clk_100mhz <= '1';
        wait for (clk_period/2);
    end process;
    
    test_process: process
    begin
        wait for (clk_period*300);
        BTNC <= '1';
        wait for (clk_period*20);
        BTNC <= '0';
        wait;
    end process;
end Behavioral;
