initialise:
    addi a6, zero, 0x1 
    addi s1, zero, 0x1
    addi s2, zero, 0xff 
    addi s3, zero, 0x1 
    addi s4, zero, 0x1
    addi t0, zero, 0x0

idle:
    bne  t0, zero, countdown 

    srli a2, a6, 0x1 
    andi a2, a2, 0x1 
    srli a3, a6, 0x2 
    andi a3, a3, 0x1 
    srli a4, a6, 0x3 
    andi a4, a4, 0x1 
    srli a5, a6, 0x7 
    andi a5, a5, 0x1 

    xor a4, a4, a5 
    xor a3, a3, a4 
    xor a2, a2, a3 

    slli a6, a6, 0x1 
    or a6, a6, a2 
    andi a6, a6, 0x000000ff

    addi a2, zero, 0x0 
    addi a3, zero, 0x0 
    addi a4, zero, 0x0 
    addi a5, zero, 0x0 
    
    bne  zero, s1, idle 

delay:
    addi  a2, a2, 0x1   
    bne   a2, s3, delay
    addi  a2, zero, 0x0 
    RET

countdown: 

    jal ra, delay 

    slli t1, a0, 0x1  
    addi a0, t1, 0x1    
    bne  a0, s2, countdown 

    addi s5, s3, 0x0 
    addi s3, s4, 0x0  
    jal ra, delay
    addi s3, s5, 0x0 

ready: 
    addi s5, s3, 0x0 
    addi s3, a6, 0x0 
    jal ra, delay
    addi s3, s5, 0x0 

    addi a0, zero, 0x0
    addi t0, zero, 0x0 

    bne zero, s1, idle
