`define WORD_LENGTH 16
`define IMMEDIATE_LENGTH 8
`define WORD_VEC [`WORD_LENGTH-1:0]
`define MEMORY_LENGTH 256 // Max length is 2**WORD_LENGTH
`define MEMORY_ADDR_LENGTH $clog2(`MEMORY_LENGTH)
`define MEMORY_ADDR_VEC [`MEMORY_ADDR_LENGTH-1:0]

// Registers
`define NUM_REGS 16
`define REG_ADDR_WIDTH $clog2(`NUM_REGS)
`define REG_ADDR_VEC [`REG_ADDR_WIDTH-1:0]
`define REGISTER_0 4'b0000
`define REGISTER_1 4'b0001
`define REGISTER_2 4'b0010
`define REGISTER_3 4'b0011
`define REGISTER_4 4'b0100
`define REGISTER_5 4'b0101
`define REGISTER_6 4'b0110
`define REGISTER_7 4'b0111
`define REGISTER_8 4'b1000
`define REGISTER_9 4'b1001
`define REGISTER_10 4'b1010
`define REGISTER_11 4'b1011
`define REGISTER_12 4'b1100
`define REGISTER_13 4'b1101
`define REGISTER_14 4'b1110
`define REGISTER_15 4'b1111

// Register nicknames
`define ZERO `REGISTER_0
`define STACK_POINTER `REGISTER_13
`define GLOBAL_POINTER `REGISTER_14
`define PROGRAM_COUNTER `REGISTER_15

// Op-Codes
`define OPCODE_VEC [3:0]
`define NOP 4'b0000
`define ADD 4'b0001
`define SUB 4'b0010
`define AND 4'b0011
`define OR 4'b0100
`define NOT 4'b0101
`define MOV 4'b0110
`define LD 4'b0111
`define ST 4'b1000
`define CMP 4'b1001
`define BEQ 4'b1010
`define BNE 4'b1011
`define JMP 4'b1100
`define JR 4'b1101
//`define CALL 4'b1101
//`define RET 4'b1110
`define SLT 4'b1111

// Instruction Type Enum
`define NUM_INSTRUCTION_TYPES 3
`define INSTR_TYPE_WIDTH $clog2(`NUM_INSTRUCTION_TYPES)
`define INSTRUCTION_TYPE_VEC [`INSTR_TYPE_WIDTH-1:0]
`define REGISTER_INSTRUCTION 2'b00
`define IMMEDIATE_INSTRUCTION 2'b01
`define JUMP_INSTRUCTION 2'b10

// DMEM Read/Write Enum
`define MEMORY_READ 1'b0
`define MEMORY_WRITE 1'b1

// Reg[] Write Enable
`define REG_WRITE_DISABLE 1'b0
`define REG_WRITE_ENABLE 1'b1
