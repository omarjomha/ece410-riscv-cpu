------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : single_cycle_datapath_tb.vhdl
-- Authors     : Noah Johnson
-- Date        : 2026-11-12
------------------------------------------------------------------------
-- Description  : Testbench for the datapath.
------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lw_sw_datapath_tb IS
END ENTITY;

ARCHITECTURE tb OF lw_sw_datapath_tb IS

    -- Inputs
    SIGNAL clock       : STD_LOGIC := '0';
    SIGNAL write_en    : STD_LOGIC := '0';  
    SIGNAL rd_we       : STD_LOGIC := '0';  
    SIGNAL alu_sel     : STD_LOGIC := '0';
    SIGNAL res_sel     : STD_LOGIC := '0';  
    SIGNAL out_en      : STD_LOGIC := '0';  
    SIGNAL imm_sel     : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL alu_ctrl    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

    -- Outputs
    SIGNAL opcode      : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL funct3      : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL funct7_bit5 : STD_LOGIC;
    SIGNAL zero_flag   : STD_LOGIC;
    SIGNAL out_data    : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    DUT : ENTITY work.lw_sw_datapath(structural)
        PORT MAP (
            clock       => clock,
            write_en    => write_en,
            rd_we       => rd_we,
            alu_sel     => alu_sel,
            res_sel     => res_sel,
            out_en      => out_en,
            imm_sel     => imm_sel,
            alu_ctrl    => alu_ctrl,
            opcode      => opcode,
            funct3      => funct3,
            funct7_bit5 => funct7_bit5,
            zero_flag   => zero_flag,
            out_data    => out_data
        );

    clock_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR 5 ns;

        clock <= '1';
        WAIT FOR 5 ns;
    END PROCESS;

    test_process : PROCESS
    BEGIN

        out_en <= '1';
        alu_ctrl <= "100"; -- All four instructions use addition in the ALU

        -- Test 1: LW x11, 4(x10)
        -- Load value from mem address (x10 + 4) into reg x11
        -- x10 initialized to 0 in register_file
        -- Memory Address 4: 0x12345678 from data_memory
        -- Therefore expected output is 0x12345678
        
        write_en <= '0';    -- disable writing to data memory
        rd_we    <= '1';    -- enable writing to register file
        alu_sel  <= '1';    -- use immediate as ALU's second input
        res_sel  <= '1';    -- select data memory output
        imm_sel  <= "010";  -- I-type for lw instruction

        WAIT FOR 1 ns;
        ASSERT opcode = "0000011"
            REPORT "TEST 1 FAILED: Expected LW opcode"
            SEVERITY ERROR;
        ASSERT funct3 = "010"
            REPORT "TEST 1 FAILED: Incorrect ADD funct3"
            SEVERITY ERROR;
        ASSERT out_data = x"12345678"
            REPORT "TEST 1 FAILED: Incorrect loaded value"
            SEVERITY ERROR;

        REPORT "TEST 1 PASSED: LW x11, 4(x10)";

        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        -- Test 2: SW x11, 8(x10)
        -- Store value in register x11 at memory address (x10 + 8)
        -- x10 initialized to 0 in register_file
        -- x11 = 0x12345678 after test 1
        -- Therefore expected output is 0x12345678 from memory address x18

        write_en <= '1';    -- enable writing to data memory
        rd_we    <= '0';    -- disable writing to register file
        alu_sel  <= '1';    -- use immediate as ALU's second input
        res_sel  <= '0';    -- select ALU result for output
        imm_sel  <= "100";  -- S-type for sw instruction

        WAIT FOR 1 ns;
        ASSERT opcode = "0100011"
            REPORT "TEST 2 FAILED: Expected SW opcode"
            SEVERITY ERROR;
        ASSERT funct3 = "010"
            REPORT "TEST 2 FAILED: Incorrect ADD funct3"
            SEVERITY ERROR;
        ASSERT out_data = x"00000008"
            REPORT "TEST 2 FAILED: Incorrect store address"
            SEVERITY ERROR;

        REPORT "TEST 2 PASSED: SW x11, 8(x10)";

        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        -- Test 3: LW x12, 12(x0)
        -- Load value from mem address (x0 + 12) into reg x11
        -- x0 is always 0 in register_file
        -- Memory Address x12: 0x11111111 from data_memory
        -- Therefore expected output is 0x11111111

        write_en <= '0';    -- disable writing to data memory
        rd_we    <= '1';    -- enable writing to register file
        alu_sel  <= '1';    -- use immediate as ALU's second input
        res_sel  <= '1';    -- select data memory output
        imm_sel  <= "010";  -- I-type for lw instruction

        WAIT FOR 1 ns;
        ASSERT opcode = "0000011"
            REPORT "TEST 3 FAILED: Expected LW opcode"
            SEVERITY ERROR;
        ASSERT funct3 = "010"
            REPORT "TEST 3 FAILED: Incorrect ADD funct3"
            SEVERITY ERROR;
        ASSERT out_data = x"11111111"
            REPORT "TEST 3 FAILED: Incorrect loaded value"
            SEVERITY ERROR;

        REPORT "TEST 3 PASSED: LW x12, 12(x0)";

        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;


        ------------------------------------------------------------
        -- Test 4: ADD x13, x12, x11
        -- Add the values in registers x12 and x11 and store the result in register x13
        -- x12 = 0x11111111
        -- x11 = 0x12345678
        -- Therefore expected output is
        -- x13 = 0x23456789

        write_en <= '0';    -- disable writing to data memory
        rd_we    <= '1';    -- enable writing to register file
        alu_sel  <= '0';    -- use register rs2 as ALU's second input
        res_sel  <= '0';    -- select ALU result
        imm_sel  <= "000";  -- immediate is not used

        WAIT FOR 1 ns;
        ASSERT opcode = "0110011"
            REPORT "TEST 4 FAILED: Expected ADD opcode"
            SEVERITY ERROR;
        ASSERT funct3 = "000"
            REPORT "TEST 4 FAILED: Incorrect ADD funct3"
            SEVERITY ERROR;
        ASSERT out_data = x"23456789"
            REPORT "TEST 4 FAILED: Incorrect ADD result"
            SEVERITY ERROR;

        REPORT "TEST 4 PASSED: ADD x13, x12, x11";

        WAIT UNTIL rising_edge(clock);
        WAIT FOR 1 ns;

        REPORT "ALL FOUR TESTS COMPLETED SUCCESSFULLY";

        WAIT;
    END PROCESS;
END ARCHITECTURE;
