------------------------------------------------------------------------
-- University  : University of Alberta
-- Course      : ECE 410
-- Project     : Lab 3
-- File        : single_cycle_controller.vhdl
-- Authors     : Antonio Alejandro Andara Lara
-- Date        : 23-Oct-2025
------------------------------------------------------------------------
-- Description  : Single-cycle control unit for a simple RISC-V processor.
--                Decodes opcode, funct3, and funct7 fields to generate
--                ALU, memory, and register control signals.
------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    PORT (
        op_code    : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        funct3    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        funct7_bit5    : IN STD_LOGIC;
        zero_flag : IN STD_LOGIC;
        alu_sel   : OUT STD_LOGIC;
        res_sel   : OUT STD_LOGIC;
        write_en   : OUT STD_LOGIC;
        rd_we   : OUT STD_LOGIC;
        out_en   : OUT STD_LOGIC;
        imm_sel    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        alu_ctrl   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END controller;

ARCHITECTURE Behavioral OF controller IS
    -- "controls" is a compact control word encoding all the main control signals.
    -- Bit mapping (from MSB to LSB):
    --   [9]   - Selects ALU B operand source (0 = register, 1 = immediate)
    --   [8]   - Selects write-back data source (0 = ALU result, 1 = memory read)
    --   [7]   - Enables register file write
    --   [6]   - Enables data memory write
    --   [5:3] - Selects immediate format depending on the instruction type (I, S, etc.)
    --   [2:0] - ALU control operation code
    --
    -- Each instruction assigns a 10-bit pattern to "controls" that defines its full
    -- control behavior in a single line using the WITH-SELECT statement below.
    SIGNAL controls     : STD_LOGIC_VECTOR(9 DOWNTO 0);

    -- added for visibility in simulation
    TYPE instruction IS (LW, SW, ADD, NOP);
    SIGNAL instr : instruction := NOP;
    SIGNAL aux          : STD_LOGIC_VECTOR(10 DOWNTO 0);

    -- Instruction opcodes. add new values for each instruction
    CONSTANT OPCODE_LW  : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0000011";
    CONSTANT OPCODE_SW  : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0100011";
    CONSTANT OPCODE_ADD : STD_LOGIC_VECTOR(6 DOWNTO 0)  := "0110011";

    -- Control signals per instruction
    CONSTANT CTRL_LW  : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1110010100";
    CONSTANT CTRL_SW  : STD_LOGIC_VECTOR(9 DOWNTO 0) := "1101011100";
    CONSTANT CTRL_ADD : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0010011100";
    CONSTANT CTRL_NOP : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000";

BEGIN
    out_en <= '1';
    aux <= funct7_bit5 & funct3 & op_code;

    decode : PROCESS (op_code, funct3, funct7_bit5)
    BEGIN
        controls <= CTRL_NOP; -- default assignment

        CASE op_code IS
            WHEN OPCODE_LW =>
                instr <= LW;
                controls <= CTRL_LW;
            WHEN OPCODE_SW =>
                instr <= SW;
                controls <= CTRL_SW;
            WHEN OPCODE_ADD =>
                IF funct3 = "000" AND funct7_bit5 = '0' THEN
                    instr <= ADD;
                    controls <= CTRL_ADD;
                END IF;
            WHEN OTHERS =>
                instr <= NOP;
                controls <= CTRL_NOP;
        END CASE;
    END PROCESS;

    -- controller output assignments
    alu_sel <= controls(9);
    res_sel <= controls(8);
    rd_we <= controls(7);
    write_en <= controls(6);
    imm_sel  <= controls(5 DOWNTO 3);
    alu_ctrl <= controls(2 DOWNTO 0);

END Behavioral;
