module crc(
    input serial_in,
    input clk,
    input rstn,
    input valid,
    output reg [3:0] crc_out
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        crc_out <= 4'b0000;
    end else if (valid) begin
        crc_out[3] <= crc_out[2];
        crc_out[2] <= crc_out[1];
        crc_out[1] <= crc_out[0] ^ crc_out[3];
        crc_out[0] <= serial_in  ^ crc_out[3];

        
    end
end
    
endmodule