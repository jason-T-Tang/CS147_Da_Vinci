// Name: logic.v
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
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;
wire [63:0] invResult;
wire CO;
genvar i;
generate
	for(i=0;i<64;i=i+1)
	begin : TWOSCOMP64_gen_loop
	not inv(invResult[i],A[i]);
	end
endgenerate
RC_ADD_SUB_64 adder64(.Y(Y), .CO(CO), .A(invResult), .B(64'd1), .SnA(1'b0));
endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

wire [31:0] invResult;
wire CO;

INV32_1x1 invRes(.Y(invResult),.A(A));
RC_ADD_SUB_32 adder(.Y(Y), .CO(CO), .A(invResult), .B(32'd1), .SnA(1'b0));


endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

genvar i;
generate
for(i=0;i<32;i=i+1)
begin: REG32_gen_loop
	wire blank;//wire to catch Qbar
	REG1 nReg(.Q(Q[i]),.Qbar(blank),.D(D[i]),.L(LOAD),.C(CLK),.nP(1'b1),.nR(RESET));
end
endgenerate
endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

wire mux;

MUX1_2x1 MUX(mux,Q,D,L);
D_FF dff(.Q(Q),.Qbar(Qbar), .D(mux),.C(C),.nP(nP),.nR(nR));
endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;
wire Y, Ynot,Cnot;

not notC(Cnot,C);
D_LATCH dlatch(.Q(Y),.Qbar(Ynot),.D(D),.C(Cnot),.nP(nP),.nR(nR));
SR_LATCH srlatch(.Q(Q),.Qbar(Qbar),.S(Y),.R(Ynot),.C(C),.nP(nP),.nR(nR));

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Dnot,DandC,DnandC;
not DNot(Dnot,D);

nand Dandc(DandC,D,C);
nand DnAndC(DnandC,Dnot,C);
nand nandQ(Q,Qbar,DandC,nP);
nand nandQinv(Qbar,Q,DnandC,nR);

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;
wire SandC,RandC;
nand Sand(SandC,S,C);
nand Rand(RandC,R,C);
nand nandQ(Q,Qbar,SandC,nP);
nand nandQinv(Qbar,Q,RandC,nR);
endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

wire [15:0] Dout;
wire invI4;
not inv(invI4,I[4]);
DECODER_4x16 decoder(.D(Dout[15:0]),.I(I[3:0]));

genvar i;
generate
	for(i=0;i<16;i=i+1)
	begin: DECODER_5x32_gen_loop
	and andI(D[i],Dout[i],invI4);
	and andIinv(D[i+16],Dout[i],I[4]);
	end
endgenerate
endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;
wire [7:0]Dout;
wire invI3;
DECODER_3x8 decoder(.D(Dout[7:0]),.I(I[2:0]));
not inv(invI3,I[3]);

genvar i;
generate 
	for(i=0;i<8;i=i+1)
	begin:DECODER_4x16_gen_loop
	and andI((D[i]),Dout[i],invI3);
	and andIinv(D[i+8],Dout[i],I[3]);
	end
endgenerate
endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

wire [3:0]Dout;
wire invI2;
not invI(invI2,I[2]);
DECODER_2x4 decoder(.D(Dout[3:0]),.I(I[1:0]));
genvar i;
generate
	for(i=0;i<4;i=i+1)
	begin:DECODER_3x8_gen_loop
	and andI(D[i],Dout[i],invI2);
	and andIinv(D[i+4],Dout[i],I[2]);
	end
endgenerate
endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

wire invI1,invI0;
not inv1(invI1,I[1]);
not inv0(invI0,I[0]);

and and0(D[0],invI0,invI1);
and and1(D[1],invI1,I[0]);
and and2(D[2],invI0,I[1]);
and and3(D[3],I[0],I[1]);
endmodule

module Decoder_tb;
reg [2:0]I;
wire [7:0]D;
DECODER_3x8 decoder(.D(D),.I(I));
initial
begin
#5 I=3'd7;
end
endmodule

module REG32_PP(Q, D, LOAD, CLK, RESET);
parameter PATTERN = 32'h00000000;
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire [31:0] qbar;

genvar i;
generate
for(i=0; i<32; i=i+1)
begin : reg32_gen_loop
if (PATTERN[i] == 0)
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
else
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
end
endgenerate

endmodule