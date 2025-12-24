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

//integer file, code;
integer i, num_instructions;
//initial begin
//    for (i = 0; i < `MEMORY_LENGTH; i = i + 1) begin
//        instruction_mem[i] = 0;
//    end
    
//    file = $fopen("instructions.mem", "r");
//    if (file == 0) begin
//        $display("ERROR: Could not open instructions.mem");
//        num_instructions = 0;
//    end else begin
//        code = $fscanf(file, "%h\n", num_instructions);
//        for (i = 0; i < num_instructions; i = i + 1) begin
//            code = $fscanf(file, "%h\n", instruction_mem[i]);
//        end
//    end
//end

always @ (posedge clk) begin
    if (reset) begin
        num_instructions <= 16'h000C;
        instruction_mem[0] <= 16'h6200;
        instruction_mem[1] <= 16'h6301;
        instruction_mem[2] <= 16'h6C01;
        instruction_mem[3] <= 16'h6405;
        instruction_mem[4] <= 16'h904C;
        instruction_mem[5] <= 16'hA00B;
        instruction_mem[6] <= 16'h1623;
        instruction_mem[7] <= 16'h1230;
        instruction_mem[8] <= 16'h1360;
        instruction_mem[9] <= 16'h244C;
        instruction_mem[10] <= 16'hC004;
        instruction_mem[11] <= 16'h0000;
    end
end

assign instruction = reset ? 0 : instruction_mem[address];
assign done = address >= num_instructions;

endmodule
