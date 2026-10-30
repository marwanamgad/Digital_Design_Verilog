`timescale 1ns/1ps

module seq_det_div3_tb;

  reg  clk, rst_n, in;
  wire y;

  seq_det_div3 dut (.in(in), .clk(clk), .rst_n(rst_n), .y(y));

  // 10 ns clock
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("seq_det_div3_tb.vcd");
    $dumpvars(0, seq_det_div3_tb);

    // Reset
    in = 0; rst_n = 0;
    #10 rst_n = 1;

    // Input sequence (changes on falling edge)
    @(negedge clk) in = 0;
    @(negedge clk) in = 1;   // S0 -> S1
    @(negedge clk) in = 0;   // stay S1
    @(negedge clk) in = 1;   // S1 -> S2
    @(negedge clk) in = 0;   // stay S2
    @(negedge clk) in = 1;   // S2 -> S3, y = 1
    @(negedge clk) in = 0;   // S3 -> S0
    @(negedge clk) in = 1;   // S0 -> S1
    @(negedge clk) in = 1;   // S1 -> S2
    @(negedge clk) in = 1;   // S2 -> S3, y = 1
    @(negedge clk) in = 1;   // S3 -> S1
    @(negedge clk) in = 0;

    // Reset in the middle of operation
    @(negedge clk) in = 1;
    #2 rst_n = 0;
    #6 rst_n = 1;

    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 0;

    #30 $finish;
  end

endmodule