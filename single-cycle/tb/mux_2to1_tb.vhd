------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : mux_2to1_tb.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-11
------------------------------------------------------------------------
-- Description  : 32-bit 2-to-1 multiplexer testbench.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_mux_2to1 IS
END ENTITY;

ARCHITECTURE Behavioral OF tb_mux_2to1 IS

    SIGNAL in0   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in1   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL out_y : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL sel   : STD_LOGIC;

BEGIN

    DUT : ENTITY WORK.mux_2to1
        PORT MAP (in0 => in0, in1 => in1, out_y => out_y, sel => sel);

    PROCESS
    BEGIN

        -- Test 1: Select in0
        in0 <= X"12345678";
        in1 <= X"87654321";
        sel <= '0';
        WAIT FOR 10 ns;

        ASSERT out_y = X"12345678"
            REPORT "Test 1 failed: sel = 0"
            SEVERITY ERROR;

        -- Test 2: Select in1
        sel <= '1';
        WAIT FOR 10 ns;

        ASSERT out_y = X"87654321"
            REPORT "Test 2 failed: sel = 1"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;
END ARCHITECTURE;
