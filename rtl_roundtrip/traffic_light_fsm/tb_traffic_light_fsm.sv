`timescale 1ns/1ps

module tb_traffic_light_fsm;

    logic       clk;
    logic       reset;
    logic [1:0] state;
    logic       red;
    logic       yellow;
    logic       green;

    int cycle;

    localparam logic [1:0] RED_STATE    = 2'b00;
    localparam logic [1:0] GREEN_STATE  = 2'b01;
    localparam logic [1:0] YELLOW_STATE = 2'b10;

    traffic_light_fsm dut (
        .clk    (clk),
        .reset  (reset),
        .state  (state),
        .red    (red),
        .yellow (yellow),
        .green  (green)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic check_outputs;
        begin
            if ((red + yellow + green) != 1) begin
                $display("FAIL: cycle=%0d state=%b red=%b yellow=%b green=%b", cycle, state, red, yellow, green);
                $fatal(1);
            end

            case (state)
                RED_STATE:    if (!(red && !yellow && !green)) $fatal(1, "FAIL: incorrect RED outputs");
                GREEN_STATE:  if (!(!red && !yellow && green)) $fatal(1, "FAIL: incorrect GREEN outputs");
                YELLOW_STATE: if (!(!red && yellow && !green)) $fatal(1, "FAIL: incorrect YELLOW outputs");
                default:      $fatal(1, "FAIL: illegal state %b", state);
            endcase
        end
    endtask

    initial begin
        reset = 1'b1;
        cycle = 0;

        repeat (2) @(posedge clk);
        #1;

        if (state !== RED_STATE)
            $fatal(1, "FAIL: reset did not enter RED state");

        check_outputs();
        reset = 1'b0;

        repeat (24) begin
            @(posedge clk);
            #1;
            cycle = cycle + 1;
            check_outputs();
        end

        $display("PASS: Traffic-light FSM completed without errors.");
        $finish;
    end

endmodule
