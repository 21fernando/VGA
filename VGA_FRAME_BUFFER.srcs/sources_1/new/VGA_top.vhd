----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/04/2022 02:04:20 PM
-- Design Name: 
-- Module Name: VGA_top - Behavioral
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

entity VGA_top is
  Port (
  clk_100mhz: in std_logic;
  BTNC: in std_logic; --!active high
  VGA_HS, VGA_VS: out std_logic;
  VGA_R_0, VGA_R_1, VGA_R_2, VGA_R_3: out std_logic;
  VGA_G_0, VGA_G_1, VGA_G_2, VGA_G_3: out std_logic;
  VGA_B_0, VGA_B_1, VGA_B_2, VGA_B_3: out std_logic
  );
end VGA_top;

architecture Structual of VGA_top is

    constant c_h_front_porch: integer := 16;
    constant c_h_back_porch: integer := 48;
    constant c_h_sync_pulse: integer := 96;
    constant c_h_display_area: integer := 640;
    
    constant c_v_front_porch: integer := 10;
    constant c_v_back_porch: integer := 33;
    constant c_v_sync_pulse: integer := 2;
    constant c_v_display_area: integer := 480; 
    
    signal clk_25mhz: std_logic;
    signal clk_buff_writer: std_logic;
    
    signal r_h_pos: unsigned (9 downto 0);
    signal r_v_pos: unsigned (9 downto 0);
    signal r_h_sync: std_logic;
    signal r_v_sync: std_logic;
    signal r_video_on: std_logic;
    
    signal r_rst: std_logic;
    signal r_rst_1: std_logic;
    signal r_rst_2: std_logic;
    
    signal r_write_en: std_logic;
    signal r_addra: unsigned(14 downto 0);
    signal r_dina: std_logic_vector(11 downto 0);
    signal r_addrb: unsigned(14 downto 0);
    signal r_doutb: std_logic_vector(11 downto 0);
        
    signal d0_h_sync: std_logic;
    signal d0_v_sync: std_logic;
    signal d0_h_pos: unsigned (9 downto 0);
    signal d0_v_pos: unsigned (9 downto 0);
    signal d0_video_on: std_logic;
    signal d0_rst: std_logic;
    
    signal d1_h_sync: std_logic;
    signal d1_v_sync: std_logic;
    signal d1_h_pos: unsigned (9 downto 0);
    signal d1_v_pos: unsigned (9 downto 0);
    signal d1_video_on: std_logic;
    signal d1_rst: std_logic;
    
    signal d2_h_sync: std_logic;
    signal d2_v_sync: std_logic;
    signal d2_h_pos: unsigned (9 downto 0);
    signal d2_v_pos: unsigned (9 downto 0);
    signal d2_video_on: std_logic;
    signal d2_rst: std_logic;
    
    signal w_wea: std_logic;
    signal w_addra: unsigned (14 downto 0);
    signal w_dina: std_logic_vector (11 downto 0);
    signal r_done_writing: std_logic;
    
    signal debug1: unsigned (14 downto 0);
    signal debug2: unsigned (14 downto 0);
    
    
    component clk_wiz_0
    port
     (-- Clock in ports
      -- Clock out ports
      clk_25mhz          : out    std_logic;
      clk_100mhz          : out    std_logic;
      clk_in1           : in     std_logic
     );
    end component;
    
--    component debounce is
--    Port(
--    btn: in std_logic;
--    clk: in std_logic;
--    debounced_btn: out std_logic
--    );
--    end component;
   
    component blk_mem_gen_0
    port (
    clka : in std_logic;
    ena : in std_logic;
    wea : in std_logic;
    addra : in unsigned(14 DOWNTO 0);
    dina : in std_logic_vector(11 DOWNTO 0);
    clkb : in std_logic;
    enb : in std_logic;
    addrb : in unsigned(14 DOWNTO 0);
    doutb : out std_logic_vector(11 DOWNTO 0)
    );
    end component;
    
    component VGA_framebuffer_writer
    port ( 
    clk_100mhz: in std_logic;
    r_rst: in std_logic;
    wea : out std_logic;
    addra : out unsigned(14 downto 0);
    dina : out std_logic_vector(11 downto 0);
    o_done_writing: out std_logic
    );
    end component;
    
    signal r_v_offset: unsigned (14 downto 0);
    signal r_h_offset: unsigned (14 downto 0);
    
begin

 your_instance_name : clk_wiz_0
    port map ( 
   -- Clock out ports  
    clk_25mhz => clk_25mhz,
    clk_100mhz => clk_buff_writer,
    -- Clock in ports
    clk_in1 => clk_100mhz
  );

    
    --! handling reset 
--    debouncer: debounce
--    port map (
--    btn => BTNC,
--    clk => clk_25mhz,
--    debounced_btn => r_rst
--    );
    
    sim_reset_process: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then
            r_rst_1 <= BTNC;
            r_rst_2 <= BTNC;
        end if;
    end process;
    --! end handling reset
    
    bram: blk_mem_gen_0
    port map(
    clka => clk_25mhz,
    ena => '1',
    wea => '0', --!write
    addra => w_addra,
    dina => w_dina,
    clkb => clk_25mhz,
    enb => '1', --!read
    addrb => r_addrb,
    doutb => r_doutb
    );
    
    buff_writer: VGA_framebuffer_writer
    port map(
    clk_100mhz => clk_25mhz,
    r_rst => r_rst_1,
    wea => w_wea,
    addra => w_addra,
    dina => w_dina,
    o_done_writing => r_done_writing
    );
    
    --! Begin Pipeline Stage 1
    row_col_count: process(clk_25mhz)
    begin  
        if rising_edge(clk_25mhz) then
            if r_rst_1 = '1' then 
                r_h_pos <= (others => '0');
                r_v_pos <= (others => '0');
            elsif r_h_pos = c_h_display_area + c_h_front_porch + c_h_back_porch + c_h_sync_pulse then 
               r_h_pos <= (others => '0');
               if r_v_pos = c_v_display_area + c_v_front_porch + c_v_back_porch + c_v_sync_pulse then 
                  r_v_pos <= (others => '0'); 
               else
                  r_v_pos <= r_v_pos + 1;
               end if;
            else
               r_h_pos <= r_h_pos + 1;
            end if;     
        end if;
    end process;
    
    sync_pulse_process: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz)then 
            if r_rst_2 = '1' then 
                r_h_sync <= '0';
                r_v_sync <= '0';
            else
                if(r_h_pos< c_h_display_area) then 
                    r_h_sync <= '1';
                else 
                    r_h_sync <= '0';
                end if;
                if(r_v_pos < c_v_display_area) then 
                    r_v_sync <= '1';
                else 
                    r_v_sync <= '0';
                end if;
            end if;
        end if;
    end process;
    
    video_on_process: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then 
            if r_rst_2 = '1' then 
                r_video_on <= '0';
            else
                r_video_on <= r_h_sync and r_v_sync;
            end if;
        end if;
    end process;

    --! End Pipeline Stage 1
    --! Begin Pipeline Stage 2
    st_1_to_2_signal_pass_through: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then 
            d0_h_pos <= r_h_pos;
            d0_v_pos <= r_v_pos;
            d0_rst <= r_rst_1;
            d0_h_sync <= r_h_sync;
            d0_v_sync <= r_v_sync;
            d0_video_on <= r_video_on;
        end if;
    end process;

    calc_bram_address: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then 
            if d0_rst = '1' then 
                r_addrb <= (others => '0');
                debug1  <= (others => '0');
                debug2 <= (others => '0');
            else
                r_addrb <=(r_v_pos(9 downto 2) & "0000000") + (r_v_pos(9 downto 2) & "00000") + ("0000000" & r_h_pos(9 downto 2));
                debug1 <= (r_v_pos(9 downto 2) & "0000000") + (r_v_pos(9 downto 2) & "00000");
                debug2 <= "0000000" & r_h_pos(9 downto 2);

            end if;
        end if;
    end process;
    --! End Pipeline Stage 2
    --! Begin Pipeline Stage 3
    st_2_to_3_signal_pass_through: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then 
            d1_h_pos <= d0_h_pos;
            d1_v_pos <= d0_v_pos;
            d1_rst <= d0_rst;
            d1_h_sync <= d0_h_sync;
            d1_v_sync <= d0_v_sync;
            d1_video_on <= d0_video_on;
        end if;
    end process; 
    --! End Pipeline Stage 3
    --! Begin Pipeline Stage 4
    st_3_to_4_signal_pass_through: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then 
            d2_h_pos <= d1_h_pos;
            d2_v_pos <= d1_v_pos;
            d2_rst <= d1_rst;
            d2_h_sync <= d1_h_sync;
            d2_v_sync <= d1_v_sync;
            d2_video_on <= d1_video_on;
        end if;
    end process;
    --! End Pipeline Stage 4
    --! Begin Pipeline Stage 5
    output_process: process(clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then
            VGA_HS <= d1_h_sync;
            VGA_VS <= d1_v_sync;
            if d1_video_on = '1' then 
                VGA_B_0 <= r_doutb(0);
                VGA_B_1 <= r_doutb(1);
                VGA_B_2 <= r_doutb(2);
                VGA_B_3 <= r_doutb(3);
                VGA_G_0 <= r_doutb(4);
                VGA_G_1 <= r_doutb(5);
                VGA_G_2 <= r_doutb(6);
                VGA_G_3 <= r_doutb(7);
                VGA_R_0 <= r_doutb(8);
                VGA_R_1 <= r_doutb(9);
                VGA_R_2 <= r_doutb(10);
                VGA_R_3 <= r_doutb(11);
            else 
                VGA_B_0 <= '0';
                VGA_B_1 <= '0';
                VGA_B_2 <= '0';
                VGA_B_3 <= '0';
                VGA_G_0 <= '0';
                VGA_G_1 <= '0';
                VGA_G_2 <= '0';
                VGA_G_3 <= '0';
                VGA_R_0 <= '0';
                VGA_R_1 <= '0';
                VGA_R_2 <= '0';
                VGA_R_3 <= '0';
            end if; 
        end if;
    end process;
    --! End Pipeline Stage 5
end Structual;
