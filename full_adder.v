// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;

wire Y1,CO1,CO2;

HALF_ADDER one(.Y(Y1),.C(CO1),.A(A),.B(B));
HALF_ADDER two(.Y(S),.C(CO2),.A(Y1),.B(CI));

or COb(CO,CO1,CO2);

endmodule

`include "prj_definition.v"
module full_adder_tb;
wire CO;
wire S;
reg A,B,CI;

FULL_ADDER fadder(.S(S),.CO(CO),.A(A),.B(B), .CI(CI));

initial
begin

#5 A=0;
 B=0;
 CI=0;
#5 CI=1;	
#5 A=0; 
 B=1;
 CI=0;
#5 CI=1;
#5 A=1; 
 B=0;
 CI=0;
#5 CI=1;
#5 A=1; 
 B=1;
 CI=0;
#5 CI=1;
end
endmodule