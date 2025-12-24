`timescale 1ns / 1ps

`include "defines.vh"

module data_memory(
    input `MEMORY_ADDR_VEC address,
    input `WORD_VEC data_write,
    input read_write_selector,
    input clk,
    input reset,
    output `WORD_VEC data_read
);

(* ram_style="block", casecade_height=4 *)
reg `WORD_VEC mem [`MEMORY_LENGTH-1:0];

assign data_read = reset ? 0 :
                   read_write_selector == `MEMORY_READ ? mem[address] :
                   data_write;
integer i;
always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < `MEMORY_LENGTH; i = i + 1) begin
            mem[i] <= 0;
        end
    end else if (read_write_selector == `MEMORY_WRITE) begin
        mem[address] <= data_write;
    end
end

endmodule
