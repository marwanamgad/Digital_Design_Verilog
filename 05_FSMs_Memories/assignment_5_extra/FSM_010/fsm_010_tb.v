module fsm_010_tb();

reg clk, rst, x;
wire y;
wire [9:0] count;

fsm_010 DUT(.clk(clk), .rst(rst), .x(x), .y(y), .count(count));

integer i;

// clock generation
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

// reset and initial values for inputs
initial begin
    $dumpfile("fsm_010_tb.vcd");
    $dumpvars(0,fsm_010_tb);
    rst = 1;
    x = 0;
    @(negedge clk);
    rst = 0;

    // test randomized input sequence
    for(i = 0; i < 100; i = i + 1) begin
        x = $random;
        @(negedge clk);
    end

    $finish;
end

// test monitor and results
initial begin
    $monitor("x = %b, rst = %b, y = %b, count = %d", x, rst, y, count);
end

endmodule