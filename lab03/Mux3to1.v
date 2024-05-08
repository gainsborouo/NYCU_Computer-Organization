module Mux3to1 #(
    parameter size = 32
) 
(
    input [1:0] sel,
    input signed [size-1:0] s0,
    input signed [size-1:0] s1,
    input signed [size-1:0] s2,
    output signed [size-1:0] out
);

    assign out = (sel == 2'b10 || sel == 2'b11) ? s2 : (sel == 2'b01) ? s1 : s0;
    
endmodule

