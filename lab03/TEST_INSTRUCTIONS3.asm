main:
    li t0, 5 
    li t1, 3 
    bne t0, t1, not_equal
    j continue

not_equal:
    li t2, 5

continue:
    bge t0, t1, greater_or_equal
    j continue2

greater_or_equal:
    li t1, 6

continue2:
    blt t0, t1, less_than
    j end_test

less_than:
    li t2, 10

end_test:
    nop