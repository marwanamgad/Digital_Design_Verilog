module top_module(
    input clk,
    input rst,
    input [2:0] A, B, opcode,
    input cin, serial_in, direction,
    input red_op_A, red_op_B,
    input bypass_A, bypass_B,
    output [15:0] leds,
    output [7:0] Anode_Activate,
    output [6:0] LED_out
);

    // Internal wires to tap into ALSU signals
    wire [5:0] alsu_out;
    wire invalid;
    
    // ALSU instance
    alsu #(
        .INPUT_PRIORITY("A"),
        .FULL_ADDER("ON")
    ) alsu_inst (
        .A(A),
        .B(B),
        .opcode(opcode),
        .cin(cin),
        .serial_in(serial_in),
        .direction(direction),
        .red_op_A(red_op_A),
        .red_op_B(red_op_B),
        .bypass_A(bypass_A),
        .bypass_B(bypass_B),
        .clk(clk),
        .rst(rst),
        .leds(leds)
    );
    
    // Access internal signals from ALSU using hierarchical reference
    assign alsu_out = alsu_inst.out;
    assign invalid = alsu_inst.invalid;
    
    // Seven-segment display instance
    seven_seg_display_controller display_inst (
        .clk(clk),
        .reset(rst),
        .out(alsu_out),
        .invalid(invalid),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    );

endmodule