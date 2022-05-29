# This example demonstrates an implementation of KMP's algorithm for pattern searching.
# We provided an input string and a pattern in global for simplfy.
# Reference link : https://www.geeksforgeeks.org/kmp-algorithm-for-pattern-searching/?ref=gcse
# The ouput of test pattern 1 should be =>  Found pattern at index 10
#                                       Found pattern at index 15 
# The ouput of test pattern 2 should be =>  Found pattern at index 0 
#                                       Found pattern at index 9 
#                                       Found pattern at index 15 


.data
.align 4
# test pattern 1
inputText: .string "ABABDABACDABABCABABC"
pattern: .string "ABABC"
inputSize: .word 20
patternSize: .word 5
# test pattern 2
# inputText: .string "ACGTCTGTAACGTCCACGCTC"
# pattern: .string "ACG"
# inputSize: .word 21
# patternSize: .word 3
str: .string "Found pattern at index "
newline: .string "\n"
.text
.global _start
# Start your coding below, don't change anything upper.

_start:

computeLPSArray:
    addi    sp,sp,-64
    sd      s0,56(sp)
    addi    s0,sp,64
    
    sd      a0,-40(s0)
    sw      a1,-44(s0)          # M -> (patternSize)
    sd      a2,-56(s0)
    sw      zero,-20(s0)        # len = 0
    ld      a5,-56(s0)
    sw      zero,0(a5)          # lps[0] = 0
    addi    a5,zero,1
    sw      a5,-24(s0)          # i = 1
    j       .L2

.L2:
    lw      a4,-24(s0)      # i
    lw      a5,-44(s0)      # M
    #   sext.w  a4,a4 
    #   sext.w  a5,a5
    blt     a4,a5,.L3
    #   nop
    #   nop

    ld      s0,56(sp)
    addi    sp,sp,64
    jr      ra

.L3:
    lw      a5,-24(s0)      
    ld      a4,-40(s0)      
    add     a5,a4,a5
    lb      a3,0(a5)            # pat[i]
    lw      a5,-20(s0)
    ld      a4,-40(s0)
    add     a5,a4,a5
    lb      a5,0(a5)            # pat[len]

    bne     a3,a5,.L4

    lw      a5,-20(s0)
    addi    a5,a5,1
    sw      a5,-20(s0)          # len++
    lw      a5,-24(s0)
    slli    a5,a5,2
    ld      a4,-56(s0)
    add     a5,a4,a5            # lps[i]
    lw      a4,-20(s0)
    sw      a4,0(a5)            # lps[i] = len
    lw      a5,-24(s0)
    addi    a5,a5,1
    sw      a5,-24(s0)          # i++
    j       .L2

.L4:
    lw      a5,-20(s0)
    #    sext.w  a5,a5
    beq     a5,zero,.L5

    lw      a5,-20(s0)
    addi    a5,a5,-1
    slli    a5,a5,2
    ld      a4,-56(s0)
    add     a5,a4,a5            # lps[len-1]
    sw      a5,-20(s0)          # len = lps[len-1]
    j       .L2

.L5:
    lw      a5,-24(s0)
    slli    a5,a5,2
    ld      a4,-56(s0)
    add     a5,a4,a5            # lps[i]
    sw      zero,0(a5)          # lps[i] = 0
    lw      a5,-24(s0)          
    addi    a5,a5,1
    sw      a5,-24(s0)          # i++
    j       .L2

KMPSearch:
    addi    sp,sp,-48
    sd      ra,40(sp)
    sd      s0,32(sp)
    addi    s0,sp,48

    addi    a5,s0,-48       
    mv      a2,a5
    li      a1,inputSize
    lui     a5,%hi(pattern)
    addi    a0,a5,%lo(pattern)
    call    computeLPSArray(char*, int, int*)
    sw      zero,-20(s0)
    sw      zero,-24(s0)
    j       .L6

.L6:
    lw      a4,-20(s0)
#    sext.w  a4,a5
    li      a5,20
    ble     a4,a5,.L7          # i < inputSize
#    nop
#    nop
    ld      ra,40(sp)
    ld      s0,32(sp)
    addi    sp,sp,48
    jr      ra

.L7:
    lui     a5,%hi(pattern)
    addi    a5,a5,%lo(pattern)
    lw      a4,-24(s0)
    add     a5,a4,a5
    lb      a3,0(a5)            # pattern[j]
    lui     a5,%hi(inputText)
    addi    a5,a5,%lo(inputText)
    lw      a4,-20(s0)
    add     a5,a4,a5
    lb      a5,0(a5)            # inputText[i]
    bne     a3,a5,.L8

    lw      a5,-24(s0)
    addiw   a5,a5,1
    sw      a5,-24(s0)          # j++
    lw      a5,-20(s0)
    addiw   a5,a5,1
    sw      a5,-20(s0)          # i++
    j       .L8

.L8:
    lw      a4,-24(s0)
#    sext.w  a4,a5
    li      a5,patternSize
    bne     a4,a5,.L9           # j != 5

    lw      a4,-20(s0)
    lw      a5,-24(s0)
    subw    a5,a4,a5
#    sext.w  a5,a5
    mv      a1,a5
    lui     a5,%hi(str)
    addi    a0,a5,%lo(str)
    call    printf

    lw      a5,-24(s0)
    addiw   a5,a5,-1
#    sext.w  a5,a5
    slli    a5,a5,2
    add     a5,a5,s0
    lw      a5,-56(a5)
    sw      a5,-24(s0)          # j = lps[j-1]
    j       .L6

.L9:
    lw      a4,-20(s0)
#    sext.w  a4,a5
    li      a5,(inputSize-1)
    bgt     a4,a5,.L6

    lui     a5,%hi(pattern)
    addi    a5,a5,%lo(pattern)
    lw      a4,-24(s0)
    add     a5,a4,a5
    lb      a3,0(a5)            # pattern[j]
    lui     a5,%hi(inputText)
    addi    a5,a5,%lo(inputText)
    lw      a4,-20(s0)
    add     a5,a4,a5
    lb      a5,0(a5)            # inputText[i]
    beq     a3,a5,.L6

    lw      a5,-24(s0)
    sext.w  a5,a5
    beq     a5,zero,.L10        # j == 0

    lw      a5,-24(s0)
    addiw   a5,a5,-1
#    sext.w  a5,a5
    slli    a5,a5,2
    add     a5,a5,s0
    lw      a5,-56(a5)
    sw      a5,-24(s0)
    j       .L6

.L10:
    lw      a5,-20(s0)
    addiw   a5,a5,1
    sw      a5,-20(s0)
    j       .L6
    

