module MEMWB(
    input clk,
    // Pipeline Reg
    input [31:0] ALUOutMEM,
    input [4:0] writeRegMEM,
    input [31:0] PCPlus4MEM,
    input [31:0] readDataMEM, // Data Memory Output

    output reg [31:0] ALUOutWB,
    output reg [4:0] writeRegWB,
    output reg [31:0] PCPlus4WB,
    output reg [31:0] readDataWB,
    
    // Pipeline Ctrl
    input [1:0] memtoRegMEM, 
    input regWriteMEM,

    output reg [1:0] memtoRegWB,    
    output reg regWriteWB
);
  
    always @(posedge clk) begin
        ALUOutWB <= ALUOutMEM;
        writeRegWB <= writeRegMEM;
        PCPlus4WB <= PCPlus4MEM;
        readDataWB <= readDataMEM;

        memtoRegWB <= memtoRegMEM;
        regWriteWB <= regWriteMEM;
    end

endmodule
