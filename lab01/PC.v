module PC (
    input clk,
    input rst,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    // TODO: implement your program counter here
    
    always @(posedge clk) begin
        if(rst == 0) pc_o <= pc_o;
        else pc_o <= pc_i;
    end

endmodule

