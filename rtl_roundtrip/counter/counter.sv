module counter (
    input  logic       clk,
    input  logic       reset,
    output logic [7:0] count
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'b0;
        else
            count <= count + 8'd1;
    end

endmodule
