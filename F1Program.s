initialise:
    addi a6, zero, 0x1 /* initial value of lfsr system */
    addi s1, zero, 0x1 /* checks trigger = 1 */
    addi s2, zero, 0xff /* checks all lights on */
    addi s3, zero, 0x1 /* determines number of cycles for one call of delay (make so that one call = 1s default) */
    addi s4, zero, 0x1 /* base case of 0.2s delay before GO */

idle:
    beq  t0, s1, countdown /* branch to countdown if triggered */

    /* LFSR based on 1 + X^2 + X^3 + X^4 + X^8 (Maximally long of 255 values) 
       will vary the the lights off whenever trigger is enabled 
       Runs one shift cycle */ 

    srli a2, a6, 0x1 /* retrieve X^2 */ 
    andi a2, a2, 0x1 
    srli a3, a6, 0x2 /* X^3 */
    andi a3, a3, 0x1 
    srli a4, a6, 0x3 /* X^4 */
    andi a4, a4, 0x1 
    srli a5, a6, 0x7 /* X^8 */
    andi a5, a5, 0x1 

    xor a4, a4, a5 /* X^4 + X^8
    xor a3, a3, a4 /* X^3 + X^4 + X^8
    xor a2, a2, a3 /* X^2 + X^3 + X^4 + X^8

    slli a6, a6, 0x1 /* push xor result into LSB of a6 */
    or a6, a6, a2 

    addi a2, zero, 0x0 /* clear registers */
    addi a3, zero, 0x0 
    addi a4, zero, 0x0 
    addi a5, zero, 0x0 
    
    beq  zero, zero, idle /* infinite loop */

delay:
    addi  a2, a2, 0x1   
    bne   a2, s3, delay
    addi  a2, zero, 0x0 
    RET

countdown: 
    /* push binary 1 to LSB every cycle e.g 1 ~ 11 ~ 111 ~ 1111 etc (for LEDS) */

    jal ra, delay /* 1s delay between lights */

    slli t1, a0, 0x1  
    addi a0, t1, 0x1    
    bne  a0, s2, countdown 

    addi s5, s3, 0x0 /* save 1s delay value temp */
    addi s3, s4, 0x0 /* replace for 0.2s delay */ 
    jal ra, delay
    addi s3, s5, 0x0 /* restore */ 

ready: 
    /* lights all on for 0.2 seconds, now adding a random delay */ 

    addi s5, s3, 0x0 /* save 1s delay value temp */
    addi s3, a6, 0x0 /* replace for random delay between 0~255 cycles */
    jal ra, delay
    addi s3, s5, 0x0 /* restore */ 

    /* turn off all lights, reset trigger, return to idle */
    addi a0, zero, 0x0
    addi t0, zero, 0x0 

    bne zero, zero, idle



/*
need 0.2-3 seconds delay

let 0.2 delay be lfsr result = 00000001
let 3 delay be lfsr result = 11111111

255 possible values

delay will vary between computers due to processing speed needs tuning for each pc 
*/