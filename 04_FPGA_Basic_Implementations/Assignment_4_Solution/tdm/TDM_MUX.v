module TDM_MUX (
    input wire clk,           // Clock signal (100 MHz from FPGA)
    input wire rst,           // Active-high asynchronous reset
    input wire [1:0] in0,     // Input channel 0 (2-bit)
    input wire [1:0] in1,     // Input channel 1 (2-bit)
    input wire [1:0] in2,     // Input channel 2 (2-bit)
    input wire [1:0] in3,     // Input channel 3 (2-bit)
    output reg [1:0] out      // 2-bit output
);

    // Clock divider for FPGA visualization (1 Hz = 1 second per state)
    // For simulation/testbench: comment out the clock divider section
    reg [26:0] clk_divider;
    reg clk_slow;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_divider <= 0;
            clk_slow <= 0;
        end else begin
            if (clk_divider == 27'd49_999_999) begin  // 100MHz / 100M = 1Hz
                clk_divider <= 0;
                clk_slow <= ~clk_slow;
            end else begin
                clk_divider <= clk_divider + 1;
            end
        end
    end

    // Internal 2-bit counter to cycle through inputs
    reg [1:0] counter;

    // Counter logic with asynchronous reset using slow clock
    always @(posedge clk_slow or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1'b1;  // Cycles through 0, 1, 2, 3
        end
    end

    // Multiplexer logic - select input based on counter value
    always @(*) begin
        case (counter)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 2'b00;
        endcase
    end

endmodule