arch n64.cpu
endian msb
output "nes.z64", create

constant N64_ROM_SIZE = $100000
fill N64_ROM_SIZE + $1000       // set rom size. minimum size (?) since the boot code will do a PI DMA of this size
origin $0                       // rom location
base $80000000                  // signed displacement against origin, used when computing the pc value for labels

include "n64.inc"
include "util.inc"

include "n64_header.asm"
include "n64_boot.asm"

define CARRY_PTR        = 0(status_ptr_reg)
define ZERO_PTR         = 1(status_ptr_reg)
define IRQ_DISABLE_PTR  = 2(status_ptr_reg)
define DECIMAL_PTR      = 3(status_ptr_reg)
define B_PTR            = 4(status_ptr_reg)
define OVERFLOW_PTR     = 6(status_ptr_reg)
define NEG_PTR          = 7(status_ptr_reg)

constant CPU_CYCLES_PER_STEP = 1000

constant cycle_counter      = k0
constant status_ptr_reg     = k1
constant a                  = fp
constant x                  = gp
constant y                  = s7
constant pc                 = s6
constant nes_sp             = s5

cpu_a:
	db 0

cpu_x:
	db 0

cpu_y:
	db 0

cpu_sp:
    db 0

cpu_pc:
    dh 0

cpu_carry:
    db 0

cpu_zero:
    db 0

cpu_irq_disable:
    db 0

cpu_decimal:
    db 0

cpu_b:
    db 0

cpu_overflow:
    db 0

cpu_neg:
    db 0

cpu_cycle_counter:
    dw 0

cpu_stopped:
    db 0

cpu_ram:
    data_array($800)

cpu_read_sq1_vol:
cpu_read_sq1_sweep:
cpu_read_sq1_lo:
cpu_read_sq1_hi:
cpu_read_sq2_vol:
cpu_read_sq2_sweep:
cpu_read_sq2_lo:
cpu_read_sq2_hi:
cpu_read_tri_linear:
cpu_read_apu_4009:
cpu_read_tri_lo:
cpu_read_tri_hi:
cpu_read_noise_vol:
cpu_read_apu_4000d:
cpu_read_noise_lo:
cpu_read_noise_hi:
cpu_read_dmc_freq:
cpu_read_dmc_raw:
cpu_read_dmc_start:
cpu_read_dmc_len:
cpu_read_oamdma:
cpu_read_apu_stat:
cpu_read_joy1:
cpu_read_joy2:
cpu_read_apu_debug:
cpu_write_sq1_vol:
cpu_write_sq1_sweep:
cpu_write_sq1_lo:
cpu_write_sq1_hi:
cpu_write_sq2_vol:
cpu_write_sq2_sweep:
cpu_write_sq2_lo:
cpu_write_sq2_hi:
cpu_write_tri_linear:
cpu_write_apu_4009:
cpu_write_tri_lo:
cpu_write_tri_hi:
cpu_write_noise_vol:
cpu_write_apu_4000d:
cpu_write_noise_lo:
cpu_write_noise_hi:
cpu_write_dmc_freq:
cpu_write_dmc_raw:
cpu_write_dmc_start:
cpu_write_dmc_len:
cpu_write_oamdma:
cpu_write_apu_stat:
cpu_write_joy1:
cpu_write_joy2:
cpu_write_apu_debug:

cart_read_prg:

cart_write_prg:

ppu_read_reg:

ppu_write_reg:

cpu_instr_table:

cpu_read_apu_io_table:
    dw cpu_read_sq1_vol         // $4000
    dw cpu_read_sq1_sweep       // $4001
    dw cpu_read_sq1_lo          // $4002
    dw cpu_read_sq1_hi          // $4003
    dw cpu_read_sq2_vol         // $4004
    dw cpu_read_sq2_sweep       // $4005
    dw cpu_read_sq2_lo          // $4006
    dw cpu_read_sq2_hi          // $4007
    dw cpu_read_tri_linear      // $4008
    dw cpu_read_apu_4009        // $4009
    dw cpu_read_tri_lo          // $400a
    dw cpu_read_tri_hi          // $400b
    dw cpu_read_noise_vol       // $400c
    dw cpu_read_apu_4000d       // $400d
    dw cpu_read_noise_lo        // $400e
    dw cpu_read_noise_hi        // $400f
    dw cpu_read_dmc_freq        // $4010
    dw cpu_read_dmc_raw         // $4011
    dw cpu_read_dmc_start       // $4012
    dw cpu_read_dmc_len         // $4013
    dw cpu_read_oamdma          // $4014
    dw cpu_read_apu_stat        // $4015
    dw cpu_read_joy1            // $4016
    dw cpu_read_joy2            // $4017
    dw cpu_read_apu_debug       // $4018
    dw cpu_read_apu_debug       // $4019
    dw cpu_read_apu_debug       // $401a
    dw cpu_read_apu_debug       // $401b
    dw cpu_read_apu_debug       // $401c
    dw cpu_read_apu_debug       // $401d
    dw cpu_read_apu_debug       // $401e
    dw cpu_read_apu_debug       // $401f

cpu_write_apu_io_table:
    dw cpu_write_sq1_vol        // $4000
    dw cpu_write_sq1_sweep      // $4001
    dw cpu_write_sq1_lo         // $4002
    dw cpu_write_sq1_hi         // $4003
    dw cpu_write_sq2_vol        // $4004
    dw cpu_write_sq2_sweep      // $4005
    dw cpu_write_sq2_lo         // $4006
    dw cpu_write_sq2_hi         // $4007
    dw cpu_write_tri_linear     // $4008
    dw cpu_write_apu_4009       // $4009
    dw cpu_write_tri_lo         // $400a
    dw cpu_write_tri_hi         // $400b
    dw cpu_write_noise_vol      // $400c
    dw cpu_write_apu_4000d      // $400d
    dw cpu_write_noise_lo       // $400e
    dw cpu_write_noise_hi       // $400f
    dw cpu_write_dmc_freq       // $4010
    dw cpu_write_dmc_raw        // $4011
    dw cpu_write_dmc_start      // $4012
    dw cpu_write_dmc_len        // $4013
    dw cpu_write_oamdma         // $4014
    dw cpu_write_apu_stat       // $4015
    dw cpu_write_joy1           // $4016
    dw cpu_write_joy2           // $4017
    dw cpu_write_apu_debug      // $4018
    dw cpu_write_apu_debug      // $4019
    dw cpu_write_apu_debug      // $401a
    dw cpu_write_apu_debug      // $401b
    dw cpu_write_apu_debug      // $401c
    dw cpu_write_apu_debug      // $401d
    dw cpu_write_apu_debug      // $401e
    dw cpu_write_apu_debug      // $401f

instr_begin:

cpu_init:  // void()
    la      t0, cpu_a
    sb      zero, 0(t0)
    la      t0, cpu_x
    sb      zero, 0(t0)
    la      t0, cpu_y
    sb      zero, 0(t0)

    ori     t1, zero, 1
    la      t0, cpu_carry
    sb      zero, 0(t0)
    la      t0, cpu_zero
    sb      zero, 0(t0)
    la      t0, cpu_irq_disable
    sb      t1, 0(t0)
    la      t0, cpu_decimal
    sb      zero, 0(t0)
    la      t0, cpu_b
    sb      t1, 0(t0)
    la      t0, cpu_overflow
    sb      zero, 0(t0)
    la      t0, cpu_neg
    sb      zero, 0(t0)

    la      t0, cpu_sp
    ori     t1, zero, $fd
    lb      t1, 0(t0)

cpu_run:  // void()
    la      t0, cpu_stopped
    lb      t0, 0(t0)
    beql    t0, zero, cpu_do_run
    nop
    jr      ra
    nop
cpu_do_run:
    daddiu  sp, sp, -16
    sd      ra, 0(sp)
    sd      s0, 8(sp)
    la      s0, cpu_instr_table
    move    cycle_counter, zero
    la      t0, cpu_a
    lbu     a, 0(t0)
    la      t0, cpu_x
    lbu     x, 0(t0)
    la      t0, cpu_y
    lbu     y, 0(t0)
cpu_run_loop:
    jal     cpu_read
    move    a0, pc
    addiu   pc, pc, 1
    sll     v0, v0, 2
    addiu   t0, s0, v0
    lw      t0, 0(t0)
    jalr    t0
    andi    pc, pc, $ffff
    slti    t0, cycle_counter, CPU_CYCLES_PER_STEP
    bnel    t0, zero, cpu_run_loop
    nop
cpu_run_end:
    ld      ra, 0(sp)
    ld      s0, 8(sp)
    jr      ra
    daddiu  sp, sp, 16

cpu_read:  // byte(hword address)
    addi    cycle_counter, cycle_counter, 1
cpu_read_cart:  // $4020-$ffff
    slti    t0, a0, $4020
    bnel    t0, zero, cpu_read_ppu
    nop
    j       cart_read_prg
    nop
cpu_read_ppu:  // $2000-$3fff
    slti    t0, a0, $4000
    beql    t0, zero, cpu_read_apu_io
    nop
    j       ppu_read_reg
    andi    a0, a0, $2007
cpu_read_apu_io:  // $4000-$401f
    la      t0, cpu_read_apu_io_table
    andi    t1, a0, $1f
    sll     t1, t1, 2
    daddu   t0, t0, t1
    lw      t0, 0(t0)
    jr      t0
    nop

cpu_write:  // void(hword address, byte value)
    addi    cycle_counter, cycle_counter, 1
cpu_write_ram:  // 0-$1fff
    slti    t0, a0, $2000
    beq     t0, zero, cpu_write_cart
    la      t0, cpu_ram
    andi    a0, a0, $7ff
    daddu   t0, t0, a0
    jr      ra
    sb      a1, 0(t0)
cpu_write_cart:  // $4020-$ffff
    slti    t0, a0, $4020
    bnel    t0, zero, cpu_write_ppu
    nop
    j       cart_write_prg
    nop
cpu_write_ppu:  // $2000-$3fff
    slti    t0, a0, $4000
    beql    t0, zero, cpu_write_apu_io
    nop
    j       ppu_write_reg
    andi    a0, a0, $2007
cpu_write_apu_io:  // $4000-$4017
    la      t0, cpu_write_apu_io_table
    andi    t1, a0, $1f
    sll     t1, t1, 2
    daddu   t0, t0, t1
    lw      t0, 0(t0)
    jr      t0
    nop

cpu_adc:  // void(byte operand)
    lb      t0, {CARRY_PTR}
    addu    t1, a, a0
    addu    t1, t1, t0
    xor     t2, t1, a
    xor     t3, t1, a0
    and     t2, t2, t3
    srl     t2, t2, 7
    sb      t2, {OVERFLOW_PTR}
    andi    a, t1, $ff
    srl     t0, t1, 8
    sb      t0, {CARRY_PTR}
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_and:  // void(byte operand)
    and     a, a, a0
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_asl_a:  // void()
    srl     t0, a, 7
    sb      t0, {CARRY_PTR}
    sll     a, a, 1
    andi    a, a, $ff
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_asl_m:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    srl     t0, a1, 7
    sb      t0, {CARRY_PTR}
    sll     a1, a1, 1
    andi    a1, a1, $ff
    slti    t0, a1, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a1, 7
    j       cpu_write
    sb      t0, {NEG_PTR}

cpu_bcc:  // void()
    lb      t0, {CARRY_PTR}
    beql    t0, zero, branch
    nop
    jr      ra
    nop

cpu_bcs:  // void()
    lb      t0, {CARRY_PTR}
    bnel    t0, zero, branch
    nop
    jr      ra
    nop

cpu_beq:  // void()
    lb      t0, {ZERO_PTR}
    bnel    t0, zero, branch
    nop
    jr      ra
    nop

cpu_bit:  // void(byte operand)
    and     t0, a, a0
    slti    t0, t0, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a0, 6
    andi    t0, t0, 1
    sb      t0, {OVERFLOW_PTR}
    srl     t0, a0, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_bpl:  // void()
    lb      t0, {NEG_PTR}
    beql    t0, zero, branch
    nop
    jr      ra
    nop
    
cpu_brk:  // void()
    // TODO

cpu_bvc:  // void()
    lb      t0, {OVERFLOW_PTR}
    beql    t0, zero, branch
    nop
    jr      ra
    nop

cpu_bvs:  // void()
    lb      t0, {OVERFLOW_PTR}
    bnel    t0, zero, branch
    nop
    jr      ra
    nop

cpu_clc:  // void()
    jr      ra
    sb      zero, {CARRY_PTR}

cpu_cld:  // void()
    jr      ra
    sb      zero, {DECIMAL_PTR}

cpu_cli:  // void()
    jr      ra
    sb      zero, {IRQ_DISABLE_PTR}

cpu_clv:  // void()
    jr      ra
    sb      zero, {OVERFLOW_PTR}

cpu_cmp:  // void(byte operand)
    subu    t0, a, a0
    slti    t1, t0, 0
    sltiu   t2, t0, 1
    or      t1, t1, t2
    sb      t1, {CARRY_PTR}    
    sb      t2, {ZERO_PTR}
    srl     t0, t0, 7
    andi    t0, t0, 1
    jr      ra
    sb      t0, {NEG_PTR}

cpu_cpx:  // void(byte operand)
    subu    t0, x, a0
    slti    t1, t0, 0
    sltiu   t2, t0, 1
    or      t1, t1, t2
    sb      t1, {CARRY_PTR}    
    sb      t2, {ZERO_PTR}
    srl     t0, t0, 7
    andi    t0, t0, 1
    jr      ra
    sb      t0, {NEG_PTR}

cpu_cpy:  // void(byte operand)
    subu    t0, y, a0
    slti    t1, t0, 0
    sltiu   t2, t0, 1
    or      t1, t1, t2
    sb      t1, {CARRY_PTR}    
    sb      t2, {ZERO_PTR}
    srl     t0, t0, 7
    andi    t0, t0, 1
    jr      ra
    sb      t0, {NEG_PTR}
    
cpu_dec:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    addiu   a1, a1, -1
    andi    a1, a1, $ff
    slti    t0, a1, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a1, 7
    j       cpu_write
    sb      t0, {NEG_PTR}

cpu_dex:  // void()
    addiu   x, x, -1
    andi    x, x, $ff
    slti    t0, x, 1
    sb      t0, {ZERO_PTR}
    srl     t0, x, 7
    jr      ra
    sb      t0, {NEG_PTR}
        
cpu_dey:  // void()
    addiu   y, y, -1
    andi    y, y, $ff
    slti    t0, y, 1
    sb      t0, {ZERO_PTR}
    srl     t0, y, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_eor:  // void(byte operand)
    xor     a, a, a0
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_inc:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    addiu   a1, a1, 1
    andi    a1, a1, $ff
    slti    t0, a1, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a1, 7
    j       cpu_write
    sb      t0, {NEG_PTR}

cpu_inx:  // void()
    addiu   x, x, 1
    andi    x, x, $ff
    slti    t0, x, 1
    sb      t0, {ZERO_PTR}
    srl     t0, x, 7
    jr      ra
    sb      t0, {NEG_PTR}
        
cpu_iny:  // void()
    addiu   y, y, 1
    andi    y, y, $ff
    slti    t0, y, 1
    sb      t0, {ZERO_PTR}
    srl     t0, y, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_jmp:  // void(hword address)
    jr      ra
    move    pc, a0

cpu_jsr:  // void(hword address)
    daddiu  sp, sp, -16
    sd      ra, 0(sp)
    sd      s0, 8(sp)
    move    s0, a0
    addiu   pc, pc, -1
    andi    pc, pc, $ffff
    jal     cpu_push_byte
    srl     a0, pc, 8
    jal     cpu_push_byte
    andi    a0, pc, $ff
    move    pc, s0
    addi    cycle_counter, cycle_counter, 1
    ld      ra, 0(sp)
    ld      s0, 8(sp)
    jr      ra
    daddiu  sp, sp, 16

cpu_lda:  // void(byte operand)
    move    a, a0
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_ldx:  // void(byte operand)
    move    x, a0
    slti    t0, x, 1
    sb      t0, {ZERO_PTR}
    srl     t0, x, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_ldy:  // void(byte operand)
    move    y, a0
    slti    t0, y, 1
    sb      t0, {ZERO_PTR}
    srl     t0, y, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_lsr_a:  // void()
    andi    t0, a, 1
    sb      t0, {CARRY_PTR}
    srl     a, a, 1
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    jr      ra
    sb      zero, {NEG_PTR}

cpu_lsr_m:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    andi    t0, a1, 1
    sb      t0, {CARRY_PTR}
    srl     a1, a1, 1
    slti    t0, a1, 1
    sb      t0, {ZERO_PTR}
    j       cpu_write
    sb      zero, {NEG_PTR}

cpu_nop:  // void()
    jr      ra
    nop

cpu_ora:  // void(byte operand)
    or      a, a, a0
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_pha:  // void()
    j       cpu_push_byte
    move    a0, a

cpu_php:  // void()
    daddiu  sp, sp, -8
    sd      ra, 0(sp)
    jal     get_status_as_byte
    nop
    sd      ra, 0(sp)
    daddiu  sp, sp, 8
    j       cpu_push_byte
    ori     a0, v0, $30

cpu_pla:  // void()
    daddiu  sp, sp, -8
    sd      ra, 0(sp)
    jal     cpu_pop_byte
    addi    cycle_counter, cycle_counter, 1
    move    a, v0
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    sb      t0, {NEG_PTR}
    ld      ra, 0(sp)
    jr      ra
    daddiu  sp, sp, 8

cpu_plp:  // void()
    daddiu  sp, sp, -8
    sd      ra, 0(sp)
    jal     cpu_pop_byte
    addi    cycle_counter, cycle_counter, 1
    move    a0, v0
    sd      ra, 0(sp)
    j       set_status_as_byte
    daddiu  sp, sp, 8

cpu_rol_a:  // void()
    lb      t0, {CARRY_PTR}
    srl     t1, a, 7
    sb      t1, {CARRY_PTR}
    sll     a, a, 1
    or      a, a, t0
    andi    a, a, $ff
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_rol_m:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    lb      t0, {CARRY_PTR}
    srl     t1, a1, 7
    sb      t1, {CARRY_PTR}
    sll     a1, a1, 1
    or      a1, a1, t0
    andi    a1, a1, $ff
    slti    t0, a1, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a1, 7
    j       cpu_write
    sb      t0, {NEG_PTR}

cpu_ror_a:  // void()
    lb      t0, {CARRY_PTR}
    sb      t0, {NEG_PTR}
    andi    t1, a, 1
    sb      t1, {CARRY_PTR}
    sll     t0, t0, 7
    srl     a, a, 1
    or      a, a, t0
    slti    t0, a, 1
    jr      ra
    sb      t0, {ZERO_PTR}

cpu_ror_m:  // void(hword address, byte operand)
    addi    cycle_counter, cycle_counter, 1
    lb      t0, {CARRY_PTR}
    sb      t0, {NEG_PTR}
    andi    t1, a1, 1
    sb      t1, {CARRY_PTR}
    sll     t0, t0, 7
    srl     a1, a1, 1
    or      a1, a1, t0
    slti    t0, a1, 1
    j       cpu_write
    sb      t0, {ZERO_PTR}

cpu_rti:  // void()
    daddiu  sp, sp, -16
    sd      ra, 0(sp)
    jal     cpu_pop_byte
    sd      s0, 8(sp)
    jal     set_status_as_byte
    move    a0, v0
    jal     cpu_pop_byte
    addi    cycle_counter, cycle_counter, 1
    jal     cpu_pop_byte
    move    s0, v0
    sll     pc, v0, 8
    or      pc, pc, s0
    ld      ra, 0(sp)
    ld      s0, 0(sp)
    jr      ra
    daddiu  sp, sp, 16

cpu_rts:  // void()
    daddiu  sp, sp, -16
    sd      ra, 0(sp)
    sd      s0, 0(sp)
    jal     cpu_pop_byte
    addi    cycle_counter, cycle_counter, 2
    jal     cpu_pop_byte
    move    s0, v0
    sll     pc, v0, 8
    or      pc, pc, s0
    addiu   pc, pc, 1
    andi    pc, pc, $ffff
    ld      ra, 0(sp)
    ld      s0, 0(sp)
    jr      ra
    daddiu  sp, sp, 16
    
cpu_sbc:  // void(byte operand)
    j       cpu_adc
    xori    a0, a0, $ff

cpu_sec:  // void()
    ori     t0, zero, 1
    jr      ra
    sb      t0, {CARRY_PTR}

cpu_sed:  // void()
    ori     t0, zero, 1
    jr      ra
    sb      t0, {DECIMAL_PTR}

cpu_sei:  // void()
    ori     t0, zero, 1
    jr      ra
    sb      t0, {IRQ_DISABLE_PTR}

cpu_sta:  // void(hword address)
    j       cpu_write
    move    a1, a

cpu_stx:  // void(hword address)
    j       cpu_write
    move    a1, x

cpu_sty:  // void(hword address)
    j       cpu_write
    move    a1, y

cpu_tax:  // void()
    move    x, a
    slti    t0, x, 1
    sb      t0, {ZERO_PTR}
    srl     t0, x, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_tay:  // void()
    move    y, a
    slti    t0, y, 1
    sb      t0, {ZERO_PTR}
    srl     t0, y, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_tsx:  // void()
    move    x, nes_sp
    slti    t0, x, 1
    sb      t0, {ZERO_PTR}
    srl     t0, x, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_txa:  // void()
    move    a, x
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

cpu_txs:  // void()
    jr      ra
    move    nes_sp, x

cpu_tya:  // void()
    move    a, y
    slti    t0, a, 1
    sb      t0, {ZERO_PTR}
    srl     t0, a, 7
    jr      ra
    sb      t0, {NEG_PTR}

branch:  // void(hword address)
    sll     a0, a0, 24
    sra     a0, a0, 24
    andi    a0, a0, $ffff
    andi    t0, pc, $ff00
    addiu   pc, pc, a0
    andi    pc, pc, $ffff
    andi    t1, pc, $ff00
    bnel    t0, t1, branch_0
    addi    cycle_counter, cycle_counter, 1  // extra cycle on page cross
branch_0:
    jr      ra
    addi    cycle_counter, cycle_counter, 1

cpu_service_interrupt:  // void()
    daddiu  sp, sp, -8
    sd      ra, 0(sp)
    jal     cpu_push_byte
    srl     a0, pc, 8
    jal     cpu_push_byte
    andi    a0, pc, $ff
    jal     get_status_as_byte
    addi    cycle_counter, cycle_counter, 2
    jal     cpu_push_byte
    ori     a0, v0, $20
    ori     t0, zero, 1
    sb      t0, {IRQ_DISABLE_PTR}
    // TODO
    jr      ra
    nop

cpu_pop_byte:  // byte()
    addiu   nes_sp, nes_sp, 1
    andi    nes_sp, nes_sp, $ff
    j       cpu_read
    ori     a0, nes_sp, $100    

cpu_push_byte:  // void(byte value)
    move    a1, a0
    addiu   nes_sp, nes_sp, -1
    andi    nes_sp, nes_sp, $ff
    j       cpu_write
    ori     a0, nes_sp, $100

get_status_as_byte:  // byte()
    move    v0, zero
    lb      t0, {NEG_PTR}
    or      v0, v0, t0
    sll     v0, v0, 1
    lb      t0, {OVERFLOW_PTR}
    or      v0, v0, t0
    sll     v0, v0, 3
    lb      t0, {DECIMAL_PTR}
    or      v0, v0, t0
    sll     v0, v0, 1
    lb      t0, {IRQ_DISABLE_PTR}
    or      v0, v0, t0
    sll     v0, v0, 1
    lb      t0, {ZERO_PTR}
    or      v0, v0, t0
    sll     v0, v0, 1
    lb      t0, {CARRY_PTR}
    jr      ra
    or      v0, v0, t0

set_status_as_byte:  // void(byte value)
    andi    t0, a0, 1
    sb      t0, {CARRY_PTR}
    srl     a0, a0, 1
    andi    t0, a0, 1
    sb      t0, {ZERO_PTR}
    srl     a0, a0, 1
    andi    t0, a0, 1
    sb      t0, {IRQ_DISABLE_PTR}
    srl     a0, a0, 1
    andi    t0, a0, 1
    sb      t0, {DECIMAL_PTR}
    srl     a0, a0, 1
    andi    t0, a0, 1
    sb      t0, {B_PTR}
    srl     a0, a0, 2
    andi    t0, a0, 1
    sb      t0, {OVERFLOW_PTR}
    srl     a0, a0, 1
    andi    t0, a0, 1
    jr      ra
    sb      t0, {NEG_PTR}