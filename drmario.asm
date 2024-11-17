################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Charles Feng, 1009082680
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       2
# - Unit height in pixels:      2
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    li $t1, 0xA9A9A9        # $t1 = grey
    li $t2, 0               # i for loops
    li $t7, 0xffff00        # yellow
    li $t8, 0x00ff00        # green
    li $t9, 0x0000ff        # blue
    
    lw $t0, ADDR_DSPL       # init address
    li $t3, 3               # loop constraints
    li $t4, 0               # address to loop with, change every loops
    addi $t4, $t0, 424      # init the begin point

# all loop and pre_loop are using to draw medicine bottle
loop1:
    beq $t2, $t3, pre_loop2 # 3 times for loop
    sw $t1, 0($t4)          # draw
    addi $t4, $t4, 128      # t4 += 128, load next pixel value into t4
    addi $t2, $t2, 1        # i++
    j loop1                 # next iteration
pre_loop2:
    li $t2, 0               # reset i
    li $t3, 6               # reset constraints
    li $t6, 128             # prepare for sub
    sub $t4, $t4, $t6       # t4 -= 128, one more 128 was added in the last loop
    li $t5, 4               # prepare for sub
    sub $t4, $t4, $t5       # t4 -= 4, prepare for first draw in loop2
loop2:
    beq $t2, $t3, pre_loop3 # 7 times for loop
    sw $t1, 0($t4)          # draw
    sub $t4, $t4, $t5       # t4 -= 4, load next value
    addi $t2, $t2, 1        # i++
    j loop2                 # next iteration
pre_loop3:       
    li $t2, 0               # reset i
    li $t3, 23              # reset constraints
loop3:
    beq $t2, $t3, pre_loop4 # 23 time loops
    sw $t1, 0($t4)          # draw
    add $t4, $t4, $t6       # t4 += 128, load next value
    addi $t2, $t2, 1        # i++
    j loop3
pre_loop4:
    li $t2, 0               # reset i
    li $t3, 18              # reset constraints
loop4:
    beq $t2, $t3, pre_loop5 # 18 time loops
    sw $t1, 0($t4)          # draw
    addi $t4, $t4, 4        # t4 += 4, load next value
    addi $t2, $t2, 1        # i++
    j loop4
pre_loop5:
    li $t2, 0               # reset i
    li $t3, 23              # reset constraints
loop5:
    beq $t2, $t3, pre_loop6 # 23 time loops
    sw $t1, 0($t4)          # draw
    sub $t4, $t4, $t6       # t4 -= 128, load next value
    addi $t2, $t2, 1        # i++
    j loop5
pre_loop6:
    li $t2, 0               # reset i
    li $t3, 7               # reset constraints
loop6:
    beq $t2, $t3, pre_loop7 # 7 time loops
    sw $t1, 0($t4)          # draw
    sub $t4, $t4, $t5       # t4 -= 4, load next value
    addi $t2, $t2, 1        # i++
    j loop6
pre_loop7:
    li $t2, 0               # reset i
    li $t3, 3               # reset constraints
loop7:
    beq $t2, $t3, capsule_init      # 7 time loops
    sw $t1, 0($t4)          # draw
    sub $t4, $t4, $t6       # t4 -= 128, load next value
    addi $t2, $t2, 1        # i++
    j loop7
capsule_init:
    addi $t4, $t0, 432      # new capsule position(top part)
    li $t2, 0               # reset i
    li $t3, 2               # reset constraints
draw_init_cap:
    beq $t2, $t3, next_capsule      # 2 time loops
    li $v0, 42
    li $a0, 0
    li $a1, 3               # generate a random integer between 0 and 2(inclusive)
    syscall                 # generate a random int
    beq $a0, 0, draw_green  
    beq $a0, 1, draw_yellow
    beq $a0, 2, draw_blue   # jump to draw based on randomized int
draw_green:
    sw $t8, 0($t4)          # draw a green pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_init_cap
draw_yellow:
    sw $t7, 0($t4)          # draw a yellow pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_init_cap
draw_blue:
    sw $t9, 0($t4)          # draw a blue pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_init_cap
next_capsule:
    addi $t5, $t0, 880      # next capsule position(top part)
    li $t2, 0               # reset i
    li $t3, 2               # reset constraints
draw_next_cap:
    beq $t2, $t3, generate_virus      # 2 time loops
    li $v0, 42
    li $a0, 0
    li $a1, 3               # generate a random integer between 0 and 2(inclusive)
    syscall                 # generate a random int
    beq $a0, 0, green  
    beq $a0, 1, yellow
    beq $a0, 2, blue        # jump to draw based on randomized int
green:
    sw $t8, 0($t5)          # draw a green pixel
    addi $t5, $t5, 128      # t5 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_next_cap
yellow:
    sw $t7, 0($t5)          # draw a yellow pixel
    addi $t5, $t5, 128      # t5 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_next_cap
blue:
    sw $t9, 0($t5)          # draw a blue pixel
    addi $t5, $t5, 128      # t5 += 128, load the next index
    addi $t2, $t2, 1        # i++
    j draw_next_cap
generate_virus:
    li $t2, 0               # reset i
    li $v0, 42
    li $a0, 0
    li $a1, 7               # generate a random integer between 0 and 6(inclusive)
    syscall                 # generate a random int
    add $t3, $zero, $a0
    bne $a0, 0, draw_virus        
    li $t3, 6
draw_virus:
    addi $t4, $t0, 2064     # first pixel of first row that virus can occur
    beq $t2, $t3, exit
    li $v0, 42
    li $a0, 0
    li $a1, 17              # generate a random integer between 0 and 16(inclusive)
    syscall                 # get the rand int
    li $t5, 4
    mult $a0, $t5           # rand int * 4 to get the horizontal index
    mflo $t5                # store the result back to t5
    add $t4, $t4, $t5       # add it to address
    li $v0, 42
    li $a0, 0
    li $a1, 12              # generate a random integer between 0 and 12(inclusive)
    syscall                 # get the rand int
    addi $t5, $zero, 128    # li $t5, 128 doesn't work here for some reason
    mult $a0, $t5           # rand int * 128 to get vertical index
    mflo $t5                # store back to t5
    add $t4, $t4, $t5       # add it to address
    # rand to get color of the virus
    li $v0, 42
    li $a0, 0
    li $a1, 3               # generate a random integer between 0 and 2(inclusive)
    syscall                 # generate a random int
    beq $a0, 0, green1  
    beq $a0, 1, yellow1
    beq $a0, 2, blue1       # jump to draw based on color
green1:
    sw $t8, 0($t4)          # draw a green pixel
    addi $t2, $t2, 1        # i++
    j draw_virus
yellow1:
    sw $t7, 0($t4)          # draw a yellow pixel
    addi $t2, $t2, 1        # i++
    j draw_virus
blue1:
    sw $t9, 0($t4)          # draw a blue pixel
    addi $t2, $t2, 1        # i++
    j draw_virus
game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
    
exit:
    li $v0, 10              # terminate the program gracefully
    syscall
