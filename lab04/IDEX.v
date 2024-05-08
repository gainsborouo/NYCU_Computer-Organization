module IDEX(
    input clk,
    // Pipeline Reg
    input [4:0] readReg1ID,
    input [4:0] readReg2ID,
    input [4:0] writeRegID,
    input [31:0] readData1ID,
    input [31:0] readData2ID,
    input [31:0] PCID,
    input [31:0] PCPlus4ID,
    input [31:0] immID,
    input [31:0] instID,
    input flushIDEX,

    output reg [4:0] readReg1EX,
    output reg [4:0] readReg2EX,
    output reg [4:0] writeRegEX,
    output reg [31:0] readData1EX,
    output reg [31:0] readData2EX,
    output reg [31:0] PCEX,
    output reg [31:0] PCPlus4EX,
    output reg [31:0] immEX,
    output reg [31:0] instEX,

    // Pipeline Ctrl
    input branchID,
    input [1:0] branchTypeID,
    input memReadID,
    input [1:0] memtoRegID, 
    input [1:0] ALUOpID,
    input memWriteID,
    input ALUSrcID,
    input regWriteID,
    input jumpID,
    input PCJSrcID,

    output reg branchEX,
    output reg [1:0] branchTypeEX,
    output reg memReadEX,
    output reg [1:0] memtoRegEX, 
    output reg [1:0] ALUOpEX,
    output reg memWriteEX,
    output reg ALUSrcEX,
    output reg regWriteEX,
    output reg jumpEX,
    output reg PCJSrcEX
);

    always @(posedge clk) begin
        if(flushIDEX) begin
            readReg1EX <= 0;
            readReg2EX <= 0;
            writeRegEX <= 0;
            readData1EX <= 0;
            readData2EX <= 0;
            PCEX <= 0;
            PCPlus4EX <= 0;
            immEX <= 0;
            instEX <= 0;

            branchEX <= 0;
            branchTypeEX <= 0;
            memReadEX <= 0;
            memtoRegEX <= 0;
            ALUOpEX <= 0;
            memWriteEX <= 0;
            ALUSrcEX <= 0;
            regWriteEX <= 0;
            jumpEX <= 0;
            PCJSrcEX <= 0;
        end
        else begin
            readReg1EX <= readReg1ID;
            readReg2EX <= readReg2ID;
            writeRegEX <= writeRegID;
            readData1EX <= readData1ID;
            readData2EX <= readData2ID;
            PCEX <= PCID;
            PCPlus4EX <= PCPlus4ID;
            immEX <= immID;
            instEX <= instID;

            branchEX <= branchID;
            branchTypeEX <= branchTypeID;
            memReadEX <= memReadID;
            memtoRegEX <= memtoRegID;
            ALUOpEX <= ALUOpID;
            memWriteEX <= memWriteID;
            ALUSrcEX <= ALUSrcID;
            regWriteEX <= regWriteID;
            jumpEX <= jumpID;
            PCJSrcEX <= PCJSrcID;
        end
    end
  
endmodule
