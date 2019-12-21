// Name: logic_32_bit.v
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

// 32-bit NOR
module NOR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

genvar i;
generate 
	for(i=0;i<32;i=i+1)
	begin: NOR32_2x1_gen_loop
	nor norn(Y[i],A[i],B[i]);
	end
endgenerate
endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

genvar i;
generate 
	for(i=0;i<32;i=i+1)
	begin: AND32_2x1_gen_loop
	and andn(Y[i],A[i],B[i]);
	end
endgenerate
endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;

genvar i;
generate 
	for(i=0;i<32;i=i+1)
	begin: INV32_2x1_gen_loop
	not notn(Y[i],A[i]);
	end
endgenerate

endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;
wire [31:0] invResult;
genvar i;
generate 
	for(i=0;i<32;i=i+1)
	begin: INV32_2x1_gen_loop
	NOR32_2x1 norn(invResult,A,B);
	INV32_1x1 invRes(Y,invResult);
	end
endgenerate
endmodule

`include "prj_definition.v"
module gate32b_tb;
wire[31:0] Ynor,Yand,Yinv,Yor;
reg [31:0]patA,patB;

OR32_2x1 org(.Y(Yor),.A(patA),.B(patB));
INV32_1x1 invg(.Y(Yinv),.A(patA));
NOR32_2x1 norg(.Y(Ynor),.A(patA),.B(patB));
AND32_2x1 andg(.Y(Yand),.A(patA),.B(patB));

initial
begin
#5 
patA={{7'b1101101},{18{1'b0}},{7'b1101101}}; //base pattern
patB={32{1'b0}};//against all 0
#5
patB={32{1'b1}};//against all 1s
#5 
patB={{7'b1101101},{18{1'b0}},{7'b1101101}};//against itself
#5 
patB={{7'b1001101},{18{1'b0}},{7'b1001101}};//random pattern
end
endmodule
