// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;
wire andOp,notOp0,SnA,CO;
wire [31:0]addResult,shiftResult,andResult,orResult,norResult,HiResult,LoResult;

and andOp03(andOp,OPRN[3],OPRN[0]);
not notop0(notOp0,OPRN[0]);
or orSnA(SnA,andOp,notOp0);
RC_ADD_SUB_32 adder(.Y(addResult),.CO(CO),.A(OP1),.B(OP2),.SnA(SnA));

SHIFT32 shifter(.Y(shiftResult),.D(OP1),.S(OP2),.LnR(OPRN[0]));
AND32_2x1 ander(.Y(andResult),.A(OP1),.B(OP2));
OR32_2x1 orer(.Y(orResult),.A(OP1),.B(OP2));
MULT32 multiplier(.HI(HiResult),.LO(LoResult),.A(OP1),.B(OP2));
NOR32_2x1 norer(.Y(norResult),.A(OP1),.B(OP2));

MUX32_16x1 multiplexer(.Y(OUT),.I0(32'd0),.I1(addResult),.I2(addResult),.I3(LoResult),.I4(shiftResult)
,.I5(shiftResult),.I6(andResult),.I7(orResult)
,.I8(norResult),.I9({{31{1'b0}},addResult[31]})
,.I10(32'd0),.I11(32'd0),.I12(32'd0),.I13(32'd0)
,.I14(32'd0),.I15(32'd0),.S(OPRN[3:0]));
nor Zero(ZERO,OUT[0],OUT[1],OUT[2],OUT[3],OUT[4],OUT[5],OUT[6],OUT[7],OUT[8],OUT[9],OUT[10]
,OUT[11],OUT[12],OUT[13],OUT[14],OUT[15],OUT[16],OUT[17],OUT[18],OUT[19],OUT[20]
,OUT[21],OUT[22],OUT[23],OUT[24],OUT[25],OUT[26],OUT[27],OUT[28],OUT[29],OUT[30],OUT[31]);

endmodule


module alu_tb;
wire [31:0]out;
wire zero;
reg [31:0] op1_reg,op2_reg;
reg [`ALU_OPRN_INDEX_LIMIT:0]oprn_reg;
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
ALU alu(.OUT(out), .ZERO(zero), .OP1(op1_reg), .OP2(op2_reg), .OPRN(oprn_reg));
initial
begin
#5  op1_reg=15;
    op2_reg=3;
    oprn_reg=6'h01;
#5  op1_reg=32'hFFFFFFFF;
    op2_reg=1;
    oprn_reg=6'h01;   
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h02;
#5  op1_reg=-32'hFFFFFFFF;
    op2_reg=1;
    oprn_reg=6'h02;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h03;
#5  op1_reg=32'hFFFFFFFF;
    op2_reg=32'hF;
    oprn_reg=6'h03;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h04;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h05;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h06;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h07;
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=6'h08;
#5  op1_reg=5;
    op2_reg=15;
    oprn_reg=6'h09;
#5  op1_reg=0;
    op2_reg=0;
    oprn_reg=6'h01;
#5  op1_reg=15;
    op2_reg=32;
    oprn_reg=6'h05;
end
endmodule
