module PCSec (
    input branch,branchCmp,jump,
    input [1:0] memtoReg,
    output reg [1:0] out
);

    always @(*) begin
        out = 2'b00;
        if(branch == 1'b1) begin
            if(branchCmp == 1'b1) out = 2'b01;
        end
        else if(jump == 1'b1)begin
            if(memtoReg == 2'b10) out = 2'b10; // jalr
            else if(memtoReg == 2'b11) out = 2'b01; // jal
        end
    end

endmodule

