module alsu(A, B, opcode, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B, clk, rst, leds);
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    input clk, rst;
    input [2:0] A, B, opcode;
    input cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B;
    output reg [15:0] leds;
    

    reg cin_reg, serial_in_reg, direction_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;
    reg [2:0] A_reg, B_reg, opcode_reg;
    reg [5:0] out; //output is a reg

    wire [3:0] add_out; // new for ip catalog
    wire [5:0] mult_out; // new for ip catalog

    wire invalid_red_op, invalid_opcode, invalid; 

    assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (( opcode_reg[1] | opcode_reg[2]));
    assign invalid_opcode = opcode_reg[2] & opcode_reg[1];
    assign invalid =  invalid_red_op | invalid_opcode;

    // Counter for visible LED blinking (slows down from 100MHz to ~1.5Hz)
    reg [25:0] blink_counter;

    generate
      if(FULL_ADDER == "ON") begin
        c_addsub_0 a1 (
        .A(A_reg),        // input wire [2 : 0] A
        .B(B_reg),        // input wire [2 : 0] B
        .C_IN(cin_reg),  // input wire C_IN
        .S(add_out)        // output wire [2 : 0] S
      );
      end else begin
         c_addsub_0 a1 (
        .A(A_reg),        // input wire [2 : 0] A
        .B(B_reg),        // input wire [2 : 0] B
        .C_IN(0),  // input wire C_IN
        .S(add_out)        // output wire [2 : 0] S
      );
      end
    endgenerate

    mult_gen_0 m1 (
      .A(A_reg),  // input wire [2 : 0] A
      .B(B_reg),  // input wire [2 : 0] B
      .P(mult_out)  // output wire [5 : 0] P
      );

    always @(posedge clk or posedge rst) begin
        if (rst)begin

            A_reg <= 0;
            B_reg <= 0;
            opcode_reg <= 0;
            cin_reg <= 0;
            serial_in_reg <= 0;
            red_op_A_reg <= 0;
            red_op_B_reg <= 0;
            bypass_A_reg <= 0;
            bypass_B_reg <= 0;
            direction_reg <= 0;
        end else begin
            A_reg <= A;
            B_reg <= B;
            opcode_reg <= opcode;
            cin_reg <= cin;
            serial_in_reg <= serial_in;
            red_op_A_reg <= red_op_A;
            red_op_B_reg <= red_op_B;
            bypass_A_reg <= bypass_A;
            bypass_B_reg <= bypass_B;
            direction_reg <= direction;
        end
    end

    // always @(posedge clk or posedge rst) begin
    //     if(rst)begin
    //         leds <= 0;
    //     end else begin
    //         if(invalid)begin
    //             leds <= ~leds;
    //         end else
    //             leds <= 0;
    //     end
    // end

    // Modified LED blinking logic - now visible!
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            leds <= 0;
            blink_counter <= 0;
        end else begin
            if(invalid)begin
                // Increment counter every clock cycle
                blink_counter <= blink_counter + 1;
                // Toggle LEDs when counter reaches maximum (about 1.5 times per second at 100MHz)
                if (blink_counter == 26'd33_554_431) begin  // 2^25 - 1 for ~1.5Hz blink
                    leds <= ~leds;
                    blink_counter <= 0;
                end
            end else begin
                leds <= 0;
                blink_counter <= 0;
            end
        end
    end



    always @(posedge clk or posedge rst) begin
        if(rst)begin
          out <= 0;
        end else begin
          if (bypass_A_reg && bypass_B_reg) begin
            out <= (INPUT_PRIORITY=="A")? A_reg : B_reg;
          end else if (bypass_A_reg) begin
            out <= A_reg;
          end else if (bypass_B_reg) begin
            out <= B_reg;
          end else if (invalid) begin
            out <= 0;
          end else begin
            case (opcode_reg)
                3'b000: begin
                  if (red_op_A_reg && red_op_B_reg) begin
                    out <= (INPUT_PRIORITY=="A")? &A_reg : &B_reg;
                  end else if (red_op_A_reg) begin
                    out <= &A_reg;
                  end else if (red_op_B_reg) begin
                    out <= &B_reg;
                  end else begin
                    out <= A_reg & B_reg;
                  end
                end 


                 3'b001: begin
                  if (red_op_A_reg && red_op_B_reg) begin
                    out <= (INPUT_PRIORITY=="A")? ^A_reg : ^B_reg;
                  end else if (red_op_A_reg) begin
                    out <= ^A_reg;
                  end else if (red_op_B_reg) begin
                    out <= ^B_reg;
                  end else begin
                    out <= A_reg ^ B_reg;
                  end
                end 


                 3'b010: out <= add_out;

                 3'b011: out <=mult_out;
                 3'b100: begin 
                        if (direction_reg == 1) begin
                            out <= {out[4:0],serial_in_reg};
                        end else begin
                            out <= {serial_in_reg,out[5:1]};
                        end
                    end
                3'b101: begin 
                        if (direction_reg == 0) begin
                            out <= {out[4:0],out[5]};
                        end else begin
                            out <= {out[0],out[5:1]};
                        end
                    end

            endcase
        end       
    end
end
endmodule