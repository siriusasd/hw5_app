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
inputText: .string "AAAAABAAABA"
pattern: .string "AAAA"
inputSize: .word 11
patternSize: .word 4
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
    addi    sp,sp,-16
    sd      ra,8(sp)
    sd      s0,0(sp)
    addi    s0,sp,1
    jal     KMPSearch
    li      a5,0
    mv      a0,a5
    ld      ra,8(sp)
    ld      s0,0(sp)
    addi    sp,sp,16
    j       end

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
    nop
    blt     a4,a5,.L3
    li      a6,10
    
    li a7,4
    ld a5,-56(s0)
    li t1,4
    nop
    add a5,a5,t1
    nop
    nop
    ld t1,0(a5)
    
    ld a5,-56(s0)
    li t2,8
    nop
    add a5,a5,t2
    nop
    nop
    ld t2,0(a5)
    
    ld a5,-56(s0)
    li t3,12
    nop
    add a5,a5,t3
    nop
    nop
    ld t3,0(a5)
    
    li      a6,9
    ld      s0,56(sp)
    addi    sp,sp,64
    jr      ra
    
.L3:
    lw      a5,-24(s0)  
    
    
    ld      a4,-40(s0)
    nop
    nop
    add     a5,a4,a5
    nop
    nop
    lb      a3,0(a5)            # pat[i]
    lw      a5,-20(s0)
    ld      a4,-40(s0)
    nop
    add     a4,a4,a5
    nop
    lb      a5,0(a4)            # pat[len]

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
    li      a6,10
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
    li      a1,11
    lui     a5,%hi(pattern)
    addi    a0,a5,%lo(pattern)
    jal    computeLPSArray
    sw      zero,-20(s0)
    sw      zero,-24(s0)
    
    
    li   a6,7  
    la a0, str
    li a7, 4
    ecall
    
    
    j       end                #.L6

end:nop
