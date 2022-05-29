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
    addi    sp,sp,-16
    sd      ra,8(sp)
    sd      s0,0(sp)
    addi    s0,sp,16
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
    j       end                  #.L2

KMPSearch:
    addi    sp,sp,-48
    sd      ra,40(sp)
    sd      s0,32(sp)
    addi    s0,sp,48

    addi    a5,s0,-48       
    mv      a2,a5
    li      a1,20
    
    li      a3,3
    
    lui     a5,%hi(pattern)
    addi    a0,a5,%lo(pattern)
    
    li      a3,4
    
    jal    computeLPSArray
    sw      zero,-20(s0)
    sw      zero,-24(s0)
    j       end                #.L6

end:nop
