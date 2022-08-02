----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/18/2022 04:25:37 PM
-- Design Name: 
-- Module Name: VGA_framebuffer_writer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_framebuffer_writer is
    Port ( 
    clk_100mhz: in std_logic;
    r_rst: in std_logic;
    wea : out std_logic;
    addra : out unsigned(14 downto 0);
    dina : out std_logic_vector(11 downto 0);
    o_done_writing: out std_logic
    );
end VGA_framebuffer_writer;

architecture Behavioral of VGA_framebuffer_writer is
    signal r_addra: unsigned(14 downto 0);
    signal m_rst: std_logic;
    signal s_rst: std_logic;
begin

    sync_reset: process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then 
            m_rst <= r_rst; 
            s_rst <= m_rst;
        end if; 
    end process;
    
    counters_process: process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then 
            if r_rst = '1' then 
                r_addra <= (others => '0');
            else
                if r_addra = X"4aff" then 
                    r_addra <= (others => '0');
                else
                    r_addra <= r_addra + 1;
                end if;
            end if;
        end if; 
    end process;
    
    draw_process: process(clk_100mhz)
    begin
        if rising_edge(clk_100mhz) then 
            if r_rst = '1' then 
                wea <= '0';
                addra <= (others => '0');
                dina <= (others => '0');
            else
                wea <= '1';
                addra <= r_addra;
                dina <= std_logic_vector(r_addra (11 downto 0));
--                if r_addra < 30 then 
--                    dina <= "000000001111";
--                elsif r_addra < 60 then 
--                    dina <= "000011110000";
--                elsif r_addra < 90 then 
--                    dina <= "111100000000";
--                else
--                    dina <= "111111111111";
--                end if;
            end if;
        end if; 
    end process;

--    wea <= '0' when s_rst = '1' else '1';
--    addra <= when s_rst = '1' else r_addra;
--    dina <= (others => '0') when s_rst = '1' else std_logic_vector(r_addra (11 downto 0));

end Behavioral;
