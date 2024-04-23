module Control (
    input [6:0] opcode,
    input [2:0] funct3,
    output reg branch,
    output reg [1:0] branchType,
    output reg memRead,
    output reg [1:0] memtoReg, // WBSel 00/01/1x, ASel memtoReg[0]
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite,
    output reg jump
);
    
    reg [11:0] ctrl;
    assign {ALUSrc, memtoReg, regWrite, memRead, memWrite, branch, branchType, jump, ALUOp} = ctrl;

    always @(*) begin
        case(opcode)
            7'b0110011: ctrl = 12'b0001000xx010; // R-type
            7'b0000011: ctrl = 12'b1011100xx000; // I-type (Load)
            7'b0100011: ctrl = 12'b1xx0010xx000; // S-type
            7'b1100011: case(funct3) // B-type
                3'b000 : ctrl = 12'b0xx000100001; // beq
                3'b001 : ctrl = 12'b0xx000101001; // bne
                3'b100 : ctrl = 12'b0xx000110001; // blt
                3'b101 : ctrl = 12'b0xx000111001; // bge
                default: ctrl = 12'bxxxxxxxxxxxx;
            endcase
            7'b0010011: ctrl = 12'b1001000xx011; // I-type (Arith)
            7'b1100111: ctrl = 12'b1101xx0xx100; // jalr
            7'b1101111: ctrl = 12'b1111xx0xx100; // jal
            default:    ctrl = 12'bxxxxxxxxxxxx;
        endcase
    end

endmodule

