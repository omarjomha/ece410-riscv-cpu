----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2026 12:49:25 PM
-- Design Name: 
-- Module Name: single_cycle_controller_tb - Behavioral
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

entity single_cycle_controller_tb is
end single_cycle_controller_tb;

architecture Behavioral of single_cycle_controller_tb is
        signal op_code    : STD_LOGIC_VECTOR(6 DOWNTO 0);
        signal funct3    : STD_LOGIC_VECTOR(2 DOWNTO 0);
        signal funct7_bit5    : STD_LOGIC;
        signal zero_flag : STD_LOGIC;
        signal alu_sel   : STD_LOGIC;
        signal res_sel   : STD_LOGIC;
        signal write_en   : STD_LOGIC;
        signal rd_we   : STD_LOGIC;
        signal out_en   : STD_LOGIC;
        signal imm_sel    : STD_LOGIC_VECTOR(2 DOWNTO 0);
        signal alu_ctrl   : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
    uut : entity work.controller port map (
        op_code     => op_code,
        funct3      => funct3,
        funct7_bit5 => funct7_bit5,
        zero_flag   => zero_flag,
        alu_sel     => alu_sel,
        res_sel     => res_sel,
        write_en    => write_en,
        rd_we       => rd_we,
        out_en      => out_en,
        imm_sel     => imm_sel,
        alu_ctrl    => alu_ctrl
    );

    -- expected outputs listed as: alu_sel res_sel rd_we write_en imm_sel alu_ctrl
    stim : process is begin
        zero_flag <= '0';

        -- lw x11, 4(x10)    -> 1 1 1 0 010 100
        op_code     <= "0000011";
        funct3      <= "010";
        funct7_bit5 <= '0';
        wait for 5 ns;

        -- sw x11, 8(x10)    -> 1 1 0 1 011 100
        op_code     <= "0100011";
        funct3      <= "010";
        funct7_bit5 <= '0';
        wait for 5 ns;

        -- add x13, x12, x11 -> 0 0 1 0 011 100
        op_code     <= "0110011";
        funct3      <= "000";
        funct7_bit5 <= '0';
        wait for 5 ns;

        -- sub (R-type, funct7 bit 5 = 1), not implemented yet -> all 0
        op_code     <= "0110011";
        funct3      <= "000";
        funct7_bit5 <= '1';
        wait for 5 ns;

        -- R-type with other funct3 (e.g. and), not implemented yet -> all 0
        op_code     <= "0110011";
        funct3      <= "111";
        funct7_bit5 <= '0';
        wait for 5 ns;

        -- unknown opcode -> NOP, all 0
        op_code     <= "1111111";
        funct3      <= "000";
        funct7_bit5 <= '0';
        wait for 5 ns;

        wait; -- stop after one pass
    end process stim;

end Behavioral;
