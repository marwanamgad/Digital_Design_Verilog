module fsm_010( clk, rst, x, y, count);
    parameter IDLE  = 2'b00;
    parameter ZERO  = 2'b01;
    parameter ONE   = 2'b10;
    parameter STORE = 2'b11;

    input clk, rst, x;
    output reg y;
    output reg [9:0] count;

    (* fsm_encoding = "sequential" *)
    reg [1:0] cs, ns; // cs: current state, ns: next state

    // State Memory
    always @(posedge clk or posedge rst) begin
        if (rst)
            cs <= IDLE;
        else
            cs <= ns;
    end

    // Next State Logic
    always @(cs, x) begin
        case (cs)
            IDLE:
                if (x)
                    ns = IDLE;
                else
                    ns = ZERO;
            ZERO:
                if (x)
                    ns = ONE;
                else
                    ns = ZERO;
            ONE:
                if (x)
                    ns = IDLE;
                else
                    ns = STORE;
            STORE:
                if (x)
                    ns = IDLE;
                else
                    ns = ZERO;
            default: ns = IDLE;
        endcase
    end

    // Output Logic (Moore: depends on cs only)
    always @(cs) begin
        if (cs == STORE)
            y = 1'b1;
        else
            y = 1'b0;
    end

    // Detection counter (sequential output)
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 10'd0;
        else if (cs == STORE)
            count <= count + 10'd1;
    end
endmodule