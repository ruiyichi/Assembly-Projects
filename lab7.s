input                             DCD     0x9ABC1234;
a_value                           DCD     0; multiplicand. The unpacked, sign-extended value of A
b_value                           DCD     0; multiplier. The unpacked, sign-extended value of B
prod_is_neg                       DCD     0; Store 1 if product will be neg, store 0 if product will be positive
abs_A                             DCD     0; Intermediate value for a_value
abs_B                             DCD     0; Intermediate value for b_value
product                           DCD     0; product. The signed 32b result of a_value * b_value

                                  ;       PLACE YOUR CODE BELOW THIS LINE!!!!
                                  ;       code to unpack numbers
                                  ldr     r0, =input
                                  ldr     r1, [r0]; load input into r1
                                  asr     r1, r1, #16; shift right 16 places and copy sign bit

                                  ldr     r0, =a_value; save in a_value
                                  str     r1, [r0]

                                  ldr     r2, =input
                                  ldr     r3, [r2]; load input into r3

                                  lsl     r3, r3, #16; shift bits left 16 places to clear out first 16 bits
                                  asr     r3, r3, #16; shift bits back right 16 places and copy sign bit

                                  ldr     r2, =b_value; save in b_value
                                  str     r3, [r2]

                                  ;       multiplying code
                                  ldr     r0, =a_value
                                  ldr     r0, [r0]
                                  ldr     r1, =b_value
                                  ldr     r1, [r1]

                                  ldr     r3, =0; clear r3
                                  ldr     r4, =product

                                  ;       check if negative
                                  teq     r0, r1
                                  bmi     product_is_negative
                                  bpl     store_abs_values

store_abs_values                  
                                  ;       abs a
                                  cmp     r0, #0; check multiplicand for positive
                                  rsbmi   r0, r0, #0

                                  ldr     r5, =abs_A
                                  str     r0, [r5]; store abs_A to memory

                                  ;       abs b
                                  cmp     r1, #0; check multiplier for negative
                                  rsbmi   r1, r1, #0

                                  ldr     r7, =abs_B
                                  str     r1, [r7]; store abs_B to memory
                                  b       check_multiplier_equals_zero

product_is_negative               
                                  ldr     r5, =prod_is_neg
                                  ldr     r6, =1
                                  str     r6, [r5]
                                  b       store_abs_values

check_multiplier_equals_zero      
                                  cmp     r1, #0; check if multiplier is zero
                                  beq     store_product; multiplier == 0
                                  bne     lsb_equals_one; multiplier != 0

lsb_equals_one                    
                                  tst     r1, #1; check if lsb is 1
                                  beq     shift_multiplier_and_multiplicand; if lsb == 0
                                  bne     update_product; if lsb == 1

update_product                    
                                  add     r3, r3, r0; add multiplicand to product
                                  b       shift_multiplier_and_multiplicand

shift_multiplier_and_multiplicand 
                                  lsl     r0, r0, #1; shift multiplicand left 1
                                  lsr     r1, r1, #1; shift multiplier right 1
                                  b       check_multiplier_equals_zero

store_product                     
                                  cmp     r6, #1; check if product is negative
                                  rsbeq   r3, r3, #0
                                  str     r3, [r4]


