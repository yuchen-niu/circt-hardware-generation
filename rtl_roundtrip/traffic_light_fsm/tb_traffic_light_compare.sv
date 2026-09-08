`timescale 1ns/1ps

module tb_traffic_light_compare;

    logic clk;
    logic reset;

    logic [1:0] state_original;
    logic       red_original;
    logic       yellow_original;
    logic       green_original;

    logic [1:0] state_circt;
    logic       red_circt;
    logic       yellow_circt;
    logic       green_circt;

    int cycle;

    // Original SystemVerilog FSM
    traffic_light_fsm dut_original (
        .clk    (clk),
        .reset  (reset),
        .state  (state_original),
        .red    (red_original),
        .yellow (yellow_original),
        .green  (green_original)
    );

    // CIRCT-generated SystemVerilog FSM
    traffic_light_fsm_circt dut_circt (
        .clk    (clk),
        .reset  (reset),
        .state  (state_circt),
        .red    (red_circt),
        .yellow (yellow_circt),
        .green  (green_circt)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        cycle = 0;

        // Hold asynchronous reset through two rising clock edges.
        repeat (2) @(posedge clk);
        #1;

        // Compare the reset state.
        if (state_original !== state_circt ||
            red_original !== red_circt ||
            yellow_original !== yellow_circt ||
            green_original !== green_circt) begin

            $display("FAIL during reset comparison");
            $display(
                "Original: state=%b red=%b yellow=%b green=%b",
                state_original,
                red_original,
                yellow_original,
                green_original
            );
            $display(
                "CIRCT:    state=%b red=%b yellow=%b green=%b",
                state_circt,
                red_circt,
                yellow_circt,
                green_circt
            );
            $fatal(1);
        end

        reset = 1'b0;

        // Run several complete RED-GREEN-YELLOW cycles.
        for (cycle = 1; cycle <= 36; cycle = cycle + 1) begin
            @(posedge clk);
            #1;

            if (state_original !== state_circt ||
                red_original !== red_circt ||
                yellow_original !== yellow_circt ||
                green_original !== green_circt) begin

                $display("FAIL at cycle %0d", cycle);

                $display(
                    "Original: state=%b red=%b yellow=%b green=%b",
                    state_original,
                    red_original,
                    yellow_original,
                    green_original
                );

                $display(
                    "CIRCT:    state=%b red=%b yellow=%b green=%b",
                    state_circt,
                    red_circt,
                    yellow_circt,
                    green_circt
                );

                $fatal(1);
            end

            // Check that exactly one traffic light is active.
            case ({red_original, yellow_original, green_original})
                3'b100,
                3'b010,
                3'b001: begin
                    // Valid one-hot output.
                end

                default: begin
                    $display(
                        "FAIL: invalid light outputs at cycle %0d: %b%b%b",
                        cycle,
                        red_original,
                        yellow_original,
                        green_original
                    );
                    $fatal(1);
                end
            endcase

            $display(
                "Cycle %0d: original state=%b RGB=%b%b%b | CIRCT state=%b RGB=%b%b%b",
                cycle,
                state_original,
                red_original,
                yellow_original,
                green_original,
                state_circt,
                red_circt,
                yellow_circt,
                green_circt
            );
        end

        $display(
            "PASS: Original and CIRCT-generated traffic-light FSMs match."
        );

        $finish;
    end

endmodule
