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
    output reg jump,
    output reg PCJSrc
);
    
    reg [12:0] ctrl;
    assign {ALUSrc, PCJSrc, memtoReg, regWrite, memRead, memWrite, branch, branchType, jump, ALUOp} = ctrl;

    always @(*) begin
        case(opcode)
            7'b0110011: ctrl = 13'b0_x_00_1_0_0_0_xx_0__10; // R-type
            7'b0000011: ctrl = 13'b1_x_01_1_1_0_0_xx_0__00; // I-type (Load)
            7'b0100011: ctrl = 13'b1_x_00_0_0_1_0_xx_0__00; // S-type
            7'b1100011: case(funct3) // B-type
                3'b000 : ctrl = 13'b0_0_00_0_0_0_1_00_0_01; // beq
                3'b001 : ctrl = 13'b0_0_00_0_0_0_1_01_0_01; // bne
                3'b100 : ctrl = 13'b0_0_00_0_0_0_1_10_0_01; // blt
                3'b101 : ctrl = 13'b0_0_00_0_0_0_1_11_0_01; // bge
                default: ctrl = 13'bx_x_xx_x_x_x_x_xx_x_xx;
            endcase
            7'b0010011: ctrl = 13'b1_x_00_1_0_0_0_xx_0_11; // I-type (Arith)
            7'b1100111: ctrl = 13'b1_1_10_1_x_x_0_xx_1_00; // jalr
            7'b1101111: ctrl = 13'b1_0_11_1_x_x_0_xx_1_00; // jal
            default:    ctrl = 13'bx_x_xx_x_x_x_x_xx_x_xx;
        endcase
    end

endmodule

