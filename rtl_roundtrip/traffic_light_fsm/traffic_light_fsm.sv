module traffic_light_fsm (
    input  logic       clk,
    input  logic       reset,
    output logic [1:0] state,
    output logic       red,
    output logic       yellow,
    output logic       green
);

    typedef enum logic [1:0] {
        RED_STATE    = 2'b00,
        GREEN_STATE  = 2'b01,
        YELLOW_STATE = 2'b10
    } state_t;

    state_t current_state;
    state_t next_state;
    logic [2:0] timer;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RED_STATE;
            timer         <= 3'd0;
        end else begin
            current_state <= next_state;
            if (current_state != next_state)
                timer <= 3'd0;
            else
                timer <= timer + 3'd1;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            RED_STATE: begin
                if (timer == 3'd2)
                    next_state = GREEN_STATE;
            end
            GREEN_STATE: begin
                if (timer == 3'd3)
                    next_state = YELLOW_STATE;
            end
            YELLOW_STATE: begin
                if (timer == 3'd1)
                    next_state = RED_STATE;
            end
            default: begin
                next_state = RED_STATE;
            end
        endcase
    end

    always_comb begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;

        case (current_state)
            RED_STATE:    red    = 1'b1;
            GREEN_STATE:  green  = 1'b1;
            YELLOW_STATE: yellow = 1'b1;
            default:      red    = 1'b1;
        endcase
    end

    assign state = current_state;

endmodule
