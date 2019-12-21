// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire muxS;
wire [31:0]ors,shiftRes;
genvar i;
generate 
	for(i=0;i<26;i=i+1)
	begin:or_gen_loop
	if(i==0)begin or or0(ors[i],S[i+5],S[i+6]);end
	else if(i==25)begin or or31(muxS,ors[i-1],S[i+6]);end
	else begin or orn(ors[i],ors[i-1],S[i+6]); end
	end
endgenerate
BARREL_SHIFTER32 shift(.Y(shiftRes),.D(D),.S(S), .LnR(LnR));
MUX32_2x1 final(.Y(Y), .I0(shiftRes), .I1(32'd0), .S(muxS));
endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;
wire [31:0]resR,resL;

SHIFT32_R shiftr(.Y(resR),.D(D),.S(S));
SHIFT32_L shiftl(.Y(resL),.D(D),.S(S));
MUX32_2x1 LorR(.Y(Y),.I0(resR),.I1(resL),.S(LnR));
endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0]S1,S2,S3,S4;

genvar i;
generate
	for(i=31;i>=0;i=i-1)
	begin:SHIFT32_R_gen_loop
	
	if(i>30)begin MUX1_2x1 Stage1(.Y(S1[i]),.I0(D[i]),.I1(1'b0),.S(S[0]));end
	else begin MUX1_2x1 Stage1(.Y(S1[i]),.I0(D[i]),.I1(D[i+1]),.S(S[0])); end
	
	if(i>29)begin MUX1_2x1 Stage2(.Y(S2[i]),.I0(S1[i]),.I1(1'b0),.S(S[1]));end
	else begin MUX1_2x1 Stage2(.Y(S2[i]),.I0(S1[i]),.I1(D[i+2]),.S(S[1]));end
	
	if(i>27)begin MUX1_2x1 Stage3(.Y(S3[i]),.I0(S2[i]),.I1(1'b0),.S(S[2]));end
	else begin MUX1_2x1 Stage3(.Y(S3[i]),.I0(S2[i]),.I1(S2[i+4]),.S(S[2]));end
	
	if(i>23)begin MUX1_2x1 Stage4(.Y(S4[i]),.I0(S3[i]),.I1(1'b0),.S(S[3]));end
	else begin MUX1_2x1 Stage4(.Y(S4[i]),.I0(S3[i]),.I1(S3[i+8]),.S(S[3]));end
	
	if(i>15)begin MUX1_2x1 Stage5(.Y(Y[i]),.I0(S4[i]),.I1(1'b0),.S(S[4]));end
	else begin MUX1_2x1 Stage5(.Y(Y[i]),.I0(S4[i]),.I1(S4[i+16]),.S(S[4]));end
	
	end
endgenerate

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0]S1,S2,S3,S4;

genvar i;
generate
	for(i=0;i<32;i=i+1)
	begin : SHIFT32_L_gen_loop
	if(i<1)begin MUX1_2x1 Stage1(.Y(S1[i]),.I0(D[i]),.I1(1'b0),.S(S[0]));end
	else begin MUX1_2x1 Stage1(.Y(S1[i]),.I0(D[i]),.I1(D[i-1]),.S(S[0])); end
	
	if(i<2)begin MUX1_2x1 Stage2(.Y(S2[i]),.I0(S1[i]),.I1(1'b0),.S(S[1]));end
	else begin MUX1_2x1 Stage2(.Y(S2[i]),.I0(S1[i]),.I1(D[i-2]),.S(S[1]));end
	
	if(i<4)begin MUX1_2x1 Stage3(.Y(S3[i]),.I0(S2[i]),.I1(1'b0),.S(S[2]));end
	else begin MUX1_2x1 Stage3(.Y(S3[i]),.I0(S2[i]),.I1(S2[i-4]),.S(S[2]));end
	
	if(i<8)begin MUX1_2x1 Stage4(.Y(S4[i]),.I0(S3[i]),.I1(1'b0),.S(S[3]));end
	else begin MUX1_2x1 Stage4(.Y(S4[i]),.I0(S3[i]),.I1(S3[i-8]),.S(S[3]));end
	
	if(i<16)begin MUX1_2x1 Stage5(.Y(Y[i]),.I0(S4[i]),.I1(1'b0),.S(S[4]));end
	else begin MUX1_2x1 Stage5(.Y(Y[i]),.I0(S4[i]),.I1(S4[i-16]),.S(S[4]));end
	
	end
endgenerate
endmodule

module shift_tb;
wire[31:0]Y;
reg[31:0]D,S;
reg LnR;
SHIFT32 shifter(.Y(Y),.D(D),.S(S), .LnR(LnR));
initial
begin
#5 D=32'd15;S=32'd5;LnR=0;
#5 D=32'd15;S=32'd5;LnR=1;
end
endmodule
