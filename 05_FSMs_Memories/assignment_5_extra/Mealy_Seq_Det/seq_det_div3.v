module seq_det_div3 (in, clk, rst_n, y, state);

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

input  in, clk, rst_n;
output y;
output [1:0] state;   // current state, so the board can show it on LEDs

reg [1:0] cs, ns;

// State register
always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    cs <= S0;
  else
    cs <= ns;
end

// Next-state logic
always @(in or cs) begin
  case (cs)
    S0: if (in == 0) ns = S0; else ns = S1;
    S1: if (in == 0) ns = S1; else ns = S2;
    S2: if (in == 0) ns = S2; else ns = S3;
    S3: if (in == 0) ns = S0; else ns = S1;
    default: ns = S0;
  endcase
end

// Mealy output
assign y = ((cs == S2) && (in == 1)) ? 1'b1 : 1'b0;

assign state = cs;

endmodule
