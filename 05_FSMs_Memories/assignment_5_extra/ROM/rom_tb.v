module rom_tb();

reg clk, rst;
reg [2:0] addr;
wire [3:0] data;
rom DUT(.clk(clk), .rst(rst), .addr(addr), .data(data));

integer i;
integer errors;

// reference model: one-hot pattern repeating every 4 addresses
function [3:0] rom_ref (input [2:0] a);
    case (a[1:0])
        2'd0:    rom_ref = 4'b0001;
        2'd1:    rom_ref = 4'b0010;
        2'd2:    rom_ref = 4'b0100;
        default: rom_ref = 4'b1000;
    endcase
endfunction

// compare DUT output against the expected value
task check (input [3:0] expected);
    begin
        @(negedge clk);  // wait for the next clock edge
        if (data !== expected) begin
            errors = errors + 1;
            $display("ERROR t=%0t: rst = %b, addr = %d, data = %b, expected = %b",
                     $time, rst, addr, data, expected);
        end
    end
endtask

// clock generation
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

// reset and initial values for inputs
initial begin
    $dumpfile("rom_tb.vcd");
    $dumpvars(0,rom_tb);

    errors = 0;
    rst = 1;
    addr = 3'd0;
    check(4'b0000);          // reset must clear the output
    rst = 0;

    // test randomized input sequence
    for(i = 0; i < 10000; i = i + 1) begin
        addr = $random;
        check(rom_ref(addr));
    end

    // test results
    if (errors == 0)
        $display("TEST PASSED: all %0d checks matched", i + 1);
    else
        $display("TEST FAILED: %0d errors", errors);

    $finish;
end

endmodule