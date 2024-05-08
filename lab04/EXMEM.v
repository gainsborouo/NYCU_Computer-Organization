module EXMEM(
    input clk,
    // Pipeline Reg
    input [31:0] ALUOutEX,
    input [31:0] writeDataEX,
    input [4:0] writeRegEX,
    input [31:0] PCPlus4EX,

    output reg [31:0] ALUOutMEM,
    output reg [31:0] writeDataMEM,
    output reg [4:0] writeRegMEM,
    output reg [31:0] PCPlus4MEM,

    // Pipeline Ctrl
    input memReadEX,
    input [1:0] memtoRegEX, 
    input memWriteEX,
    input regWriteEX,

    output reg memReadMEM,
    output reg [1:0] memtoRegMEM, 
    output reg memWriteMEM,
    output reg regWriteMEM
);
  
    always @(posedge clk) begin                      
        ALUOutMEM <= ALUOutEX;
        writeDataMEM <= writeDataEX;
        writeRegMEM <= writeRegEX;
        PCPlus4MEM <= PCPlus4EX;

        memReadMEM <= memReadEX;
        memtoRegMEM <= memtoRegEX;
        memWriteMEM <= memWriteEX;
        regWriteMEM <= regWriteEX;
    end

endmodule
