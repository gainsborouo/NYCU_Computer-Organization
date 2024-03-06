/*verilator lint_off DECLFILENAME*/
/*verilator lint_off UNUSEDSIGNAL*/
module FA(input cin, input a, input b, output s, output cout);
    assign s = (a^b)^cin;
    assign cout = ((a^b)&cin)|(a&b);

endmodule

module ADDS(
    input signed [3:0] a,
    input signed [3:0] b,
    input M,
    output [3:0] S,
    output cout
);

    wire [3:0] tmp;
    wire C0, C1, C2;
    assign tmp = b ^ {M, M, M, M};

    FA F0(M, a[0], tmp[0], S[0], C0);
    FA F1(C0, a[1], tmp[1], S[1], C1);
    FA F2(C1, a[2], tmp[2], S[2], C2);
    FA F3(C2, a[3], tmp[3], S[3], cout);

endmodule

module alu(
    input [3:0] a,
    input [3:0] b,
    input [2:0] s,
    output reg [3:0] y
); 
    // alu has two input operand a and b.
    // It executes different operation over input a and b based on input s
    // then generate result to output y
    
    // TODO: implement your 4bits ALU design here and using your own fulladder module in this module
    // For testbench verifying, do not modify input and output pin
    
    wire [3:0] addres;
    wire [3:0] subres;
    wire addout, subout;

    ADDS ADD(a, b, 0, addres, addout);
    ADDS SUB(a, b, 1, subres, subout);

    always @(*) begin
        case(s)
            3'b000: begin
                y = addres;
                end
            3'b001: begin
                y = subres;
                end
            3'b010: begin
                y = ~a;
                end
            3'b011: begin
                y = a&b;
                end
            3'b100: begin
                y = a|b;
                end
            3'b101: begin
                y = a ^ b;
                end
            3'b110: begin
                y = a > b ? 4'd1 : 4'd0;
                end
            3'b111: begin
                y = a == b ? 4'd1 : 4'd0;
                end
            endcase
    end 

endmodule

