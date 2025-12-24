`timescale 1ns / 1ps

`include "defines.vh"

module alu (
    input `WORD_VEC A,
    input `WORD_VEC B,
    input `OPCODE_VEC opcode,
    input reset,
    output `WORD_VEC result
);

wire `WORD_VEC ALU_Result = (opcode == `ADD || opcode == `MOV) ? A+B :
                            (opcode == `SUB) ? A-B :
                            (opcode == `AND) ? A&B :
                            (opcode == `OR) ? A|B :
                            (opcode == `NOT) ? ~A :
                            0;

assign result = reset ? 0 : ALU_Result;

endmodule
