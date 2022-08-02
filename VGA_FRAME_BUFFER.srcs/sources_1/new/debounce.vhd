----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2022 02:21:12 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
   Port(
   btn: in std_logic;
   clk: in std_logic;
   debounced_btn: out std_logic
   );
end debounce;

architecture Behavioral of debounce is
   constant clock_divide_delay: integer := 1000;
   signal sample: std_logic_vector (9 downto 0) := "1010101010";
   signal sample_pulse: std_logic := '0';
begin
   
   clk_divider: process (clk)
   variable count: integer :=0;
   begin
      if rising_edge(clk) then 
         if count < clock_divide_delay then 
            sample_pulse <= '0';
            count := count + 1;
         else
            count := 0;
            sample_pulse <= '1';
         end if;
      end if;
   end process;
   
   sample_process: process (clk)
   begin
      if rising_edge(clk)then
         if sample_pulse = '1' then 
            sample(9 downto 1)<= sample(8 downto 0);
            sample(0) <= btn;
         else null;
         end if;
      end if;
   end process; 
   
   output_process: process(clk)
   variable flag: std_logic := '0';
   begin
      if rising_edge(clk) then 
         if sample = "1111111111" then 
            if flag = '0' then 
               debounced_btn <= '1';
               flag := '1';
            else null;
            end if; 
         else
            debounced_btn <= '0';
            flag := '0';
         end if; 
      end if;
   end process;

end Behavioral;
