module vending_machine(clk, rstn, Q_in, D_in, dispense, change);
parameter WAIT = 2'b00;
parameter Q_25 = 2'b01;
parameter Q_50 = 2'b10;

input clk, rstn, Q_in, D_in;
output reg dispense, change;

// (* fsm_encoding = "gray" *)
reg [1:0] cs, ns;

//Current state logic
always @(posedge clk or negedge rstn) begin
  if (!rstn)
    cs <= WAIT;
  else
    cs <= ns;  
end

//Next state logic
always @(*) begin
  case (cs)
    WAIT: begin
      if (Q_in)
        ns = Q_25;
      else
        ns = WAIT;
    end

    Q_25: begin
      if (Q_in)
        ns = Q_50;
      else
        ns = Q_25;
    end

    Q_50: begin
      if (Q_in)
        ns = WAIT;
      else
        ns = Q_50;
    end

    default: ns = WAIT;
  endcase
end

always @(*) begin
  if (((cs == WAIT) && (D_in == 1'b1)) || ((cs == Q_50) && (Q_in == 1'b1))) begin
    dispense = 1;
    end
  else begin
    dispense = 0;
  end

  if((cs == WAIT )&& (D_in == 1'b1)) begin
    change = 1;
    end
  else begin
    change = 0;
  end
end
endmodule