module seq_det_011 (clk, rst, x, y); //moore
 parameter A = 2'b00;
 parameter B = 2'b01;
 parameter C = 2'b10;
 parameter D = 2'b11;

input clk, rst, x;
output reg [2:0] y;

reg [1:0] cs, ns;

//State memory
always @(posedge clk or posedge rst) begin
    if (rst)
        cs <= A;
    else
        cs <= ns;
end

//Next state
always @(*) begin
    case (cs)
        A: ns = x ? A : B;
        B: ns = x ? C : B;
        C: ns = x ? D : B;
        D: ns = x ? A : B;
        default: ns = A;
    endcase
end

//Output logic depends on cs only
always @(*) begin
    case (cs)
        A: y = 3'b000;
        B: y = 3'b001;
        C: y = 3'b011;
        D: y = 3'b111;
        default: y = 3'b000;
    endcase
end


endmodule