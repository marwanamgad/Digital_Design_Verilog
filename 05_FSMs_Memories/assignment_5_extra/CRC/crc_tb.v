module crc_tb();

reg serial_in;
reg clk, rstn, valid;
wire [3:0] crc_out;

reg [10:0] test_data;

crc DUT(.serial_in(serial_in), .clk(clk), .rstn(rstn), .valid(valid), .crc_out(crc_out));

integer i;

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end


initial begin
    $dumpfile("crc_tb.vcd");
    $dumpvars(0, crc_tb);

    rstn = 0;
    valid = 0;
    serial_in = 0;
    test_data = 11'b10110010000; // Example test data
    @(negedge clk);
    rstn = 1;

    valid = 1;

    // Send test data serially
    for(i = 10; i >= 0; i = i - 1) begin
        serial_in = test_data[i];
        @(negedge clk);
    end
    valid = 0;

    if (crc_out !== 4'b1010) begin
        $display("Test failed: Expected CRC = 1010, got %b", crc_out);
    end else begin
        $display("Test passed: CRC = %b", crc_out);
    end

    $finish;
end




    
endmodule