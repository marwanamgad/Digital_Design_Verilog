module dsp #( parameter OPERATION = "ADD" ) (
    input [17:0] A, B, D,
    input [47:0] C,
    input clk, rst_n,
    output reg [47:0] P
);

reg [17:0] reg_A_stg1, reg_A_stg2, reg_B, reg_D, adder_out_stg1;
reg [47:0] reg_C, mult_out;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      reg_A_stg1 <= 0;
      reg_A_stg2 <= 0;
      reg_B <= 0;
      reg_C <= 0;
      reg_D <= 0;
      adder_out_stg1 <= 0;
      mult_out <= 0; 
      P <= 0;
    end

    else begin
        reg_A_stg1 <= A;
        reg_A_stg2 <= reg_A_stg1;
        reg_B <= B;
        reg_C <= C;
        reg_D <= D;

        

        if(OPERATION == "ADD")begin
          adder_out_stg1 <= reg_D + reg_B;
          P <= mult_out + reg_C;
        end else if (OPERATION == "SUBTRACT") begin
          adder_out_stg1 <= reg_D - reg_B;
          P <= mult_out - reg_C;
        end

        mult_out <= reg_A_stg2 * adder_out_stg1;
           
        end
    end
    
endmodule