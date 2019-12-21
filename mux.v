// Name: mux.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

wire [31:0] b0_15,b16_31;

MUX32_16x1 b0_15mux(.Y(b0_15), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7),
                     .I8(I8), .I9(I9), .I10(I10), .I11(I11), .I12(I12), .I13(I13), .I14(I14), .I15(I15), .S(S[3:0]));
MUX32_16x1 b16_31mux(.Y(b16_31), .I0(I16), .I1(I17), .I2(I18), .I3(I19), .I4(I20), .I5(I21), .I6(I22), .I7(I23),
                     .I8(I24), .I9(I25), .I10(I26), .I11(I27), .I12(I28), .I13(I29), .I14(I30), .I15(I31), .S(S[3:0]));
MUX32_2x1 finalmux(.Y(Y),.I0(b0_15), .I1(b16_31), .S(S[4]));
endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [31:0] I8;
input [31:0] I9;
input [31:0] I10;
input [31:0] I11;
input [31:0] I12;
input [31:0] I13;
input [31:0] I14;
input [31:0] I15;
input [3:0] S;
wire [31:0] b0_7,b8_15;

MUX32_8x1 b0_7mux(.Y(b0_7), .I0(I0), .I1(I1), .I2(I2), .I3(I3),.I4(I4), .I5(I5), .I6(I6), .I7(I7), .S(S[2:0]));
MUX32_8x1 b8_15mux(.Y(b8_15), .I0(I8), .I1(I9), .I2(I10), .I3(I11), .I4(I12), .I5(I13), .I6(I14), .I7(I15), .S(S[2:0]));
MUX32_2x1 finalmux(.Y(Y),.I0(b0_7), .I1(b8_15), .S(S[3]));

endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [2:0] S;
wire [31:0] b0_3,b4_7;

MUX32_4x1 b0_3mux(.Y(b0_3), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S[1:0]));
MUX32_4x1 b4_7mux(.Y(b4_7), .I0(I4), .I1(I5), .I2(I6), .I3(I7), .S(S[1:0]));
MUX32_2x1 finalmux(.Y(Y),.I0(b0_3), .I1(b4_7), .S(S[2]));

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [1:0] S;

wire [31:0] b0,b1;

MUX32_2x1 b0mux(.Y(b0),.I0(I0), .I1(I1), .S(S[0]));
MUX32_2x1 b1mux(.Y(b1),.I0(I2), .I1(I3), .S(S[0]));
MUX32_2x1 finalmux(.Y(Y),.I0(b0), .I1(b1), .S(S[1]));

endmodule

// 32-bit mux
module MUX64_2x1(Y, I0, I1, S);
// output list
output [63:0] Y;
//input list
input [63:0] I0;
input [63:0] I1;
input S;

genvar i;
generate
	for(i=0;i<64;i=i+1)
		begin:MUX32_2x1_gen_loop
		MUX1_2x1 mux((Y[i]),(I0[i]),(I1[i]),S);
		end
endgenerate
endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input S;

genvar i;
generate
	for(i=0;i<32;i=i+1)
		begin:MUX32_2x1_gen_loop
		MUX1_2x1 mux((Y[i]),(I0[i]),(I1[i]),S);
		end
endgenerate
endmodule

// 1-bit mux
module MUX1_2x1(Y,I0, I1, S); //swap Snot???
//output list
output Y;
//input list
input I0, I1, S;

wire Snot,I1andS, I0andSnot;
not notS(Snot,S);
and andS(I1andS,I1,S);
and andSnot(I0andSnot,I0,Snot);
or orY(Y,I1andS,I0andSnot); 
endmodule

`include "prj_definition.v"
module mux1_2x1_tb;
wire Y;
reg S,I0,I1;

MUX1_2x1 testmux(.Y(Y),.I0(I0), .I1(I1), .S(S));

initial
begin
#5 
I0=0;
I1=0;
S=0;
#5
S=1;
#5 
I0=0;
I1=1;
S=0;
#5
S=1;
#5 
I0=1;
I1=0;
S=0;
#5
S=1;
#5 
I0=1;
I1=1;
S=0;
#5
S=1;
end
endmodule
