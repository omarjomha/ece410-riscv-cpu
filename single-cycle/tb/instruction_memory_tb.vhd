----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2026 12:49:25 PM
-- Design Name: 
-- Module Name: instruction_memory_tb - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is
    signal address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal data    : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    uut : entity work.instr_mem port map (
        address => address, data => data
    );

    stim : process 
    begin
        for i in 0 to 15 loop
            address <= std_logic_vector(to_unsigned(i, 32));
            wait for 5 ns;
        end loop;
    end process stim;
end Behavioral;
