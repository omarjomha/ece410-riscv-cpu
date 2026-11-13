------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : data_memory_tb.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-10
------------------------------------------------------------------------
-- Description  : Data memory testbench.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY data_mem_tb IS
END ENTITY;

ARCHITECTURE Behavioral OF data_mem_tb IS

    SIGNAL address    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_en   : STD_LOGIC;
    SIGNAL clock      : STD_LOGIC := '0';

BEGIN

    -- Instantiate data memory
    DUT : ENTITY WORK.data_mem
        PORT MAP (address => address, write_data => write_data, data => data, write_en => write_en, clock => clock);

    -- Clock generation (20 ns period)
    clock <= NOT clock AFTER 10 ns;

    PROCESS
    BEGIN

        -- Test 1: Read initialized memory
        address <= X"00000004";
        write_en <= '0';
        WAIT FOR 5 ns;
        ASSERT data = X"12345678"
            REPORT "Test 1 failed: Initial memory read"
            SEVERITY ERROR;
        address <= X"00000008";
        write_en <= '0';
        WAIT FOR 5 ns;
        ASSERT data = x"DEADBEEF"
            REPORT "Test 1 failed: Initial memory read"
            SEVERITY ERROR;
        address <= X"0000000C";
        write_en <= '0';
        WAIT FOR 5 ns;
        ASSERT data = x"11111111"
            REPORT "Test 1 failed: Initial memory read"
            SEVERITY ERROR;

        -- Test 2: Write and read back 32-bit value
        address <= X"00000010";
        write_en <= '1';
        write_data <= X"AABBCCDD";
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;
        write_en <= '0';
        WAIT FOR 1 ns;
        ASSERT data = X"AABBCCDD"
            REPORT "Test 2 failed: Write/read operation"
            SEVERITY ERROR;

        -- Test 3: Verify write enable
        address <= X"00000010";
        write_en <= '0';
        write_data <= X"FFFFFFFF";
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;
        ASSERT data = X"AABBCCDD"
            REPORT "Test 4 failed: Write enable"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;
END ARCHITECTURE;
