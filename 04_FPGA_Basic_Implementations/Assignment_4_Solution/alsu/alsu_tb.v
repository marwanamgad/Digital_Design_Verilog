module alsu_tb ();
reg clk, rst, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B;
reg [2:0] A, B, opcode;
wire [15:0] leds;
wire [5:0] out;

alsu DUT (
    .clk(clk),
    .rst(rst),
    .cin(cin),
    .serial_in(serial_in),
    .direction(direction),
    .red_op_A(red_op_A),
    .red_op_B(red_op_B),
    .bypass_A(bypass_A),
    .bypass_B(bypass_B),
    .A(A),
    .B(B),
    .opcode(opcode),
    .leds(leds),
    .out(out)
);

//Clock Generation
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
//Test reset Functionality
  rst = 1;
  A = 0;
  B = 0;
  opcode = 0;
  cin = 0;
  serial_in = 0;
  red_op_A = 0;
  red_op_B = 0;
  bypass_A = 0;
  bypass_B = 0;
  direction = 0;

  @(negedge clk);

  if (out != 0 || leds != 0) begin
    $display("Aysnc Reset Error");
    $stop;
  end



//Test Bypass Functionality 
  rst = 0;
  bypass_A = 1;
  bypass_B = 1;
  
  repeat(10) begin
      A = $random;
      B = $random;
      opcode = $urandom_range(5,0);

      repeat(2)@(negedge clk);

      if (out != A || leds != 0) begin
        $display("Bypass Error");
        $stop;
      end
  end



// Test Opcode 0 (AND)
 bypass_A = 0;
 bypass_B = 0;
 opcode = 0;

repeat(10) begin
    A = $random;
    B = $random;
    red_op_A = $random;
    red_op_B = $random;

    repeat (2) @(negedge clk);

    case ({red_op_A,red_op_B})
        2'b00: begin
          if(out != (A & B)) begin
            $display("Error: bitwise operation for opcode 0");
            $stop;
          end
        end

          2'b01: begin
          if(out != (&B)) begin
            $display("Error for B: Reduction operation for opcode 0");
            $stop;
          end
        end

          2'b10: begin
          if(out != (&A)) begin
            $display("Error for A: Reduction operation for opcode 0");
            $stop;
          end
        end 
    endcase
end


// Test Opcode 1 (XOR)
 opcode = 1;

repeat(10) begin
    A = $random;
    B = $random;
    red_op_A = $random;
    red_op_B = $random;

    repeat (2) @(negedge clk);

    case ({red_op_A,red_op_B})
        2'b00: begin
          if(out != (A ^ B)) begin
            $display("Error: bitwise operation for opcode 1");
            $stop;
          end
        end

          2'b01: begin
          if(out != (^B)) begin
            $display("Error for B: Reduction operation for opcode 1");
            $stop;
          end
        end

          2'b10: begin
          if(out != (^A)) begin
            $display("Error for A: Reduction operation for opcode 1");
            $stop;
          end
        end 
    endcase
end


// Test Opcode 2 (Addition)
 opcode = 2;
 red_op_A = 0;
 red_op_B = 0;

repeat(10) begin
    A = $random;
    B = $random;
    cin = $random;

    repeat (2) @(negedge clk);

    if (out != A + B + cin) begin
        $display("Error: addition operation for opcode 2");
        $stop;
    end
end

// Test Opcode 3 (Multiplication)
 opcode = 3;

repeat(10) begin
    A = $random;
    B = $random;

    repeat (2) @(negedge clk);

     if (out != A * B) begin
        $display("Error: Multiplication operation for opcode 3");
        $stop;
    end
end

// Test Opcode 4 - Shift (Check waveform for output)
 opcode = 4;

repeat(10) begin
    A = $random;
    B = $random;
    serial_in = $random;
    direction = $random;

    repeat (2) @(negedge clk);
end
    

// Test Opcode 5 - Rotate (Check waveform for output)
 opcode = 5;

repeat(10) begin
    A = $random;
    B = $random;
    serial_in = $random;
    direction = $random;

    repeat (2) @(negedge clk);
end

$stop;

end


endmodule