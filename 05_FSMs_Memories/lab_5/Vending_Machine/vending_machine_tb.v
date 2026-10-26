module vending_machine_tb();

reg clk, rstn, D_in, Q_in;
wire dispense, change;

vending_machine DUT (.clk(clk), .rstn(rstn), .D_in(D_in), .Q_in(Q_in),
                     .dispense(dispense), .change(change));

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial begin
    $dumpfile("vending_machine_tb.vcd");
    $dumpvars(0, vending_machine_tb);

    rstn = 0;
    Q_in = 0;
    D_in = 0;
    @(negedge clk);
    rstn = 1;

    //Test dollars
    D_in = 1; Q_in = 0;
    repeat(10) @(negedge clk);

    //Test Quarters
    D_in = 0; Q_in = 1;
    repeat(10) @(negedge clk);
    $finish;
end

// Test monitor and Results
initial begin
    $monitor("t=%0t rstn=%b D_in=%b Q_in=%b dispense=%b change=%b",
             $time, rstn, D_in, Q_in, dispense, change);
end

endmodule