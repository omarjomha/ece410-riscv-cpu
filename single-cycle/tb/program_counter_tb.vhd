----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2026 03:48:21 PM
-- Design Name: 
-- Module Name: program_counter_tb - Behavioral
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

entity program_counter_tb is
end program_counter_tb;

architecture Behavioral of program_counter_tb is
    signal clock   : STD_LOGIC := '0';
    signal pc_next : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal pc_out  : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    uut : entity work.program_counter port map (
        clock => clock,
        pc_next => pc_next,
        pc_out => pc_out
    );
    
    clk  : process is begin
        clock <= not clock;
        wait for 5 ns;
    end process clk;
        
    stim : process is begin
        pc_next <= x"0000000F";
        wait for 7 ns;
        
        pc_next <= x"0000FFFF";
        wait for 7 ns;
        
        pc_next <= x"FFFF0000";
        wait for 7 ns;
    end process stim;
        
end Behavioral;
