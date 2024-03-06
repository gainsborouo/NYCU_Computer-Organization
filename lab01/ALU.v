module ALU (
    input [3:0] ALUctl,
    input signed [31:0] A,B,
    output reg signed [31:0] ALUOut,
    output zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not (or you can change the design as you wish)

    // TODO: implement your ALU here
    // Hint: you can use operator to implement

    always @(*) begin
        if(ALUctl == 4'b0000) ALUOut = A & B;
        else if(ALUctl == 4'b0001) ALUOut = A | B;
        else if(ALUctl == 4'b0010) ALUOut = A + B;
        else if(ALUctl == 4'b0110) ALUOut = A - B;
        else if(ALUctl == 4'b0100) begin
            if(A < B) ALUOut = {31'b0, 1'b1};
            else ALUOut = 32'b0;
        end
        else ALUOut = {32{1'bx}};
    end
    
    assign zero = (ALUOut == 32'b0) ? 1'b1 : 1'b0;

endmodule

