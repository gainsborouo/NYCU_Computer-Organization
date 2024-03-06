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

wire [31:0] INS, PC, PCPlus4, writeData, RD1, RD2, imm, shiftOut, branchAddr, MUXALUOut, MUXPCOut, ALUOut, dataOut;
wire [3:0] ALUCtl;
wire [1:0] ALUOp;
wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite, zero, andOut;

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
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
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

and A1(andOut, branch, zero);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(andOut),
    .s0(PCPlus4),
    .s1(branchAddr),
    .out(MUXPCOut)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(RD2),
    .s1(imm),
    .out(MUXALUOut)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(INS[30]),
    .funct3(INS[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(RD1),
    .B(MUXALUOut),
    .ALUOut(ALUOut),
    .zero(zero)
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

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(dataOut),
    .out(writeData)
);

endmodule
