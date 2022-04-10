//
// KFX86_Accumulator.sv
// Written by kitune-san
//
`include "KFX86_Accumulator.svh"

module KFX86_Accumulator (
    input   logic   [4:0]   opcode,
    input   logic   [15:0]  source_1,
    input   logic   [15:0]  source_2,
    input   flags_t         source_flags,
    input   logic           select_word,
    output  logic   [15:0]  out,
    output  flags_t         out_flags
);

    logic   [15:0]  out_tmp;

    always_comb begin
        out_tmp     = 16'h0000;
        out_flags   = source_flags;

        casez (opcode)
            `ALU_OP_ADD: begin
                {out_flags.a, out_tmp[3:0]} = {1'b0, source_1[3:0]} + {1'b0, source_2[3:0]};
                {out_flags.c, out_tmp[7:4]} = {1'b0, source_1[7:4]} + {1'b0, source_2[7:4]} + {4'h0, out_flags.a};
                {out_flags.c, out_tmp[15:8]} = select_word ? {1'b0, source_1[15:8]} + {1'b0, source_2[15:8]} + {8'h0, out_flags.c} : {out_flags.c, 8'h00};
                out_flags.o = select_word ? ~(source_1[15] ^ source_2[15]) & (source_1[15] ^ out_tmp[15])
                                          : ~(source_1[7]  ^ source_2[7])  & (source_1[7]  ^ out_tmp[7]);
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_OR: begin
                out_tmp = (source_1 | source_2) & (select_word ? 16'hFFFF : 16'h00FF);
                out_flags.c = 1'b0;
                out_flags.o = 1'b0;
                //out_flags.a = 1'bx;
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_ADC: begin
                {out_flags.a, out_tmp[3:0]} = {1'b0, source_1[3:0]} + {1'b0, source_2[3:0]} + {4'h0, source_flags.c};
                {out_flags.c, out_tmp[7:4]} = {1'b0, source_1[7:4]} + {1'b0, source_2[7:4]} + {4'h0, out_flags.a};
                {out_flags.c, out_tmp[15:8]} = select_word ? {1'b0, source_1[15:8]} + {1'b0, source_2[15:8]} + {8'h0, out_flags.c} : {out_flags.c, 8'h00};
                out_flags.o = select_word ? ~(source_1[15] ^ source_2[15]) & (source_1[15] ^ out_tmp[15])
                                          : ~(source_1[7]  ^ source_2[7])  & (source_1[7]  ^ out_tmp[7]);
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_SBB: begin
                {out_flags.a, out_tmp[3:0]} = {1'b0, source_1[3:0]} - {1'b0, source_2[3:0]} - {4'h0, source_flags.c};
                {out_flags.c, out_tmp[7:4]} = {1'b0, source_1[7:4]} - {1'b0, source_2[7:4]} - {4'h0, out_flags.a};
                {out_flags.c, out_tmp[15:8]} = select_word ? {1'b0, source_1[15:8]} - {1'b0, source_2[15:8]} - {8'h0, out_flags.c} : {out_flags.c, 8'h00};
                out_flags.o = select_word ? (source_1[15] ^ source_2[15]) & (source_1[15] ^ out_tmp[15])
                                          : (source_1[7]  ^ source_2[7])  & (source_1[7]  ^ out_tmp[7]);
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_AND: begin
                out_tmp = (source_1 & source_2) & (select_word ? 16'hFFFF : 16'h00FF);
                out_flags.c = 1'b0;
                out_flags.o = 1'b0;
                //out_flags.a = 1'bx;
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_SUB: begin
                {out_flags.a, out_tmp[3:0]} = {1'b0, source_1[3:0]} - {1'b0, source_2[3:0]};
                {out_flags.c, out_tmp[7:4]} = {1'b0, source_1[7:4]} - {1'b0, source_2[7:4]} - {4'h0, out_flags.a};
                {out_flags.c, out_tmp[15:8]} = select_word ? {1'b0, source_1[15:8]} - {1'b0, source_2[15:8]} - {8'h0, out_flags.c} : {out_flags.c, 8'h00};
                out_flags.o = select_word ? (source_1[15] ^ source_2[15]) & (source_1[15] ^ out_tmp[15])
                                          : (source_1[7]  ^ source_2[7])  & (source_1[7]  ^ out_tmp[7]);
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_XOR: begin
                out_tmp = (source_1 ^ source_2) & (select_word ? 16'hFFFF : 16'h00FF);
                out_flags.c = 1'b0;
                out_flags.o = 1'b0;
                //out_flags.a = 1'bx;
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = out_tmp;
            end
            `ALU_OP_CMP: begin
                {out_flags.a, out_tmp[3:0]} = {1'b0, source_1[3:0]} - {1'b0, source_2[3:0]};
                {out_flags.c, out_tmp[7:4]} = {1'b0, source_1[7:4]} - {1'b0, source_2[7:4]} - {4'h0, out_flags.a};
                {out_flags.c, out_tmp[15:8]} = select_word ? {1'b0, source_1[15:8]} - {1'b0, source_2[15:8]} - {8'h0, out_flags.c} : {out_flags.c, 8'h00};
                out_flags.o = select_word ? (source_1[15] ^ source_2[15]) & (source_1[15] ^ out_tmp[15])
                                          : (source_1[7]  ^ source_2[7])  & (source_1[7]  ^ out_tmp[7]);
                out_flags.p = ~^out_tmp[7:0];
                out_flags.z = ~|out_tmp;
                out_flags.s = select_word ? out_tmp[15] : out_tmp[7];
                out = source_1;
            end
            default: begin
                out_tmp     = 16'h0000;
                out_flags   = source_flags;
                out = out_tmp;
            end
        endcase
    end
endmodule

