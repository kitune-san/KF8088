//
// KFX86_Accumulator.svh
// Written by kitune-san
//
`ifndef KFX86_ACCUMULATOR_SVH
`define KFX86_ACCUMULATOR_SVH

typedef struct packed {
    logic   f_15;
    logic   f_14;
    logic   f_13;
    logic   f_12;
    logic   o;      // Overflow
    logic   d;      // Direction
    logic   i;      // Interrupt enable
    logic   t;      // Trap
    logic   s;      // Sign
    logic   z;      // Zero
    logic   f_5;
    logic   a;      // Auxiliary carry
    logic   f_3;
    logic   p;      // Parity
    logic   f_1;
    logic   c;      // Carry
} flags_t;

`define ALU_OP_ADD  (5'b00000)
`define ALU_OP_OR   (5'b00001)
`define ALU_OP_ADC  (5'b00010)
`define ALU_OP_SBB  (5'b00011)
`define ALU_OP_AND  (5'b00100)
`define ALU_OP_SUB  (5'b00101)
`define ALU_OP_XOR  (5'b00110)
`define ALU_OP_CMP  (5'b00111)

`endif
