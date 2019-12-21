// Name: half_adder.v
// Module: HALF_ADDER
//
// Output: Y : Sum
//         C : Carry
//
// Input: A : Bit 1
//        B : Bit 2
//
// Notes: 1-bit half adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module HALF_ADDER(Y,C,A,B);
output Y,C;
input A,B;

xor inst1(Y,A,B);
and inst2(C,A,B);

endmodule

`include "prj_definition.v"
module half_adder_tb;
wire C;
wire Y;
reg A,B;

HALF_ADDER hadder(.Y(Y),.C(C),.A(A),.B(B));

initial
begin

#5 A=0;
 B=0;	
#5 A=0; 
 B=1;
#5 A=1; 
 B=0;
#5 A=1; 
 B=1;
end
endmodule