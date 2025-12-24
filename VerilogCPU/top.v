`timescale 1ns / 1ps

`include "defines.vh"

module cpu_top(
    input clk,
    input reset,
    output done
);

function `INSTRUCTION_TYPE_VEC get_instruction_type;
    input `OPCODE_VEC opcode_in;
begin
    case (opcode_in)
        `ADD,`SUB,`AND,`OR,`NOT,`CMP,`SLT,`JR,`LD,`ST: begin
            get_instruction_type = `REGISTER_INSTRUCTION;
        end
        `BEQ,`BNE,`MOV: begin
            get_instruction_type = `IMMEDIATE_INSTRUCTION;
        end
        `NOP,`JMP: begin
            get_instruction_type =`JUMP_INSTRUCTION;
        end
    endcase
end
endfunction

wire `WORD_VEC instruction;
wire `OPCODE_VEC opcode = instruction[15:12];
wire `INSTRUCTION_TYPE_VEC instruction_type = get_instruction_type(opcode);

wire reg_write_enable = ~(instruction_type == `JUMP_INSTRUCTION || opcode == `ST);
wire `WORD_VEC data1, data2, alu_result, pc, destination_register_word, data_read;

wire zero_flag, is_less_than;
wire `WORD_VEC reg_arr_data_write = opcode == `LD ? data_read : 
                                    opcode == `SLT ? {{(`WORD_LENGTH-1){1'b0}}, is_less_than} :
                                    alu_result;
wire `WORD_VEC next_pc_value = (opcode == `JMP) || (zero_flag && opcode == `BEQ) || (~zero_flag && opcode == `BNE) ? {4'b0000, instruction[11:0]} :
                                opcode == `JR ? data2 :
                                pc + 1;

register_module REG_ARR (
    .instruction(instruction),
    .data(reg_arr_data_write),
    .write_enable(reg_write_enable),
    .instruction_type(instruction_type),
    .opcode(opcode),
    .next_pc_value(next_pc_value),
    .clk(clk),
    .reset(reset),
    .data1(data1),
    .data2(data2),
    .pc(pc),
    .destination_register_word(destination_register_word)
);

wire `WORD_VEC immediate = {{(`WORD_LENGTH-`IMMEDIATE_LENGTH){1'b0}}, instruction[7:0]};
wire `WORD_VEC alu_b = instruction_type == `IMMEDIATE_INSTRUCTION ? immediate : data2; 
alu ALU (
    .A(data1),
    .B(alu_b),
    .opcode(opcode),
    .reset(reset),
    .result(alu_result)
);

branch_comparator BCOMP (
    .data1(data1),
    .data2(data2),
    .opcode(opcode),
    .clk(clk),
    .reset(reset),
    .zero(zero_flag),
    .is_less_than(is_less_than)
);

wire `MEMORY_ADDR_VEC dmem_address = data2;
wire dmem_read_write_selector = opcode == `ST ? `MEMORY_WRITE : `MEMORY_READ;
data_memory DMEM (
    .address(dmem_address),
    .data_write(destination_register_word),
    .read_write_selector(dmem_read_write_selector),
    .clk(clk),
    .reset(reset),
    .data_read(data_read)
);

instruction_memory IMEM (
    .address(pc),
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .done(done)
);

endmodule
