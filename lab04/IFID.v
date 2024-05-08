module IFID (
    input clk,
    input [31:0] instIF,
    input [31:0] PCIF, 
    input [31:0] PCPlus4IF,
    input flushIFID, 
    input stallIFID, 
    output reg [31:0] instID,
    output reg [31:0] PCID,
    output reg [31:0] PCPlus4ID
);

    always @(posedge clk) begin
        if(stallIFID == 1'b0) begin
            if(flushIFID == 1'b1) begin
                instID <= 32'b0;
                PCID <= 32'b0;
                PCPlus4ID <= 32'b0;
            end
            else begin
                instID <= instIF;
                PCID <= PCIF;
                PCPlus4ID <= PCPlus4IF;
            end
        end
    end
endmodule
