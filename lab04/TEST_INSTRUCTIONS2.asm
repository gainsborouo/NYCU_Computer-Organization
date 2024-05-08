entry:
    addi a2, zero, 4    # load parameter for fib
    jal  fib            # jump to fib(3)
    jal  idle           # idle loop
idle:
    jal  x0, idle
fib:
    addi sp, sp, -12    # declare stack space
    sw   ra, 8(sp)      # ra is saved by callee
    sw   s0, 4(sp)      # sX is saved by callee
fib_if_zero_or_one:
    addi a0, zero, 0        # set return value a0 = 0
    beq  a2, zero, fib_fin  # n is a2, if a2 == 0, goto fib_fin
    addi a0, a0, 1          # set return value a0 = 1
    beq  a2, a0, fib_fin    # n is a2, if a2 == 1, goto fib_fin
fib_call_n_1:
    addi a2, a2, -1     # prepare for fib(n-1) call
    sw   a2, 0(sp)      # save n-1 to memory 
    jal  fib            # call fib(n-1)
    add  s0, a0, zero   # mov fib(n-1) to s0
fib_call_n_2:
    lw   a2, 0(sp)      # load n-1 from memory
    addi a2, a2, -1     # prepare for fib(n-2) call
    jal  fib            # call fib(n-2)
    add  a0, a0, s0     # a0 = fib(n-1) + fib(n-2)
fib_fin:
    lw   s0, 4(sp)      # restore s0
    lw   ra, 8(sp)      # restore ra
    addi sp, sp, 12     # restore sp
    jr   ra             # pseudo-asm === jalr x0, ra, 0
