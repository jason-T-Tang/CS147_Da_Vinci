// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

wire [31:0]decoded,andW,data1,data2;
wire [31:0]regs[31:0];


DECODER_5x32 Wdecoder(.D(decoded),.I(ADDR_W));

genvar i;
generate
for(i=0;i<32;i=i+1)
begin:registers_gen_loop
and andn(andW[i],decoded[i],WRITE);
REG32 regn(regs[i],DATA_W,andW[i],CLK,RST);
end
endgenerate

MUX32_32x1 r1addr(.Y(data1), .I0(regs[0]), .I1(regs[1]), .I2(regs[2]), .I3(regs[3]), .I4(regs[4]), .I5(regs[5]), .I6(regs[6]), .I7(regs[7]),
                     .I8(regs[8]), .I9(regs[9]), .I10(regs[10]), .I11(regs[11]), .I12(regs[12]), .I13(regs[13]), .I14(regs[14]), .I15(regs[15]),
                     .I16(regs[16]), .I17(regs[17]), .I18(regs[18]), .I19(regs[19]), .I20(regs[20]), .I21(regs[21]), .I22(regs[22]), .I23(regs[23]),
                     .I24(regs[24]), .I25(regs[25]), .I26(regs[26]), .I27(regs[27]), .I28(regs[28]), .I29(regs[29]), .I30(regs[30]), .I31(regs[31]), .S(ADDR_R1));
MUX32_32x1 r2addr(.Y(data2), .I0(regs[0]), .I1(regs[1]), .I2(regs[2]), .I3(regs[3]), .I4(regs[4]), .I5(regs[5]), .I6(regs[6]), .I7(regs[7]),
                     .I8(regs[8]), .I9(regs[9]), .I10(regs[10]), .I11(regs[11]), .I12(regs[12]), .I13(regs[13]), .I14(regs[14]), .I15(regs[15]),
                     .I16(regs[16]), .I17(regs[17]), .I18(regs[18]), .I19(regs[19]), .I20(regs[20]), .I21(regs[21]), .I22(regs[22]), .I23(regs[23]),
                     .I24(regs[24]), .I25(regs[25]), .I26(regs[26]), .I27(regs[27]), .I28(regs[28]), .I29(regs[29]), .I30(regs[30]), .I31(regs[31]), .S(ADDR_R2));
MUX32_2x1 r1_Data(.Y(DATA_R1),.I0(32'hzzzzzzz),.I1(data1),.S(READ));
MUX32_2x1 r2_Data(.Y(DATA_R2),.I0(32'hzzzzzzz),.I1(data2),.S(READ));

endmodule
