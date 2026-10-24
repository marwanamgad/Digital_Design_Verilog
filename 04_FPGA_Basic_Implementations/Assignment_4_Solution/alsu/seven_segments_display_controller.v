module seven_seg_display_controller (
    input clk, reset,
    input [5:0] out,           // ALSU output
    input invalid,             // Invalid operation flag
    output reg [7:0] Anode_Activate,
    output reg [6:0] LED_out
);

reg [3:0] LED_BCD;
reg [19:0] refresh_counter;

wire [1:0] LED_activating_counter;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        refresh_counter <= 0;
    end else begin
        refresh_counter <= refresh_counter + 1;
    end
end

assign LED_activating_counter = refresh_counter[19:18];

// Anode activation and digit selection (active LOW for Common Anode)
always @(*) begin
    case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 8'b11111110; // Activate AN0 (rightmost digit)
            if (invalid)
                LED_BCD = 4'b0100; // Display '4' for E404
            else
                LED_BCD = out[3:0]; // Display least significant 4 bits
        end
        2'b01: begin
            Anode_Activate = 8'b11111101; // Activate AN1 (second from right)
            if (invalid)
                LED_BCD = 4'b0000; // Display '0' for E404
            else
                LED_BCD = {2'b00, out[5:4]}; // Display most significant 2 bits
        end
        2'b10: begin
            Anode_Activate = 8'b11111011; // Activate AN2 (second from left)
            if (invalid)
                LED_BCD = 4'b0100; // Display '4' for E404
            else
                LED_BCD = 4'b1111; // Display dash
        end
        2'b11: begin
            Anode_Activate = 8'b11110111; // Activate AN3 (leftmost digit)
            if (invalid)
                LED_BCD = 4'b1110; // Display 'E' for E404
            else
                LED_BCD = 4'b1111; // Display dash
        end
    endcase
end

// Cathode patterns (inverted for Common Anode)
always @(*) begin
    case(LED_BCD)
        4'b0000: LED_out = 7'b1000000; // "0"
        4'b0001: LED_out = 7'b1111001; // "1"
        4'b0010: LED_out = 7'b0100100; // "2"
        4'b0011: LED_out = 7'b0110000; // "3"
        4'b0100: LED_out = 7'b0011001; // "4"
        4'b0101: LED_out = 7'b0010010; // "5"
        4'b0110: LED_out = 7'b0000010; // "6"
        4'b0111: LED_out = 7'b1111000; // "7"
        4'b1000: LED_out = 7'b0000000; // "8"
        4'b1001: LED_out = 7'b0010000; // "9"
        4'b1010: LED_out = 7'b0001000; // "A"
        4'b1011: LED_out = 7'b0000011; // "b"
        4'b1100: LED_out = 7'b1000110; // "C"
        4'b1101: LED_out = 7'b0100001; // "d"
        4'b1110: LED_out = 7'b0000110; // "E"
        4'b1111: LED_out = 7'b0111111; // "-" (dash)
        default: LED_out = 7'b1111111; // All off
    endcase
end

endmodule