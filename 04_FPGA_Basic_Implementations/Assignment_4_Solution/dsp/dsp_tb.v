module dsp_tb();

    // Testbench signals
    reg [17:0] A, B, D;
    reg [47:0] C;
    reg clk, rst_n;
    wire [47:0] P;
    
    // Instantiate DUT for ADD operation only
    dsp #(.OPERATION("ADD")) dut (
        .A(A),
        .B(B),
        .D(D),
        .C(C),
        .clk(clk),
        .rst_n(rst_n),
        .P(P)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk; 
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        rst_n = 0;

        $display("\n========== DSP48A1 ADD Operation Testbench ==========\n");
        $display("Time\t\tA\tB\tD\tC\t\tP");
        $display("====\t\t==\t==\t==\t==\t\t=====");
        
        // Reset sequence
        @(negedge clk);
        rst_n = 1;
        
        // Test Case 1: Basic ADD operation
        // Expected: P = (D+B)*A + C after pipeline delay
        $display("\n--- Test Case 1: Basic ADD operation ---");
        A = 18'd5;
        B = 18'd3;
        D = 18'd2;
        C = 48'd100;
        #50; // Wait for pipeline
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        // Test Case 2: Different values
        $display("\n--- Test Case 2: Different values ---");
        A = 18'd10;
        B = 18'd4;
        D = 18'd8;
        C = 48'd50;
        #50;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        // Test Case 3: Zero inputs
        $display("\n--- Test Case 3: Zero inputs ---");
        A = 18'd0;
        B = 18'd0;
        D = 18'd0;
        C = 48'd0;
        #50;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        // Test Case 4: Large values
        $display("\n--- Test Case 4: Large values ---");
        A = 18'd1000;
        B = 18'd2000;
        D = 18'd3000;
        C = 48'd5000;
        #50;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        // Test Case 5: Maximum values
        $display("\n--- Test Case 5: Maximum values (hex) ---");
        A = 18'h3FFFF; // Max 18-bit
        B = 18'h3FFFF;
        D = 18'h3FFFF;
        C = 48'hFFFFFFFFFFFF; // Max 48-bit
        #50;
        $display("%0t\t%h\t%h\t%h\t%h\t%h", 
                 $time, A, B, D, C, P);
        
        // Test Case 6: Reset during operation
        $display("\n--- Test Case 6: Reset during operation ---");
        A = 18'd100;
        B = 18'd200;
        D = 18'd300;
        C = 48'd400;
        #20;
        rst_n = 0;
        #20;
        $display("%0t\tRESET APPLIED - P=%0d", $time, P);
        rst_n = 1;
        #50;
        $display("%0t\tAFTER RESET   - P=%0d", $time, P);
        
        // Test Case 7: Pipeline verification
        $display("\n--- Test Case 7: Pipeline verification ---");
        A = 18'd7;
        B = 18'd6;
        D = 18'd5;
        C = 48'd4;
        #50;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        // Test Case 8: Only C value
        $display("\n--- Test Case 8: Only C value (A=1, B=0, D=0) ---");
        A = 18'd1;
        B = 18'd0;
        D = 18'd0;
        C = 48'd12345;
        #50;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t\t%0d", 
                 $time, A, B, D, C, P);
        
        #100;
        $display("\n========== Testbench Completed Successfully! ==========\n");
        $stop;
    end
    
endmodule