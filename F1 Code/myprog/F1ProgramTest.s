initialise:
    addi s1, zero, 0x0
    addi s2, s1, 0x1
    addi s3, s1, 0xff 
    addi s4, s1, 0x1 
    addi s5, s1, 0x1
    addi t0, s1, 0x0
    addi a6, s1, 0x1 

idle:
    bne  t0, s1, countdown 

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

    addi a2, s1, 0x0 
    addi a3, s1, 0x0 
    addi a4, s1, 0x0 
    addi a5, s1, 0x0 
    
    bne  s1, s2, idle 

delay:
    addi  a2, a2, 0x1   
    bne   a2, s4, delay
    addi  a2, s1, 0x0 
    RET

countdown: 

    jal ra, delay 

    slli t1, a0, 0x1  
    addi a0, t1, 0x1    
    bne  a0, s3, countdown 

    addi s6, s4, 0x0 
    addi s4, s5, 0x0  
    jal ra, delay
    addi s4, s6, 0x0 

ready: 
    addi s6, s4, 0x0 
    addi s4, a6, 0x0 
    jal ra, delay
    addi s4, s6, 0x0 

    addi a0, s1, 0x0
    addi t0, s1, 0x0 

    bne s1, s2, idle
