----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2026 12:18:34 PM
-- Design Name: 
-- Module Name: alu_tb - Behavioral
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

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is
    signal src_a     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal src_b     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal alu_ctrl  : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal result    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal zero_flag : STD_LOGIC;
begin
    uut: entity work.alu port map (
        src_a => src_a,
        src_b => src_b,
        alu_ctrl => alu_ctrl,
        result => result,
        zero_flag => zero_flag
    );
    
    stim: process begin
    src_a <= x"0000FFFF";
    src_b <= x"00000001";
    
    alu_ctrl <= "001";  
    wait for 5 ns;
    
    alu_ctrl <= "010";
    wait for 5 ns;

    alu_ctrl <= "011";
    wait for 5 ns;

    alu_ctrl <= "100";
    wait for 5 ns;

    alu_ctrl <= "101";
    wait for 5 ns;

    end process stim;
end Behavioral;
