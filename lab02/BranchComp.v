module BranchComp (
    input [1:0] sel,
    input zero,brlt,
    output reg out
);

    always @(*) begin
        if(sel == 2'b00) out = zero;
        else if(sel == 2'b01) out = ~zero;
        else if(sel == 2'b10) out = brlt;
        else out = ~brlt;
    end
    
endmodule

