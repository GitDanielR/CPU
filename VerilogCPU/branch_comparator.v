`timescale 1ns / 1ps

`include "defines.vh"

module branch_comparator(
    input `WORD_VEC data1,
    input `WORD_VEC data2,
    input `OPCODE_VEC opcode,
    input clk,
    input reset,
    output reg zero,
    output is_less_than
);

assign is_less_than = reset ? 0 : (data1 < data2);
always @ (posedge clk) begin
    if (reset) begin
        zero <= 0;
    end else if (opcode == `CMP) begin
        zero <= (data1 == data2);
    end
end

endmodule
