################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Charles Feng, 1009082680
# Student 2: Yitao Huang, 1010602885
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
Capsule_now:      .word 432          # Current coordinate of capsule.
##############################################################################
# Code
##############################################################################
	.text
	.globl main

main:
    li $t1, 0xA9A9A9        # $t1 = grey
    li $t2, 0               # i for loops
    li $t7, 0xffff00        # yellow
    li $t8, 0x00ff00        # green
    li $t9, 0x0000ff        # blue

    lw $t0, ADDR_DSPL       # init address
    lw $s0, ADDR_KBRD       # $s0 = base address for keyboard

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

capsule_init:		    # init capsule
    addi $t4, $t0, 432      # new capsule position(top part)
    li $t2, 0               # reset i
    li $t3, 8               # reset constraints
draw_init_cap:
    beq $t2, $t3, next_capsule      # 2 time loops
    sw $t4, 0x10000100($t2)          # store coordinate of the unit box
    li $v0, 42
    li $a0, 0
    li $a1, 3               # generate a random integer between 0 and 2(inclusive)
    syscall                 # generate a random int
    beq $a0, 0, draw_green
    beq $a0, 1, draw_yellow
    beq $a0, 2, draw_blue   # jump to draw based on randomized int

draw_yellow:
    sw $t7, 0($t4)          # draw a yellow pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    sw $t7, 0x10000200($t2)          # store color of the unit box
    addi $t2, $t2, 4        # i+=4
    j draw_init_cap
draw_green:
    sw $t8, 0($t4)          # draw a green pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    sw $t8, 0x10000200($t2)          # store color of the unit box
    addi $t2, $t2, 4        # i+=4
    j draw_init_cap
draw_blue:
    sw $t9, 0($t4)          # draw a blue pixel
    addi $t4, $t4, 128      # t4 += 128, load the next index
    sw $t9, 0x10000200($t2)         # store color of the unit box
    addi $t2, $t2, 4        # i+=4
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
    beq $t2, $t3, game_loop
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
	li 		$v0, 32
	li 		$a0, 1
	syscall

    lw $t8, 0($s0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b game_loop

keyboard_input:                     # A key is pressed
    lw $a0, 4($s0)                  # Load second word from keyboard
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key w was pressed
    beq $a0, 0x61, respond_to_A     # Check if the key a was pressed
    beq $a0, 0x73, respond_to_S     # Check if the key s was pressed
    beq $a0, 0x64, respond_to_D     # Check if the key d was pressed

    b game_loop

respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall
respond_to_W:
    lw $t5, 0x10000204 # t5 = color of the second box
    lw $t4, 0x10000104 # t4 = coordinate of the second box
    lw $t3, 0x10000200 # t3 = color of the first box
    lw $t2, 0x10000100 # t2 = coordinate of the first box

    add $a0, $zero, $t4
    jal erase

    add $a0, $zero, $t2
    jal erase

    # 判断第二块相对于第一块的位置并进行调整
    sub $t6, $t4, $t2        # 计算位置差：$t6 = $t4 - $t2

    # 顺时针旋转位置
    beq $t6, 4, rotate_to_bottom   # 如果 $t6 == 4，当前在右侧
    beq $t6, 128, rotate_to_left   # 如果 $t6 == 128，当前在底部
    beq $t6, -4, rotate_to_top     # 如果 $t6 == -4，当前在左侧
    beq $t6, -128, rotate_to_right # 如果 $t6 == -128，当前在顶部


rotate_to_bottom:
    addi $t4, $t2, 128       # 将第二块移动到底部
    sw $t4, 0x10000104 # save new coordinate of the first box
    j draw_rotated

rotate_to_left:
    addi $t4, $t2, -4         # 将第二块移动到左侧
    sw $t4, 0x10000104 # save new coordinate of the first box
    j draw_rotated

rotate_to_top:
    addi $t4, $t2, -128       # 将第二块移动到顶部
    sw $t4, 0x10000104 # save new coordinate of the first box
    j draw_rotated

rotate_to_right:
    addi $t4, $t2, 4         # 将第二块移动到右侧
    sw $t4, 0x10000104 # save new coordinate of the first box
    j draw_rotated

draw_rotated:
    # 重新绘制旋转后的胶囊
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box    # 绘制第二块的新位置

    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box     # 绘制第一块（位置未变）

        # save_new_coordinate:
    sw $t2, 0x10000100 # save new coordinate of the second box
    sw $t4, 0x10000104 # save new coordinate of the first box
    j game_loop

respond_to_A:
    lw $t5, 0x10000204   # $t5 = color of the second box
    lw $t4, 0x10000104   # $t4 = coordinate of the second box
    lw $t3, 0x10000200   # $t3 = color of the first box
    lw $t2, 0x10000100   # $t2 = coordinate of the first box

    add $a0, $zero, $t4
    jal erase

    add $a0, $zero, $t2
    jal erase

    addi $t4, $t4, -4
    addi $t2, $t2, -4
    sw $t4, 0x10000104   # save new coordinate of the second box
    sw $t2, 0x10000100   # save new coordinate of the first box
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box    # Draw second box at new position
    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box     # Draw first box at new position
    j game_loop

respond_to_S:
    lw $t5, 0x10000204 # t5 = color of the second box
    lw $t4, 0x10000104 # t4 = coordinate of the second box
    lw $t3, 0x10000200 # t3 = color of the first box
    lw $t2, 0x10000100 # t2 = coordinate of the first box

    add $a0, $zero, $t4
    jal erase

    add $a0, $zero, $t2
    jal erase

    addi $t4, $t4, 128
    addi $t2, $t2, 128
    sw $t4, 0x10000104
    sw $t2, 0x10000100

    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box    # 绘制第二块的新位置

    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box     # 绘制第一块（位置未变）

    j game_loop

respond_to_D:
    lw $t5, 0x10000204   # $t5 = color of the second box
    lw $t4, 0x10000104   # $t4 = coordinate of the second box
    lw $t3, 0x10000200   # $t3 = color of the first box
    lw $t2, 0x10000100   # $t2 = coordinate of the first box
    add $a0, $zero, $t4
    jal erase

    add $a0, $zero, $t2
    jal erase

    addi $t4, $t4, 4
    addi $t2, $t2, 4
    sw $t4, 0x10000104   # save new coordinate of the second box
    sw $t2, 0x10000100   # save new coordinate of the first box
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box    # Draw second box at new position
    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box     # Draw first box at new position
    j game_loop
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
erase:
    li $t3, 0x000000
    sw $t3, 0($a0)
    lw $t3 0x10000200
    jr $ra

draw_new_box:
    sw $a1, 0($a0)            # $t5 should be the coordinate of new box
    jr $ra
exit:
    li $v0, 10              # terminate the program gracefully
    syscall
