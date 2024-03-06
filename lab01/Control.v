module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
);

    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
    
    reg [7:0] ctrl;
    assign {ALUSrc, memtoReg, regWrite, memRead, memWrite, branch, ALUOp} = ctrl;

    always @(*) begin
        case(opcode)
            7'b0110011: ctrl = 8'b00100010; // R-type
            7'b0000011: ctrl = 8'b11110000; // I-type (Load)
            7'b0100011: ctrl = 8'b1x001000; // S-type
            7'b1100011: ctrl = 8'b0x000101; // B-type
            7'b0010011: ctrl = 8'b10100011; // I-type (Arith)
            // 7'b1100111: ctrl = 8'b0x000101; // jalr
            // 7'b1101111: ctrl = 8'b10100010; // jal
            default:    ctrl = 8'bxxxxxxxx;
        endcase
    end

endmodule

