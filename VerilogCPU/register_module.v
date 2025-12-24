`timescale 1ns / 1ps

`include "defines.vh"

module register_module(
    input `WORD_VEC instruction,
    input `WORD_VEC data,
    input `WORD_VEC next_pc_value,
    input `INSTRUCTION_TYPE_VEC instruction_type,
    input `OPCODE_VEC opcode,
    input write_enable,
    input clk,
    input reset,
    output `WORD_VEC data1,
    output `WORD_VEC data2,
    output `WORD_VEC pc,
    output `WORD_VEC destination_register_word
);

reg `WORD_VEC regs [`NUM_REGS-1:0];

wire `REG_ADDR_VEC source_register_1 = instruction[(2*`REG_ADDR_WIDTH)-1 -: `REG_ADDR_WIDTH];
wire `REG_ADDR_VEC source_register_2 = instruction[`REG_ADDR_WIDTH-1 -: `REG_ADDR_WIDTH];
wire `REG_ADDR_VEC destination_register = instruction[(3*`REG_ADDR_WIDTH)-1 -: `REG_ADDR_WIDTH];

assign data1 = reset || (instruction_type != `REGISTER_INSTRUCTION) ? 0 : regs[source_register_1];
assign data2 = reset || (instruction_type != `REGISTER_INSTRUCTION) ? 0 : regs[source_register_2];
assign destination_register_word = regs[destination_register];
assign pc = regs[`PROGRAM_COUNTER];

integer i;
always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < `NUM_REGS; i = i + 1) begin
            regs[i] <= 0;
        end
        regs[`STACK_POINTER] <= `MEMORY_LENGTH - 1;
    end else begin
        if (write_enable == `REG_WRITE_ENABLE && destination_register != `REGISTER_0) begin
            regs[destination_register] <= data;
        end
        regs[`PROGRAM_COUNTER] <= next_pc_value;
    end
end

endmodule
