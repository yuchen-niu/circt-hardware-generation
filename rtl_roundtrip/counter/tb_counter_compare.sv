`timescale 1ns/1ps

module tb_counter_compare;

    logic clk;
    logic reset;

    logic [7:0] count_original;
    logic [7:0] count_circt;
    logic [7:0] expected;

    int cycle;

    counter dut_original (
        .clk   (clk),
        .reset (reset),
        .count (count_original)
    );

    counter_circt dut_circt (
        .clk   (clk),
        .reset (reset),
        .count (count_circt)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset    = 1'b1;
        expected = 8'd0;

        repeat (2) @(posedge clk);
        #1;
        reset = 1'b0;

        for (cycle = 1; cycle <= 20; cycle = cycle + 1) begin
            @(posedge clk);
            #1;

            expected = expected + 8'd1;

            if (count_original !== count_circt) begin
                $display("FAIL: cycle=%0d original=%0d circt=%0d", cycle, count_original, count_circt);
                $fatal(1);
            end

            if (count_original !== expected) begin
                $display("FAIL: cycle=%0d expected=%0d actual=%0d", cycle, expected, count_original);
                $fatal(1);
            end
        end

        $display("PASS: Original and CIRCT-generated counters match.");
        $finish;
    end

endmodule
