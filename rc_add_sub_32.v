// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

wire [63:0]CO_CI,BxorSnA;


genvar i;
generate 
	for(i=0;i<64;i=i+1)
		begin : rc_add_sub_64_gen_loop
		xor xorB(BxorSnA[i],B[i],SnA);
			if(i==0)begin FULL_ADDER A0(.S(Y[i]),.CO(CO_CI[i]),.A(A[i]),.B(BxorSnA[i]), .CI(SnA));end
			else if(i==63)begin FULL_ADDER A63(.S(Y[i]),.CO(CO),.A(A[i]),.B(BxorSnA[i]), .CI(CO_CI[i-1]));end
			else begin FULL_ADDER An(.S(Y[i]),.CO(CO_CI[i]),.A(A[i]),.B(BxorSnA[i]), .CI(CO_CI[i-1]));end
		end
endgenerate

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

wire [`DATA_INDEX_LIMIT:0]CO_CI,BxorSnA;



genvar i;
generate 
	for(i=0;i<32;i=i+1)
		begin : rc_add_sub_32_gen_loop
			xor xorB(BxorSnA[i],B[i],SnA);
			if(i==0)begin FULL_ADDER A0(.S(Y[i]),.CO(CO_CI[i]),.A(A[i]),.B(BxorSnA[i]), .CI(SnA));end
			else if(i==31)begin FULL_ADDER A31(.S(Y[i]),.CO(CO),.A(A[i]),.B(BxorSnA[i]), .CI(CO_CI[i-1]));end
			else begin FULL_ADDER An(.S(Y[i]),.CO(CO_CI[i]),.A(A[i]),.B(BxorSnA[i]), .CI(CO_CI[i-1]));end
		end
endgenerate

endmodule

`include "prj_definition.v"
module rc_add_sub32;
wire CO;
wire[31:0] Y;
reg [31:0]A,B;
reg SnA;

RC_ADD_SUB_32 addSub(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial 
begin
#5 A=32'hFFFFFFFF;B=32'd1;SnA=0;//Overflow test
#5 A=32'd23;B=32'd1;SnA=0; //carry CO to CI bit test
#5 A=32'd0;B=32'd1;SnA=1; //subtraction test
#5 A=32'd15;B=32'd3;SnA=0; //basic add
#5 A=32'd15;B=32'd2;SnA=1; //basic sub
#5 A=32'd23;B=32'd1;SnA=0; //repeated test
end
endmodule

`include "prj_definition.v"
module rc_add_sub64;
wire CO;
wire[63:0] Y;
reg [63:0]A,B;
reg SnA;

RC_ADD_SUB_64 addSub(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial 
begin
#5 A=64'hFFFFFFFFFFFFFFFF;B=64'd1;SnA=0; //overflow test
#5 A=64'd23;B=64'd1;SnA=0; //repeated tests
#5 A=64'd0;B=64'd1;SnA=1;
#5 A=64'd15;B=64'd3;SnA=0;
#5 A=64'd15;B=64'd2;SnA=1;
#5 A=64'd23;B=64'd1;SnA=0;
end
endmodule
