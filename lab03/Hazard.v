module Hazard(
    input [4:0] readReg1ID,
    input [4:0] readReg2ID,
    input [4:0] readReg1EX,
    input [4:0] readReg2EX,
    input [4:0] writeRegEX,
    input [4:0] writeRegMEM,
    input [4:0] writeRegWB,
    input regWriteMEM,
    input regWriteWB,
    input PCSrcEX,
    input [1:0] memtoRegEX,

    output stallPC,
    output flushIFID, 
    output stallIFID, 
    output flushIDEX,
    output reg [1:0] forwardAEX,
    output reg [1:0] forwardBEX
);

    reg lwStall;
    always @(*) begin
        forwardAEX = 2'b00;
        if(readReg1EX == writeRegMEM && regWriteMEM && (readReg1EX != 0)) forwardAEX = 2'b10;
        else if(readReg1EX == writeRegWB && regWriteWB && (readReg1EX != 0)) forwardAEX = 2'b01;

        forwardBEX = 2'b00;
        if(readReg2EX == writeRegMEM && regWriteMEM && (readReg2EX != 0)) forwardBEX = 2'b10;
        else if(readReg2EX == writeRegWB && regWriteWB && (readReg2EX != 0)) forwardBEX = 2'b01;

        lwStall = (memtoRegEX == 2'b01) && ((readReg1ID == writeRegEX) || (readReg2ID == writeRegEX));
    end

    assign stallPC = lwStall;
    assign stallIFID = lwStall;

    assign flushIFID = PCSrcEX;
    assign flushIDEX = (lwStall || PCSrcEX);

endmodule
