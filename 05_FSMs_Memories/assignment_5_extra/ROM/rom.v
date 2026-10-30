module rom(
    input clk,
    input rst,
    input [2:0] addr,
    output reg [3:0] data
);


    always @(posedge clk or posedge rst) begin
        if (rst)
            data <= 8'd0;
        else begin
            case (addr)
                3'd0: data <= 4'b0001;
                3'd1: data <= 4'b0010;
                3'd2: data <= 4'b0100;
                3'd3: data <= 4'b1000;
                3'd4: data <= 4'b0001;
                3'd5: data <= 4'b0010;
                3'd6: data <= 4'b0100;
                3'd7: data <= 4'b1000;
                default: data <= 4'b1000; // undefined for other addresses
            endcase
        end
    end
    
endmodule