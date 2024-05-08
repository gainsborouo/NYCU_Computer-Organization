module ImmGen (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] inst,
    output reg signed [31:0] imm
);
    // ImmGen generate imm value base opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) begin
        case(opcode)            
            7'b0000011: imm = {{20{inst[31]}}, inst[31:20]}; // I-type (Load)
            7'b0100011: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // S-type
            7'b1100011: imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}; // B-type
            7'b0010011: imm = {{20{inst[31]}}, inst[31:20]}; // I-type (Arith)
            7'b1100111: imm = {{20{inst[31]}}, inst[31:20]}; // jalr
            7'b1101111: imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; // jal
            default:    imm = {32{1'b0}};
        endcase
    end

endmodule

