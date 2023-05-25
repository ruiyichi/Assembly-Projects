input   DCD     0x9ABC1234;
a_value DCD     0; multiplicand. The unpacked, sign-extended value of A
b_value DCD     0; multiplier. The unpacked, sign-extended value of B

        ;       PLACE YOUR CODE BELOW THIS LINE!!!!
        mov     r0, #input
        ldr     r1, [r0]; load input into r1
        asr     r1, r1, #16; shift right 16 places and copy sign bit

        mov     r0, #a_value; save in a_value
        str     r1, [r0]

        mov     r2, #input
        ldr     r3, [r2]; load input into r3

        lsl     r3, r3, #16; shift bits left 16 places to clear out first 16 bits
        asr     r3, r3, #16; shift bits back right 16 places and copy sign bit

        mov     r2, #b_value; save in b_value
        str     r3, [r2]