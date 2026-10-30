// Top level for the Nexys 4 DDR
//   SW0        -> in
//   CPU_RESETN -> rst_n (red button, active-low)
//   LED[0]     -> y
//   LED[2:1]   -> current state (00=S0, 01=S1, 10=S2, 11=S3)
//   LED[15]    -> slow clock heartbeat (blinks once per FSM step)

module top (CLK100MHZ, SW0, CPU_RESETN, LED);

  input        CLK100MHZ;
  input        SW0;
  input        CPU_RESETN;
  output [15:0] LED;

  // Clock divider: 100 MHz / 2^26 = about 1.5 Hz
  // (one FSM step roughly every 0.67 s)
  reg [25:0] count = 26'd0;
  always @(posedge CLK100MHZ)
    count <= count + 1'b1;

  wire slow_clk = count[25];

  wire       y;
  wire [1:0] state;

  seq_det_div3 u_fsm (
    .in    (SW0),
    .clk   (slow_clk),
    .rst_n (CPU_RESETN),
    .y     (y),
    .state (state)
  );

  assign LED[0]    = y;
  assign LED[2:1]  = state;
  assign LED[14:3] = 12'b0;
  assign LED[15]   = slow_clk;

endmodule
