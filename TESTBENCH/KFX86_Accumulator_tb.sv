
`define TB_CYCLE        20
`define TB_FINISH_COUNT 20000

`include "../HDL/KFX86_Accumulator.svh"

module KFX86_Accumulator_tm();

    timeunit        1ns;
    timeprecision   10ps;

    //
    // Generate wave file to check
    //
`ifdef IVERILOG
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end
`endif

    //
    // Generate clock
    //
    logic   clock;
    initial clock = 1'b1;
    always #(`TB_CYCLE / 2) clock = ~clock;

    //
    // Generate reset
    //
    logic reset;
    initial begin
        reset = 1'b1;
            # (`TB_CYCLE * 10)
        reset = 1'b0;
    end

    //
    // Cycle counter
    //
    logic   [31:0]  tb_cycle_counter;
    always_ff @(negedge clock, posedge reset) begin
        if (reset)
            tb_cycle_counter <= 32'h0;
        else
            tb_cycle_counter <= tb_cycle_counter + 32'h1;
    end

    always_comb begin
        if (tb_cycle_counter == `TB_FINISH_COUNT) begin
            $display("***** SIMULATION TIMEOUT ***** at %d", tb_cycle_counter);
`ifdef IVERILOG
            $finish;
`elsif  MODELSIM
            $stop;
`else
            $finish;
`endif
        end
    end

    //
    // Module under test
    //
    //
    logic           [4:0]   opcode;
    logic   signed  [15:0]  source_1;
    logic   signed  [15:0]  source_2;
    flags_t                 source_flags;
    logic                   select_word;
    logic   signed  [15:0]  out;
    flags_t                 out_flags;

    KFX86_Accumulator u_KFX86_Accumulator (.*);

    //
    // Task : Initialization
    //
    task TASK_INIT();
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_ADD;
        source_1        = 16'h0000;
        source_2        = 16'h0000;
        source_flags    = 16'h0000;
        select_word     = 1'b1;
        #(`TB_CYCLE * 12);
    end
    endtask

    //
    // Task : ADD
    //
    task TASK_ADD(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_ADD;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) + %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : ADC
    //
    task TASK_ADC(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_ADC;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) + %d(%x) + %d = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, flags[0], out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : SUB
    //
    task TASK_SUB(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_SUB;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) - %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : CMP
    //
    task TASK_CMP(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_CMP;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) - %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : SBB
    //
    task TASK_SBB(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_SBB;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) - %d(%x) - %d = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, flags[0], out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : OR
    //
    task TASK_OR(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_OR;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) | %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : AND
    //
    task TASK_AND(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_AND;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) & %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : XOR
    //
    task TASK_XOR(input [15:0] s1, input [15:0] s2, input [15:0] flags, input sw);
    begin
        #(`TB_CYCLE * 0);
        opcode          = `ALU_OP_XOR;
        source_1        = s1;
        source_2        = s2;
        source_flags    = flags;
        select_word     = sw;
        #(`TB_CYCLE * 2);
        $display("%d(%x) ^ %d(%x) = %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, source_2, source_2, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : ROL
    //
    task TASK_ROL(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_ROL;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) -(ROL)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : ROR
    //
    task TASK_ROR(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_ROR;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) -(ROR)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : RCL
    //
    task TASK_RCL(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_RCL;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) c:%d -(RCL)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, flags[0], out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : RCR
    //
    task TASK_RCR(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_RCR;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) c:%d -(RCR)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, flags[0], out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : SHL
    //
    task TASK_SHL(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_SHL;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) -(SHL)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : SHR
    //
    task TASK_SHR(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_SHR;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) -(SHR)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Task : SAR
    //
    task TASK_SAR(input [15:0] s1, input [15:0] flags);
    begin
        opcode          = `ALU_OP_SAR;
        source_1        = s1;
        source_2        = 0;
        source_flags    = flags;
        select_word     = 0;
        #(`TB_CYCLE * 2);
        $display("%d(%x) -(SAR)-> %d(%x) o:%d d:%d i:%d t:%d s:%d z:%d a:%d p:%d c:%d", source_1, source_1, out, out, out_flags.o, out_flags.d, out_flags.i, out_flags.t, out_flags.s, out_flags.z, out_flags.a, out_flags.p, out_flags.c);
    end
    endtask;

    //
    // Test pattern
    //
    initial begin
        TASK_INIT();

        $display("***** ADD ***** at %d", tb_cycle_counter);
        TASK_ADD(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_ADD(16'h0001, 16'h0001, 16'hFFFF, 1'b1);
        TASK_ADD(16'h8000, 16'h8000, 16'h0000, 1'b1);
        TASK_ADD(16'h0008, 16'h0008, 16'h0000, 1'b1);
        TASK_ADD(16'h0080, 16'h0080, 16'h0000, 1'b1);
        TASK_ADD(16'h4000, 16'h4000, 16'h0000, 1'b1);
        TASK_ADD(16'hF000, 16'h4000, 16'h0000, 1'b1);
        TASK_ADD(16'h0008, 16'h0008, 16'h0000, 1'b0);
        TASK_ADD(16'h0080, 16'h0080, 16'h0000, 1'b0);
        TASK_ADD(16'h0040, 16'h0040, 16'h0000, 1'b0);
        TASK_ADD(16'h00f0, 16'h0040, 16'h0000, 1'b0);
        TASK_ADD(16'hEEEE, 16'h1111, 16'h0000, 1'b0);
        #(`TB_CYCLE * 5);

        $display("***** ADC ***** at %d", tb_cycle_counter);
        TASK_ADC(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_ADC(16'h0001, 16'h0001, 16'h0001, 1'b1);
        TASK_ADC(16'h0001, 16'h0001, 16'hFFFE, 1'b1);
        TASK_ADC(16'h0008, 16'h0008, 16'h0000, 1'b1);
        TASK_ADC(16'h0008, 16'h0008, 16'h0001, 1'b1);
        TASK_ADC(16'h0008, 16'h0007, 16'h0000, 1'b1);
        TASK_ADC(16'h0008, 16'h0007, 16'h0001, 1'b1);
        TASK_ADC(16'h0080, 16'h0080, 16'h0000, 1'b1);
        TASK_ADC(16'h0080, 16'h007F, 16'h0000, 1'b1);
        TASK_ADC(16'h0080, 16'h007F, 16'h0001, 1'b1);
        TASK_ADC(16'h4000, 16'h3FFF, 16'h0000, 1'b1);
        TASK_ADC(16'h4000, 16'h3FFF, 16'h0001, 1'b1);
        TASK_ADC(16'hF000, 16'h0FFF, 16'h0000, 1'b1);
        TASK_ADC(16'hF000, 16'h0FFF, 16'h0001, 1'b1);
        TASK_ADC(16'hFFFF, 16'hFFFF, 16'h0000, 1'b1);
        TASK_ADC(16'hFFFF, 16'hFFFF, 16'h0001, 1'b1);
        TASK_ADC(16'h0008, 16'h0008, 16'h0000, 1'b0);
        TASK_ADC(16'h0008, 16'h0008, 16'h0001, 1'b0);
        TASK_ADC(16'h0008, 16'h0007, 16'h0000, 1'b0);
        TASK_ADC(16'h0008, 16'h0007, 16'h0001, 1'b0);
        TASK_ADC(16'h0080, 16'h0080, 16'h0000, 1'b0);
        TASK_ADC(16'h0080, 16'h0080, 16'h0001, 1'b0);
        TASK_ADC(16'h0080, 16'h007F, 16'h0000, 1'b0);
        TASK_ADC(16'h0080, 16'h007F, 16'h0001, 1'b0);
        TASK_ADC(16'h0040, 16'h0040, 16'h0000, 1'b0);
        TASK_ADC(16'h0040, 16'h0040, 16'h0001, 1'b0);
        TASK_ADC(16'h0040, 16'h003F, 16'h0000, 1'b0);
        TASK_ADC(16'h0040, 16'h003F, 16'h0001, 1'b0);
        TASK_ADC(16'hEEEE, 16'h1111, 16'h0000, 1'b0);
        TASK_ADC(16'hEEEE, 16'h1111, 16'h0001, 1'b0);

        $display("***** SUB ***** at %d", tb_cycle_counter);
        TASK_SUB(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_SUB(16'h0001, 16'h0000, 16'hFFFF, 1'b1);
        TASK_SUB(16'h0000, 16'h0001, 16'h0000, 1'b1);
        TASK_SUB(16'h0010, 16'h0001, 16'h0000, 1'b1);
        TASK_SUB(16'hF000, 16'h0001, 16'h0000, 1'b1);
        TASK_SUB(16'hF000, 16'hF100, 16'h0000, 1'b1);
        TASK_SUB(16'hF100, 16'hF000, 16'h0000, 1'b1);
        TASK_SUB(16'h7FFF, 16'h8000, 16'h0000, 1'b1);
        TASK_SUB(16'h8000, 16'h7FFF, 16'h0000, 1'b1);
        TASK_SUB(16'h0000, 16'h0001, 16'h0000, 1'b0);
        TASK_SUB(16'h0010, 16'h0001, 16'h0000, 1'b0);
        TASK_SUB(16'h00F0, 16'h0001, 16'h0000, 1'b0);
        TASK_SUB(16'h00F0, 16'h00F1, 16'h0000, 1'b0);
        TASK_SUB(16'h007F, 16'h0080, 16'h0000, 1'b0);
        TASK_SUB(16'h0080, 16'h007F, 16'h0000, 1'b0);
        TASK_SUB(16'hFFFF, 16'h0000, 16'h0000, 1'b0);

        $display("***** CMP ***** at %d", tb_cycle_counter);
        TASK_CMP(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_CMP(16'h0001, 16'h0000, 16'hFFFF, 1'b1);
        TASK_CMP(16'h0000, 16'h0001, 16'h0000, 1'b1);
        TASK_CMP(16'h0010, 16'h0001, 16'h0000, 1'b1);
        TASK_CMP(16'hF000, 16'h0001, 16'h0000, 1'b1);
        TASK_CMP(16'hF000, 16'hF100, 16'h0000, 1'b1);
        TASK_CMP(16'hF100, 16'hF000, 16'h0000, 1'b1);
        TASK_CMP(16'h7FFF, 16'h8000, 16'h0000, 1'b1);
        TASK_CMP(16'h8000, 16'h7FFF, 16'h0000, 1'b1);
        TASK_CMP(16'h0000, 16'h0001, 16'h0000, 1'b0);
        TASK_CMP(16'h0010, 16'h0001, 16'h0000, 1'b0);
        TASK_CMP(16'h00F0, 16'h0001, 16'h0000, 1'b0);
        TASK_CMP(16'h00F0, 16'h00F1, 16'h0000, 1'b0);
        TASK_CMP(16'h007F, 16'h0080, 16'h0000, 1'b0);
        TASK_CMP(16'h0080, 16'h007F, 16'h0000, 1'b0);
        TASK_CMP(16'hFFFF, 16'h0000, 16'h0000, 1'b0);

        $display("***** SBB ***** at %d", tb_cycle_counter);
        TASK_SBB(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_SBB(16'h0001, 16'h0001, 16'h0001, 1'b1);
        TASK_SBB(16'h0000, 16'h0000, 16'h0001, 1'b1);
        TASK_SBB(16'h0001, 16'h0000, 16'hFFFE, 1'b1);
        TASK_SBB(16'h8000, 16'h0001, 16'h0000, 1'b1);
        TASK_SBB(16'h8000, 16'h0000, 16'h0000, 1'b1);
        TASK_SBB(16'h8000, 16'h0000, 16'h0001, 1'b1);
        TASK_SBB(16'h0001, 16'h8001, 16'h0000, 1'b1);
        TASK_SBB(16'h0001, 16'h8001, 16'h0001, 1'b1);
        TASK_SBB(16'h0000, 16'h8001, 16'h0000, 1'b1);
        TASK_SBB(16'h0000, 16'h8001, 16'h0001, 1'b1);
        TASK_SBB(16'h0000, 16'h8000, 16'h0000, 1'b1);
        TASK_SBB(16'h0000, 16'h8000, 16'h0001, 1'b1);
        TASK_SBB(16'h0001, 16'h0001, 16'h0000, 1'b0);
        TASK_SBB(16'h0000, 16'h0001, 16'h0000, 1'b0);
        TASK_SBB(16'h0080, 16'h0001, 16'h0000, 1'b0);
        TASK_SBB(16'h0080, 16'h0000, 16'h0000, 1'b0);
        TASK_SBB(16'h0080, 16'h0000, 16'h0001, 1'b0);
        TASK_SBB(16'h0001, 16'h0081, 16'h0000, 1'b0);
        TASK_SBB(16'h0001, 16'h0081, 16'h0001, 1'b0);

        $display("***** OR  ***** at %d", tb_cycle_counter);
        TASK_OR(16'hAAAA, 16'h5555, 16'h0000, 1'b1);
        TASK_OR(16'h0000, 16'h0000, 16'h0000, 1'b1);
        TASK_OR(16'hFFFF, 16'hFFFF, 16'h0000, 1'b1);
        TASK_OR(16'h0001, 16'h0000, 16'h0000, 1'b1);
        TASK_OR(16'h0001, 16'h0000, 16'hFFFF, 1'b1);
        TASK_OR(16'hAAAA, 16'h5555, 16'h0000, 1'b0);
        TASK_OR(16'h0000, 16'h0000, 16'h0000, 1'b0);
        TASK_OR(16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);

        $display("***** AND ***** at %d", tb_cycle_counter);
        TASK_AND(16'hAAAA, 16'h5555, 16'h0000, 1'b1);
        TASK_AND(16'h0000, 16'h0000, 16'h0000, 1'b1);
        TASK_AND(16'hFFFF, 16'hFFFF, 16'h0000, 1'b1);
        TASK_AND(16'hAAAA, 16'hAAAA, 16'h0000, 1'b1);
        TASK_AND(16'h5555, 16'h5555, 16'h0000, 1'b1);
        TASK_AND(16'h0001, 16'h0001, 16'h0000, 1'b1);
        TASK_AND(16'h0001, 16'h0001, 16'hFFFF, 1'b1);
        TASK_AND(16'hAAAA, 16'h5555, 16'h0000, 1'b0);
        TASK_AND(16'h0000, 16'h0000, 16'h0000, 1'b0);
        TASK_AND(16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);
        TASK_AND(16'hAAAA, 16'hAAAA, 16'h0000, 1'b0);
        TASK_AND(16'h5555, 16'h5555, 16'h0000, 1'b0);

        $display("***** XOR ***** at %d", tb_cycle_counter);
        TASK_XOR(16'hAAAA, 16'h5555, 16'h0000, 1'b1);
        TASK_XOR(16'h0000, 16'h0000, 16'h0000, 1'b1);
        TASK_XOR(16'hFFFF, 16'hFFFF, 16'h0000, 1'b1);
        TASK_XOR(16'hAAAA, 16'h0000, 16'h0000, 1'b1);
        TASK_XOR(16'h5555, 16'h0000, 16'h0000, 1'b1);
        TASK_XOR(16'h0001, 16'h0000, 16'h0000, 1'b1);
        TASK_XOR(16'h0001, 16'h0000, 16'hFFFF, 1'b1);
        TASK_XOR(16'hAAAA, 16'h5555, 16'h0000, 1'b0);
        TASK_XOR(16'h0000, 16'h0000, 16'h0000, 1'b0);
        TASK_XOR(16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);
        TASK_XOR(16'hAAAA, 16'h0000, 16'h0000, 1'b0);
        TASK_XOR(16'h5555, 16'h0000, 16'h0000, 1'b0);

        $display("***** ROL ***** at %d", tb_cycle_counter);
        TASK_ROL(16'h0000, 16'h0000);
        TASK_ROL(16'h0000, 16'hFFFF);
        TASK_ROL(16'h0001, 16'h0000);
        TASK_ROL(16'h0002, 16'h0000);
        TASK_ROL(16'h0004, 16'h0000);
        TASK_ROL(16'h0008, 16'h0000);
        TASK_ROL(16'h0010, 16'h0000);
        TASK_ROL(16'h0020, 16'h0000);
        TASK_ROL(16'h0040, 16'h0000);
        TASK_ROL(16'h0080, 16'h0000);
        TASK_ROL(16'h0100, 16'h0000);
        TASK_ROL(16'h0200, 16'h0000);
        TASK_ROL(16'h0400, 16'h0000);
        TASK_ROL(16'h0800, 16'h0000);
        TASK_ROL(16'h1000, 16'h0000);
        TASK_ROL(16'h2000, 16'h0000);
        TASK_ROL(16'h4000, 16'h0000);
        TASK_ROL(16'h8000, 16'h0000);

        $display("***** ROR ***** at %d", tb_cycle_counter);
        TASK_ROR(16'h0000, 16'h0000);
        TASK_ROR(16'h0000, 16'hFFFF);
        TASK_ROR(16'h8000, 16'h0000);
        TASK_ROR(16'h4000, 16'h0000);
        TASK_ROR(16'h2000, 16'h0000);
        TASK_ROR(16'h1000, 16'h0000);
        TASK_ROR(16'h0800, 16'h0000);
        TASK_ROR(16'h0400, 16'h0000);
        TASK_ROR(16'h0200, 16'h0000);
        TASK_ROR(16'h0100, 16'h0000);
        TASK_ROR(16'h0080, 16'h0000);
        TASK_ROR(16'h0040, 16'h0000);
        TASK_ROR(16'h0020, 16'h0000);
        TASK_ROR(16'h0010, 16'h0000);
        TASK_ROR(16'h0008, 16'h0000);
        TASK_ROR(16'h0004, 16'h0000);
        TASK_ROR(16'h0002, 16'h0000);
        TASK_ROR(16'h0001, 16'h0000);

        $display("***** RCL ***** at %d", tb_cycle_counter);
        TASK_RCL(16'h0000, 16'h0000);
        TASK_RCL(16'h0000, 16'hFFFF);
        TASK_RCL(16'h0000, 16'h0001);
        TASK_RCL(16'h0001, 16'h0000);
        TASK_RCL(16'h0002, 16'h0000);
        TASK_RCL(16'h0004, 16'h0000);
        TASK_RCL(16'h0008, 16'h0000);
        TASK_RCL(16'h0010, 16'h0000);
        TASK_RCL(16'h0020, 16'h0000);
        TASK_RCL(16'h0040, 16'h0000);
        TASK_RCL(16'h0080, 16'h0000);
        TASK_RCL(16'h0100, 16'h0000);
        TASK_RCL(16'h0200, 16'h0000);
        TASK_RCL(16'h0400, 16'h0000);
        TASK_RCL(16'h0800, 16'h0000);
        TASK_RCL(16'h1000, 16'h0000);
        TASK_RCL(16'h2000, 16'h0000);
        TASK_RCL(16'h4000, 16'h0000);
        TASK_RCL(16'h8000, 16'h0000);

        $display("***** RCR ***** at %d", tb_cycle_counter);
        TASK_RCR(16'h0000, 16'h0000);
        TASK_RCR(16'h0000, 16'hFFFF);
        TASK_RCR(16'h0000, 16'h0001);
        TASK_RCR(16'h8000, 16'h0000);
        TASK_RCR(16'h4000, 16'h0000);
        TASK_RCR(16'h2000, 16'h0000);
        TASK_RCR(16'h1000, 16'h0000);
        TASK_RCR(16'h0800, 16'h0000);
        TASK_RCR(16'h0400, 16'h0000);
        TASK_RCR(16'h0200, 16'h0000);
        TASK_RCR(16'h0100, 16'h0000);
        TASK_RCR(16'h0080, 16'h0000);
        TASK_RCR(16'h0040, 16'h0000);
        TASK_RCR(16'h0020, 16'h0000);
        TASK_RCR(16'h0010, 16'h0000);
        TASK_RCR(16'h0008, 16'h0000);
        TASK_RCR(16'h0004, 16'h0000);
        TASK_RCR(16'h0002, 16'h0000);
        TASK_RCR(16'h0001, 16'h0000);

        $display("***** SHL ***** at %d", tb_cycle_counter);
        TASK_SHL(16'h0000, 16'h0000);
        TASK_SHL(16'h0000, 16'hFFFF);
        TASK_SHL(16'hFFFF, 16'h0001);
        TASK_SHL(16'hFFFE, 16'h0001);
        TASK_SHL(16'hFFFC, 16'h0001);
        TASK_SHL(16'hFFF8, 16'h0001);
        TASK_SHL(16'hFFF0, 16'h0001);
        TASK_SHL(16'hFFE0, 16'h0001);
        TASK_SHL(16'hFFC0, 16'h0001);
        TASK_SHL(16'hFF80, 16'h0001);
        TASK_SHL(16'hFF00, 16'h0001);
        TASK_SHL(16'hFE00, 16'h0001);
        TASK_SHL(16'hFC00, 16'h0001);
        TASK_SHL(16'hF800, 16'h0001);
        TASK_SHL(16'hF000, 16'h0001);
        TASK_SHL(16'hE000, 16'h0001);
        TASK_SHL(16'hC000, 16'h0001);
        TASK_SHL(16'h8000, 16'h0001);
        TASK_SHL(16'h0000, 16'h0001);

        $display("***** SHR ***** at %d", tb_cycle_counter);
        TASK_SHR(16'h0000, 16'h0000);
        TASK_SHR(16'h0000, 16'hFFFF);
        TASK_SHR(16'hFFFF, 16'h0001);
        TASK_SHR(16'h7FFF, 16'h0001);
        TASK_SHR(16'h3FFF, 16'h0001);
        TASK_SHR(16'h1FFF, 16'h0001);
        TASK_SHR(16'h0FFF, 16'h0001);
        TASK_SHR(16'h07FF, 16'h0001);
        TASK_SHR(16'h03FF, 16'h0001);
        TASK_SHR(16'h01FF, 16'h0001);
        TASK_SHR(16'h00FF, 16'h0001);
        TASK_SHR(16'h007F, 16'h0001);
        TASK_SHR(16'h003F, 16'h0001);
        TASK_SHR(16'h001F, 16'h0001);
        TASK_SHR(16'h000F, 16'h0001);
        TASK_SHR(16'h0007, 16'h0001);
        TASK_SHR(16'h0003, 16'h0001);
        TASK_SHR(16'h0001, 16'h0001);
        TASK_SHR(16'h0000, 16'h0001);

        $display("***** SAR ***** at %d", tb_cycle_counter);
        TASK_SAR(16'h0000, 16'h0000);
        TASK_SAR(16'h0000, 16'hFFFF);
        TASK_SAR(16'h8000, 16'h0000);
        TASK_SAR(16'hC000, 16'h0000);
        TASK_SAR(16'hE000, 16'h0000);
        TASK_SAR(16'hF000, 16'h0000);
        TASK_SAR(16'hF800, 16'h0000);
        TASK_SAR(16'hFC00, 16'h0000);
        TASK_SAR(16'hFE00, 16'h0000);
        TASK_SAR(16'hFF00, 16'h0000);
        TASK_SAR(16'hFF80, 16'h0000);
        TASK_SAR(16'hFFC0, 16'h0000);
        TASK_SAR(16'hFFE0, 16'h0000);
        TASK_SAR(16'hFFF0, 16'h0000);
        TASK_SAR(16'hFFF8, 16'h0000);
        TASK_SAR(16'hFFFC, 16'h0000);
        TASK_SAR(16'hFFFE, 16'h0000);
        TASK_SAR(16'hFFFF, 16'h0000);
        TASK_SAR(16'h7FFF, 16'h0000);
        TASK_SAR(16'h3FFF, 16'h0000);
        TASK_SAR(16'h1FFF, 16'h0000);
        TASK_SAR(16'h0FFF, 16'h0000);
        TASK_SAR(16'h07FF, 16'h0000);
        TASK_SAR(16'h03FF, 16'h0000);
        TASK_SAR(16'h01FF, 16'h0000);
        TASK_SAR(16'h00FF, 16'h0000);
        TASK_SAR(16'h007F, 16'h0000);
        TASK_SAR(16'h003F, 16'h0000);
        TASK_SAR(16'h001F, 16'h0000);
        TASK_SAR(16'h000F, 16'h0000);
        TASK_SAR(16'h0007, 16'h0000);
        TASK_SAR(16'h0003, 16'h0000);
        TASK_SAR(16'h0001, 16'h0000);
        TASK_SAR(16'h0000, 16'h0000);

        #(`TB_CYCLE * 12);
        // End of simulation
`ifdef IVERILOG
        $finish;
`elsif  MODELSIM
        $stop;
`else
        $finish;
`endif
    end
endmodule

