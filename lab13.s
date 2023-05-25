/*** asmEncrypt.s   ***/

#include <xc.h>

# Declare the following to be in data memory 
.data  

# Define the globals so that the C code can access them
# (in this lab we return the pointer, so strictly speaking,
# doesn't really need to be defined as global)
# .global cipherText
.type cipherText,%gnu_unique_object

.align
# space allocated for cipherText: 200 bytes, prefilled with 0xAA */
cipherText: .space 200,0xAA  

# Tell the assembler that what follows is in instruction memory    
.text
.align

# Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )

where:
     input:
     ptrToInputText: location of first character in null-terminated
		     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.

     output:
     pointerToCipherText: mem location (address) of first character of
			  encrypted text. Returned in r0

     function description: asmEncrypt reads each character of an input
			   string, uses a shifted alphabet to encrypt it,
			   and stores the new character value in memory
			   location beginning at "cipherText". After copying
			   a character to cipherText, a pointer is incremented 
			   so that the next letter is stored in the bext byte.
			   Only encrypt characters in the range [a-zA-Z].
			   Any other characters should just be copied as-is
			   without modifications
			   Stop processing the input string when a NULL (0)
			   byte is reached. Make sure to add the NULL at the
			   end of the cipherText string.

     notes:
	The return value will always be the mem location defined by
	the label "cipherText".


********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   
    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}

    /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    /* I think all the code works */
    /* load memory loc of cipherText into r7 */
    ldr r7, =cipherText
    /* save the starting loc of cipherText */
    ldr r8, =cipherText
    
    b testCharacter
    
    testCharacter:
	/* get current byte of string */
	ldrb r2, [r0]
	/* check if character is 0 */
	cmp r2, 0
	/* if 0 store 0 to cipherText and return */
	strbeq r2, [r7]
	beq done
	/* start testing if characters are a-z and A-Z */
	bne testa

    continueLoop:
	/* store r2 character to memory */
	strb r2, [r7]
	/* increment pointer of og string by a byte */
	add r0,r0,0x1
	/* increment pointer of memory string by a byte */
	add r7,r7,0x1
	/* loop again */
	b testCharacter

    /* test if character is greater than or equal to 97 (a) */
    testa:
	cmp r2, 97
	bpl testz
	bmi testA

    /* test if character is less than or equal to 123 (z + 1) */
    testz:
	cmp r2, 123
	bmi encryptLowercaseCharacter
	bpl continueLoop

    /* test if character is greater than or equal to 65 (A) */
    testA:
	cmp r2, 65
	bpl testZ
	bmi continueLoop

    /* test if character is less than or equal to 91 (Z + 1) */
    testZ:
	cmp r2, 91
	bmi encryptUppercaseCharacter
	bpl continueLoop

    encryptUppercaseCharacter:
	/* add the key to the character */
	add r2,r2,r1
	/* subtract 26 to loop back if too large */
	cmp r2, 91
	subpl r2,r2,26
	b continueLoop
    
    encryptLowercaseCharacter:
	/* add the key to the character */
	add r2,r2,r1
	/* subtract 26 to loop back if too large */
	cmp r2, 123
	subpl r2,r2,26
	b continueLoop
    
    done:
	mov r0, r8
    

    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmEncrypt return to caller */


/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
