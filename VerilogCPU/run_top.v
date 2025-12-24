`timescale 1ns / 1ps

module run_top();

reg clk = 0, reset = 0;
wire done;
cpu_top CPU (
    .clk(clk),
    .reset(reset)
    .done(done)
);

always #5 clk = ~clk;

initial begin
    #5 reset = 1;
    #5 reset = 0;
end

always @ (posedge clk) begin
    if (done) begin
        $finish;
    end
end

endmodule
