------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : register_file_tb.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-11
------------------------------------------------------------------------
-- Description  : RISC-V register file testbench.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file_tb IS
END ENTITY;

ARCHITECTURE Behavioral OF register_file_tb IS

    SIGNAL clock    : STD_LOGIC := '0';
    SIGNAL rs1_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rs2_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rd_addr  : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rd_data  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rs1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rs2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rd_we    : STD_LOGIC;

BEGIN

    DUT : ENTITY WORK.register_file
        PORT MAP (clock => clock,
            rs1_addr => rs1_addr,
            rs2_addr => rs2_addr,
            rd_addr  => rd_addr,
            rd_data  => rd_data,
            rs1_data => rs1_data,
            rs2_data => rs2_data,
            rd_we    => rd_we);

    -- Clock
    clock <= NOT clock AFTER 10 ns;

    PROCESS
    BEGIN

        -- Test 1: Write to register x1
        rd_addr <= "00001";
        rd_we <= '1';
        rd_data <= X"12345678";
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        -- Test 2: Read register x1 using both read ports
        rd_we <= '0';
        rs1_addr <= "00001";
        rs2_addr <= "00001";
        WAIT FOR 5 ns;

        ASSERT rs1_data = X"12345678" AND
               rs2_data = X"12345678"
            REPORT "Test 1 or 2 failed"
            SEVERITY ERROR;

        -- Test 3: Write to register x2 and read both registers
        rd_addr <= "00010";
        rd_we <= '1';
        rd_data <= X"ABCDEF12";
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        rd_we <= '0';
        rs1_addr <= "00001";
        rs2_addr <= "00010";
        WAIT FOR 5 ns;

        ASSERT rs1_data = X"12345678" AND
               rs2_data = X"ABCDEF12"
            REPORT "Test 3 failed"
            SEVERITY ERROR;

        -- Test 4: Verify register x0 always remains zero
        rd_addr <= "00000";
        rd_we <= '1';
        rd_data <= X"FFFFFFFF";
        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        rd_we <= '0';
        rs1_addr <= "00000";
        WAIT FOR 5 ns;

        ASSERT rs1_data = X"00000000"
            REPORT "Test 4 failed"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;
END ARCHITECTURE;
