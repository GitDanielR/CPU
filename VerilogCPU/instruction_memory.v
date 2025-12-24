`timescale 1ns / 1ps

`include "defines.vh"

module instruction_memory(
    input `WORD_VEC address,
    input clk,
    input reset,
    output `WORD_VEC instruction,
    output done
);

(* ram_style="block", casecade_height=4 *)
reg `WORD_VEC instruction_mem [`MEMORY_LENGTH-1:0];

integer file, code;
integer i, num_instructions;
initial begin
    for (i = 0; i < `MEMORY_LENGTH; i = i + 1) begin
        instruction_mem[i] = 0;
    end  

    file = $fopen("instructions.mem", "r");
    if (file == 0) begin
        $display("ERROR: Could not open instructions.mem");
        num_instructions = 0;
    end else begin
        code = $fscanf(file, "%h\n", num_instructions);
        for (i = 0; i < num_instructions; i = i + 1) begin
            code = $fscanf(file, "%h\n", instruction_mem[i]);
        end
    end
end

assign instruction = reset ? 0 : instruction_mem[address];
assign done = address >= num_instructions;

endmodule
