module seq_det_tb;

  reg clk, rst, x;
  wire [2:0] y;
  integer i;

  seq_det_011 dut (.clk(clk), .rst(rst), .x(x), .y(y));

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("seq_det_tb.vcd");
    $dumpvars(0, seq_det_tb);
    $monitor("t=%0t  x=%b  state=%b  y=%b", $time, x, dut.cs, y);

    rst = 1; x = 0;
    #10 rst = 0;

    for (i = 0; i < 50; i = i + 1) begin
      x = $random;
      #10;
    end

    #20 $finish;
  end

endmodule