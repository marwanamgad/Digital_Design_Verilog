module TDM_MUX_tb ();
reg clk, rst;
reg [1:0] in0, in1, in2, in3;
wire [1:0] out;

reg [1:0] counter;

TDM_MUX DUT(.clk(clk),
            .rst(rst),
            .in0(in0),
            .in1(in1),
            .in2(in2),
            .in3(in3),
            .out(out));

initial begin
    clk = 0;
    forever begin
      #1 clk = ~clk;
    end
end


initial begin
    rst = 1;
    in0 = 0;
    in1 = 0;
    in2 = 0;
    in3 = 0;
    counter = 0;
    @(negedge clk);
    rst = 0;
    if(out != in0) begin
      $display("Async Control Signal Error");
      $stop;
    end

    repeat(100) begin
      in0 = $random;
      in1 = $random;
      in2 = $random;
      in3 = $random;
      counter = counter + 1;
      @(negedge clk);
      
      case (counter)
        0: begin
          if(out != in0) begin
           $display("Normal Operation Error");
            $stop;
          end
        end

        1: begin
          if(out != in1) begin
           $display("Normal Operation Error");
            $stop;
          end
        end

        2: begin
          if(out != in2) begin
           $display("Normal Operation Error");
            $stop;
          end
        end

        3: begin
          if(out != in3) begin
           $display("Normal Operation Error");
           $stop;
          end
        end
      endcase
    end
$stop;
end
    
endmodule