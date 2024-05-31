module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// IF
wire [31:0] PCJSrcOutIF, PCSrcOutIF;

wire [31:0] instIF, PCIF, PCPlus4IF;

// ID
wire [31:0] instID, PCID, PCPlus4ID;

wire [31:0] readData1ID, readData2ID, immID;
// wire [4:0] readReg1ID, readReg2ID, writeRegID;
wire [1:0] branchTypeID, memtoRegID, ALUOpID;
wire branchID, memReadID, memWriteID, ALUSrcID, regWriteID, jumpID, PCJSrcID;

// EX
/* verilator lint_off UNUSEDSIGNAL */
wire [31:0] readData1EX, readData2EX, PCEX, PCPlus4EX, immEX, instEX;
wire [4:0] readReg1EX, readReg2EX, writeRegEX;
wire [1:0] branchTypeEX, memtoRegEX, ALUOpEX;
wire branchEX, memReadEX, memWriteEX, ALUSrcEX, regWriteEX, jumpEX, PCJSrcEX;

wire [31:0] PCTargetEX, ALUA, ALUB; 
wire [3:0] ALUCtl;
wire PCSrcEX, zero, brlt, branchCompOut, andOut;

wire [31:0] ALUOutEX, writeDataEX;

// MEM
wire [31:0] ALUOutMEM, writeDataMEM, PCPlus4MEM;
wire [4:0] writeRegMEM;
wire [1:0] memtoRegMEM;
wire memReadMEM, memWriteMEM, regWriteMEM;

wire [31:0] readDataMEM;


// WB
wire [31:0] ALUOutWB, PCPlus4WB, readDataWB;
wire [4:0] writeRegWB;
wire [1:0] memtoRegWB;
wire regWriteWB;

wire [31:0] resultWB;

// Hazard
wire [1:0] forwardAEX, forwardBEX;
wire stallPC, stallIFID, flushIFID, flushIDEX;

// ============================

// IF
Mux2to1 #(.size(32)) m_Mux_PCJSrcIF(
    .sel(PCJSrcEX),
    .s0(PCTargetEX),
    .s1(ALUOutEX),
    .out(PCJSrcOutIF)
);

Mux2to1 #(.size(32)) m_Mux_PCSrcIF(
    .sel(PCSrcEX),
    .s0(PCPlus4IF),
    .s1(PCJSrcOutIF),
    .out(PCSrcOutIF)
);

PC m_PC(
    .clk(clk),
    .rst(start),
    .stallPC(stallPC),
    .pc_i(PCSrcOutIF),
    .pc_o(PCIF)
);

InstructionMemory m_InstMem(
    .readAddr(PCIF),
    .inst(instIF)
);

Adder m_Adder_PCIF(
    .a(PCIF),
    .b(4),
    .sum(PCPlus4IF)
);

// IFID
IFID m_IFID(
    .clk(clk),
    .instIF(instIF),
    .PCIF(PCIF),
    .PCPlus4IF(PCPlus4IF),
    .flushIFID(flushIFID),
    .stallIFID(stallIFID),
    .instID(instID),
    .PCID(PCID),
    .PCPlus4ID(PCPlus4ID)
);

// ID
Control m_Control(
    .opcode(instID[6:0]),
    .funct3(instID[14:12]),
    .branch(branchID),
    .branchType(branchTypeID),
    .memRead(memReadID),
    .memtoReg(memtoRegID),
    .ALUOp(ALUOpID),
    .memWrite(memWriteID),
    .ALUSrc(ALUSrcID),
    .regWrite(regWriteID),
    .jump(jumpID),
    .PCJSrc(PCJSrcID)
);

// For Student: 
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWriteWB),
    .readReg1(instID[19:15]),
    .readReg2(instID[24:20]),
    .writeReg(writeRegWB),
    .writeData(resultWB),

    .readData1(readData1ID),
    .readData2(readData2ID)
);

// ======= for validation ======= 
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

ImmGen m_ImmGen(
    .inst(instID),
    .imm(immID)
);

// IDEX
IDEX m_IDEX(
    .clk(clk),
    .readReg1ID(instID[19:15]),
    .readReg2ID(instID[24:20]),
    .writeRegID(instID[11:7]),
    .readData1ID(readData1ID),
    .readData2ID(readData2ID),
    .PCID(PCID),
    .PCPlus4ID(PCPlus4ID),
    .immID(immID),
    .instID(instID),
    .flushIDEX(flushIDEX),

    .readReg1EX(readReg1EX),
    .readReg2EX(readReg2EX),
    .writeRegEX(writeRegEX),
    .readData1EX(readData1EX),
    .readData2EX(readData2EX),
    .PCEX(PCEX),
    .PCPlus4EX(PCPlus4EX),
    .immEX(immEX),
    .instEX(instEX),

    .branchID(branchID),
    .branchTypeID(branchTypeID),
    .memReadID(memReadID),
    .memtoRegID(memtoRegID),
    .ALUOpID(ALUOpID),
    .memWriteID(memWriteID),
    .ALUSrcID(ALUSrcID),
    .regWriteID(regWriteID),
    .jumpID(jumpID),
    .PCJSrcID(PCJSrcID),

    .branchEX(branchEX),
    .branchTypeEX(branchTypeEX),
    .memReadEX(memReadEX),
    .memtoRegEX(memtoRegEX),
    .ALUOpEX(ALUOpEX),
    .memWriteEX(memWriteEX),
    .ALUSrcEX(ALUSrcEX),
    .regWriteEX(regWriteEX),
    .jumpEX(jumpEX),
    .PCJSrcEX(PCJSrcEX)
);

// EX
BranchComp m_BranchComp(
    .sel(branchTypeEX),
    .zero(zero),
    .brlt(brlt),
    .out(branchCompOut)
);

and A1(andOut, branchEX, branchCompOut);
or O1(PCSrcEX, andOut, jumpEX);

Mux3to1 #(.size(32)) m_Mux_ForwardAEX(
    .sel(forwardAEX),
    .s0(readData1EX),
    .s1(resultWB),
    .s2(ALUOutMEM),
    .out(ALUA)
);

Mux3to1 #(.size(32)) m_Mux_ForwardBEX(
    .sel(forwardBEX),
    .s0(readData2EX),
    .s1(resultWB),
    .s2(ALUOutMEM),
    .out(writeDataEX)
);

Mux2to1 #(.size(32)) m_Mux_ALUSrcEX(
    .sel(ALUSrcEX),
    .s0(writeDataEX),
    .s1(immEX),
    .out(ALUB)
);


Adder m_Adder_PCTargetEX(
    .a(PCEX),
    .b(immEX),
    .sum(PCTargetEX)
);

ALUCtrl m_ALUCtrlEX(
    .ALUOp(ALUOpEX),
    .funct7(instEX[30]),
    .funct3(instEX[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUctl(ALUCtl),
    .A(ALUA),
    .B(ALUB),
    .ALUOut(ALUOutEX),
    .zero(zero),
    .brlt(brlt)
);

// EXMEM 
EXMEM m_EXMEM(
    .clk(clk),
    .ALUOutEX(ALUOutEX),
    .writeDataEX(writeDataEX),
    .PCPlus4EX(PCPlus4EX),
    .writeRegEX(writeRegEX),
    .memtoRegEX(memtoRegEX),
    .memReadEX(memReadEX),
    .memWriteEX(memWriteEX),
    .regWriteEX(regWriteEX),

    .ALUOutMEM(ALUOutMEM),
    .writeDataMEM(writeDataMEM),
    .PCPlus4MEM(PCPlus4MEM),
    .writeRegMEM(writeRegMEM),
    .memtoRegMEM(memtoRegMEM),
    .memReadMEM(memReadMEM),
    .memWriteMEM(memWriteMEM),
    .regWriteMEM(regWriteMEM)
);

// MEM
DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWriteMEM),
    .memRead(memReadMEM),
    .address(ALUOutMEM),
    .writeData(writeDataMEM),
    .readData(readDataMEM)
);

// MEMWB 
MEMWB m_MEMWB(
    .clk(clk),
    .ALUOutMEM(ALUOutMEM),
    .writeRegMEM(writeRegMEM),
    .PCPlus4MEM(PCPlus4MEM),
    .readDataMEM(readDataMEM),
    .ALUOutWB(ALUOutWB),
    .writeRegWB(writeRegWB),
    .PCPlus4WB(PCPlus4WB),
    .readDataWB(readDataWB),
    .memtoRegMEM(memtoRegMEM),
    .regWriteMEM(regWriteMEM),
    .memtoRegWB(memtoRegWB),
    .regWriteWB(regWriteWB)
);

// WB
Mux3to1 #(.size(32)) m_Mux_WB(
    .sel(memtoRegWB),
    .s0(ALUOutWB),
    .s1(readDataWB),
    .s2(PCPlus4WB),
    .out(resultWB)
);

// Hazard 
Hazard m_Hazard(
    .readReg1ID(instID[19:15]),
    .readReg2ID(instID[24:20]),
    .readReg1EX(readReg1EX),
    .readReg2EX(readReg2EX),
    .writeRegEX(writeRegEX),
    .writeRegMEM(writeRegMEM),
    .writeRegWB(writeRegWB),
    .regWriteMEM(regWriteMEM),
    .regWriteWB(regWriteWB),
    .PCSrcEX(PCSrcEX),
    .memtoRegEX(memtoRegEX),

    .stallPC(stallPC),
    .stallIFID(stallIFID),
    .flushIFID(flushIFID),
    .flushIDEX(flushIDEX),
    .forwardAEX(forwardAEX),
    .forwardBEX(forwardBEX)
);

endmodule
