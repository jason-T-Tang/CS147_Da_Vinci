// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [31:0] Acomp,Amux,Bcomp,Bmux;
wire [63:0] HiLo,HiLoComp,productRes;
wire isNeg;

TWOSCOMP32 getAcomp(Acomp,A);
MUX32_2x1 muxA(Amux,A,Acomp,A[31]);

TWOSCOMP32 getBcomp(Bcomp,B);
MUX32_2x1 muxB(Bmux,B,Bcomp,B[31]);

xor getIsNeg(isNeg,A[31],B[31]);

MULT32_U mult(HiLo[63:32],HiLo[31:0],Amux,Bmux);
TWOSCOMP64 compHiLo(HiLoComp,HiLo);
MUX64_2x1 muxHiLo(productRes,HiLo,HiLoComp,isNeg);

AND32_2x1 loadHi(HI,productRes[63:32],{32{1'b1}});
AND32_2x1 loadLo(LO,productRes[31:0],{32{1'b1}});

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [31:0]carryResult;
wire [31:0]result[31:0];

AND32_2x1 firstAnd(.Y(result[0]),.A(A),.B({32{B[0]}}));
buf getLo(LO[0],result[0][0]);
buf getCarryOut(carryResult[0],1'b0);

 
genvar i;
generate 
for(i=1;i<32;i=i+1)
begin: MULT32_U_gen_loop
	wire[31:0]andResult;//initialize a new local wire every loop
	AND32_2x1 Andn(andResult,A,{32{B[i]}});
	RC_ADD_SUB_32 adder(result[i],carryResult[i],andResult,{carryResult[i-1],{result[i-1][31:1]}},1'b0);
	buf getnLo(LO[i],result[i][0]);
end
endgenerate

AND32_2x1 getHi(HI,{carryResult[31],{result[31][31:1]}},{32{1'b1}});

endmodule

`include "prj_definition.v"
module mult_u_tb;
wire [31:0]HI,LO;
reg [31:0]A,B;

wire [31:0]HIS,LOS;
reg [31:0]AS,BS;


MULT32 mults(.HI(HIS), .LO(LOS), .A(AS), .B(BS));
MULT32_U mult(.HI(HI),.LO(LO), .A(A), .B(B));
initial
begin
#5
A=32'h7FFFFFFF;B=32'h70000000;
AS=32'h80000001;BS=32'h70000000;
end
endmodule