------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : adder_32_tb.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-10
------------------------------------------------------------------------
-- Description : 32-bit adder testbench
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_adder_32 IS
END ENTITY;

ARCHITECTURE Behavioral OF tb_adder_32 IS

    SIGNAL op_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL op_b : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL sum  : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate the adder
    DUT : ENTITY WORK.adder_32
        PORT MAP (op_a => op_a, op_b => op_b, sum  => sum);

    PROCESS
    BEGIN
        -- Test 1: 0 + 0
        op_a <= X"00000000";
        op_b <= X"00000000";
        WAIT FOR 10 ns;
        ASSERT sum = X"00000000"
            REPORT "Test 1 failed: Zero + Zero"
            SEVERITY ERROR;

        -- Test 2: 5 + 3
        op_a <= X"00000005";
        op_b <= X"00000003";
        WAIT FOR 10 ns;
        ASSERT sum = X"00000008"
            REPORT "Test 2 failed: 5 + 3"
            SEVERITY ERROR;

        -- Test 3: Carry between bytes
        op_a <= X"000000FF";
        op_b <= X"00000001";
        WAIT FOR 10 ns;
        ASSERT sum = X"00000100"
            REPORT "Test 3 failed: Carry between bytes"
            SEVERITY ERROR;

        -- Test 4: Overflow
        op_a <= X"FFFFFFFF";
        op_b <= X"00000001";
        WAIT FOR 10 ns;
        ASSERT sum = X"00000000"
            REPORT "Test 4 failed: Overflow"
            SEVERITY ERROR;

        -- Test 5: Different bit patterns
        op_a <= X"12345678";
        op_b <= X"87654321";
        WAIT FOR 10 ns;
        ASSERT sum = X"99999999"
            REPORT "Test 5 failed: Different bit patterns"
            SEVERITY ERROR;

        WAIT;

    END PROCESS;

END ARCHITECTURE;
