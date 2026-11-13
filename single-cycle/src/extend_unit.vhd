------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : extend_unit.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-11
------------------------------------------------------------------------
-- Description : Extends instruction[31:7] to full 32-bit instruction.
------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity extension_unit is
  Port (din       : in STD_LOGIC_VECTOR(31 DOWNTO 7);
        ctrl      : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        dout      : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end entity;

architecture Behavioral of extension_unit is
    CONSTANT I_type : STD_LOGIC_VECTOR(2 downto 0) := "010";
    CONSTANT U_type : STD_LOGIC_VECTOR(2 downto 0) := "011";
    CONSTANT S_type : STD_LOGIC_VECTOR(2 downto 0) := "100";
    CONSTANT B_type : STD_LOGIC_VECTOR(2 downto 0) := "101";
    CONSTANT J_type : STD_LOGIC_VECTOR(2 downto 0) := "110";
begin

    with ctrl select
        dout <=        
            (31 downto 12 => din(31)) & din(31 DOWNTO 20) when I_type,
            din(31 DOWNTO 12) & x"000" when U_type,
            (31 DOWNTO 12 => din(31)) & din(31 DOWNTO 25) & din(11 DOWNTO 7) when S_type,
            (31 DOWNTO 13 => din(31)) & din(31) & din(7) & din(30 DOWNTO 25) & din(11 DOWNTO 8) & '0' when B_type,
            (31 DOWNTO 21 => din(31)) & din(31) & din(19 DOWNTO 12) & din(20) & din(30 DOWNTO 21) & '0' when J_type,
            (others => '0') when others;            

end Behavioral;
