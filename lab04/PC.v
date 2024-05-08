module PC (
    input clk,
    input rst,
    input stallPC,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);
    
    always @(posedge clk) begin
        if(rst == 1'b0) pc_o <= 32'b0;
        if(~stallPC) pc_o <= pc_i;
    end

endmodule

