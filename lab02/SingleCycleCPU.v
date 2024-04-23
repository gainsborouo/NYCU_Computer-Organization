module SingleCycleCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] INS, PC, PCPlus4, writeData, RD1, RD2, imm, shiftOut, branchAddr, MUXALUAOut, MUXPCOut, MUXALUBOut, ALUOut, dataOut;
wire [3:0] ALUCtl;
wire [1:0] ALUOp, memtoReg, branchType, PCSecOut;
wire branch, memRead, memWrite, ALUSrc, regWrite, zero, brlt, BranchCompOut, jump;

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(MUXPCOut),
    .pc_o(PC)
);

Adder m_Adder_1(
    .a(PC),
    .b(4),
    .sum(PCPlus4)
);

InstructionMemory m_InstMem(
    .readAddr(PC),
    .inst(INS)
);

Control m_Control(
    .opcode(INS[6:0]),
    .funct3(INS[14:12]),
    .branch(branch),
    .branchType(branchType),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .jump(jump),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(INS[19:15]),
    .readReg2(INS[24:20]),
    .writeReg(INS[11:7]),
    .writeData(writeData),
    .readData1(RD1),
    .readData2(RD2)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(INS[31:0]),
    .imm(imm)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(shiftOut)
);

Adder m_Adder_2(
    .a(PC),
    .b(shiftOut),
    .sum(branchAddr)
);

// and A1(andOut, branch, BranchCmpOut);

BranchComp m_BranchComp(
    .sel(branchType),
    .zero(zero),
    .brlt(brlt),
    .out(BranchCompOut)
);

PCSec m_Sec_PC(
    .branch(branch),
    .jump(jump),
    .branchCmp(BranchCompOut),
    .memtoReg(memtoReg),
    .out(PCSecOut)
);

Mux3to1 #(.size(32)) m_Mux_PC(
    .sel(PCSecOut),
    .s0(PCPlus4),
    .s1(branchAddr),
    .s2(ALUOut),
    .out(MUXPCOut)
);

Mux2to1 #(.size(32)) m_Mux_ALU_A(
    .sel((memtoReg > 2'b10)),
    .s0(RD1),
    .s1(PC),
    .out(MUXALUAOut)
);

Mux2to1 #(.size(32)) m_Mux_ALU_B(
    .sel(ALUSrc),
    .s0(RD2),
    .s1(imm),
    .out(MUXALUBOut)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(INS[30]),
    .funct3(INS[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(MUXALUAOut),
    .B(MUXALUBOut),
    .ALUOut(ALUOut),
    .zero(zero),
    .brlt(brlt)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(RD2),
    .readData(dataOut)
);

Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(dataOut),
    .s2(PCPlus4),
    .out(writeData)
);

endmodule
