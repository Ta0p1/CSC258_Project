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
ADDR_VIRUS_BEGIN:
    .word 0x10000000
ADDR_VIRUS_NUM:
    .word 0x10001100
ADDR_G_COUNTER:
    .word 0x10000020

####################################################
# Mutable Data
##############################################################################
Capsule_now:      .word 432          # Current coordinate of capsule.
##############################################################################
# Code
##############################################################################
	.text
	.globl main

main:
    li $t7, 0xffff00        # yellow
    li $t8, 0x00ff00        # green
    li $t9, 0x0000ff        # blue
    li $t2, 0               # i for loops
    
    lw $t0, ADDR_DSPL       # init address
    lw $s0, ADDR_KBRD       # $s0 = base address for keyboard
    
    
    addi $t1, $t0, 1428
    li $t3, 6
draw_easy:
    beq $t2, $t3, pre_draw_mid_1
    sw $t7, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_easy
pre_draw_mid_1:
    li $t2, 0
    addi $t1, $t0, 1468
draw_mid_1:
    beq $t2, $t3, pre_draw_mid_2
    sw $t8, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_mid_1
pre_draw_mid_2:
    li $t2, 0
    addi $t1, $t0, 1476
draw_mid_2:
    beq $t2, $t3, pre_draw_hard1
    sw $t8, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_mid_2
pre_draw_hard1:
    li $t2, 0
    addi $t1, $t0, 1508
draw_hard1:
    beq $t2, $t3, pre_draw_hard2
    sw $t9, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard1
pre_draw_hard2:
    li $t2, 0
    addi $t1, $t0, 1516
draw_hard2:
    beq $t2, $t3, pre_draw_hard3
    sw $t9, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard2
pre_draw_hard3:
    li $t2, 0
    addi $t1, $t0, 1524
draw_hard3:
    beq $t2, $t3, choose_loop
    sw $t9, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard3
choose_loop:
    li $v0, 32
	li $a0, 1
	syscall                         # Sleep for 1 time unit
    lw $t4, 0($s0)
    beq $t4, 1, choose_diff
    b choose_loop
choose_diff:
    lw $a0, 4($s0)
    beq $a0, 0x61, easy     # Check if the key a was pressed
    beq $a0, 0x73, mid      # Check if the key s was pressed
    beq $a0, 0x64, hard     # Check if the key d was pressed
    b choose_loop
easy:
    li $t5, 2000            # init game speed(gravity will take effect 1 time per 2 sec)
    li $t1, 0x10001000      # init curr game speed counter
    sw $t5, 0($t1)
    li $t4, 4               # easy feature has 4 init viruses
    lw $t6, ADDR_VIRUS_NUM
    sw $t4, 0($t6)
    jal erase_choose
    j initializer
mid:
    li $t5, 1200            # init game speed(gravity will take effect 1 time per 2 sec)
    li $t1, 0x10001000      # init curr game speed counter
    sw $t5, 0($t1)
    li $t4, 6               # mid has 6
    lw $t6, ADDR_VIRUS_NUM
    sw $t4, 0($t6)
    jal erase_choose
    j initializer
hard:
    li $t5, 600             # init game speed(gravity will take effect 1 time per 2 sec)
    li $t1, 0x10001000      # init curr game speed counter
    sw $t5, 0($t1)
    li $t4, 8               # hard has 8
    lw $t6, ADDR_VIRUS_NUM
    sw $t4, 0($t6)
    jal erase_choose
    j initializer
initializer:
    li $t2, 0
    li $t3, 3               # loop constraints
    li $t4, 0               # address to loop with, change every loops
    addi $t4, $t0, 424      # init the begin point
    li $t1, 0x10001004      # init counter of when should the gamespeed change
    sw $zero, 0($t1)
    li $t1, 0x10000020      # init virus and gravity counter to 0
    sw $zero, 0($t1)
    li $t1, 0x10000000
    sw $zero, 0($t1)
    li $t1, 0x10000004
    sw $zero, 0($t1)
    li $t1, 0x10000008
    sw $zero, 0($t1)
    li $t1, 0x1000000c
    sw $zero, 0($t1)
    li $t1, 0x10000010
    sw $zero, 0($t1)
    li $t1, 0x10000014
    sw $zero, 0($t1)
    li $t1, 0x10000018
    sw $zero, 0($t1)
    li $t1, 0x1000001c
    sw $zero, 0($t1)
    li $t1, 0xA9A9A9        # $t1 = grey
    
    

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
    addi $s1, $zero, 0      # set s1 to 0
    li $t2, 0               # reset i
    li $t3, 8               # reset constraints
    sw $zero, 0x10000300      # Set the position state of box to 0 (box1 above box2)
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
    li $t3, 8               # reset constraints
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
    sw $t8, 0x10000400($t2) # store next color of the unit box
    addi $t2, $t2, 4        # i++
    j draw_next_cap
yellow:
    sw $t7, 0($t5)          # draw a yellow pixel
    addi $t5, $t5, 128      # t5 += 128, load the next index
    sw $t7, 0x10000400($t2) # store next color of the unit box
    addi $t2, $t2, 4        # i++
    j draw_next_cap
blue:
    sw $t9, 0($t5)          # draw a blue pixel
    addi $t5, $t5, 128      # t5 += 128, load the next index
    sw $t9, 0x10000400($t2) # store next color of the unit box
    addi $t2, $t2, 4        # i++
    j draw_next_cap

generate_virus:
    li $t2, 0               # reset i
    li $s5, 0x10000000
    lw $t3, 0x10001100
draw_virus:
    addi $t4, $t0, 2064     # first pixel of first row that virus can occur
    beq $t2, $t3, game_loop
    li $v0, 42
    li $a0, 0
    li $a1, 17              # generate a random integer between 0 and 16(inclusive)
    syscall                 # get the rand int
    sll $t5, $a0, 2         # rand int * 4
    add $t4, $t4, $t5       # add it to address
    li $v0, 42
    li $a0, 0
    li $a1, 12              # generate a random integer between 0 and 12(inclusive)
    syscall                 # get the rand int
    sll $t5, $a0, 7         # rand int * 128
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
    sw $t4, 0($s5)
    addi $s5, $s5, 4
    addi $t2, $t2, 1        # i++
    j draw_virus
yellow1:
    sw $t7, 0($t4)          # draw a yellow pixel
    sw $t4, 0($s5)
    addi $s5, $s5, 4
    addi $t2, $t2, 1        # i++
    j draw_virus
blue1:
    sw $t9, 0($t4)          # draw a blue pixel
    sw $t4, 0($s5)
    addi $s5, $s5, 4
    addi $t2, $t2, 1        # i++
    j draw_virus


# Does not loop during initialization
capsule_new:		        # Init a new capsule
    addi $t4, $t0, 432      # Set new capsule position (top part)
    addi $s1, $zero, 0      # Set capsule position state to 0 (box1 above box2)
    li $t2, 0               # Reset loop counter i
    li $t3, 8               # Set loop constraint
    sw $zero, 0x10000300    # Save the position state of box to 0 (box1 above box2)
draw_new_cap:
    beq $t2, $t3, next_capsule_new      # Loop 2 times
    sw $t4, 0x10000100($t2)             # Store coordinate of the unit box
    lw $a0, 0x10000400($t2)             # Load color of new box
    beq $a0, 0x00ff00, draw_green_new
    beq $a0, 0xffff00, draw_yellow_new
    beq $a0, 0x0000ff, draw_blue_new    # Jump to drawing based on color

draw_yellow_new:
    sw $t7, 0($t4)          # Draw a yellow pixel
    addi $t4, $t4, 128      # Move down one row
    sw $t7, 0x10000200($t2) # Store color of the unit box
    addi $t2, $t2, 4        # i += 4
    j draw_new_cap
draw_green_new:
    sw $t8, 0($t4)          # Draw a green pixel
    addi $t4, $t4, 128      # Move down one row
    sw $t8, 0x10000200($t2) # Store color of the unit box
    addi $t2, $t2, 4        # i += 4
    j draw_new_cap
draw_blue_new:
    sw $t9, 0($t4)          # Draw a blue pixel
    addi $t4, $t4, 128      # Move down one row
    sw $t9, 0x10000200($t2) # Store color of the unit box
    addi $t2, $t2, 4        # i += 4
    j draw_new_cap

next_capsule_new:
    addi $t5, $t0, 880      # Position for the next capsule (top part)
    li $t2, 0               # Reset loop counter i
    li $t3, 8               # Set loop constraint
draw_next_new_cap:
    beq $t2, $t3, game_loop # After drawing (loop 2 times), proceed to game loop
    li $v0, 42
    li $a0, 0
    li $a1, 3               # Generate a random integer between 0 and 2(inclusive)
    syscall                 # Generate a random integer
    beq $a0, 0, green_new
    beq $a0, 1, yellow_new
    beq $a0, 2, blue_new    # Jump to draw based on randomized int represent color
green_new:
    sw $t8, 0($t5)          # Draw a green pixel
    addi $t5, $t5, 128      # Move down one row
    sw $t8, 0x10000400($t2) # Store color of the unit box for the next capsule
    addi $t2, $t2, 4        # i += 4
    j draw_next_new_cap
yellow_new:
    sw $t7, 0($t5)          # Draw a yellow pixel
    addi $t5, $t5, 128      # Move down one row
    sw $t7, 0x10000400($t2) # Store color of the unit box for the next capsule
    addi $t2, $t2, 4        # i += 4
    j draw_next_new_cap
blue_new:
    sw $t9, 0($t5)          # Draw a blue pixel
    addi $t5, $t5, 128      # Move down one row
    sw $t9, 0x10000400($t2) # Store color of the unit box for the next capsule
    addi $t2, $t2, 4        # i += 4
    j draw_next_new_cap


game_loop:
    lw $t4, 0x10000020              # get current gravity counter value
    lw $t5, 0x10001000              # get current game speed
    lw $t6, 0x10001004              # get the counter for changing game speed
    bne $t4, $t5, loop_body         # check affected by gravity or no6
    lw $a2, 0x10000020              # let respond_S know it get called by gravity
    lw $a3, 0x10001000
    bne $t6, 5, jump_to_S           # every 5 gravity effects change the game speed
    bne $t5, 200, change_game_speed
    li $t6, 0
    j jump_to_S
change_game_speed:
    addi $t5, $t5, -200
    sw $t5, 0x10001000($zero)
    li $t6, 0
jump_to_S:
    addi $t6, $t6, 1
    sw $t6, 0x10001004($zero)
    j respond_to_S
loop_body:
	li 		$v0, 32
	li 		$a0, 1
	syscall                         # Sleep for 1 time unit
	addi $t4, $t4, 1
	sw $t4, 0x10000020($zero)

    lw $t5, 0($s0)                  # Load first word from keyboard
    beq $t5, 1, keyboard_input      # If first word 1, key is pressed
    b game_loop

keyboard_input:                     # A key is pressed
    lw $a0, 4($s0)                  # Load second word from keyboard
    beq $a0, 0x70, respond_to_P
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key w was pressed
    beq $a0, 0x61, respond_to_A     # Check if the key a was pressed
    beq $a0, 0x73, respond_to_S     # Check if the key s was pressed
    beq $a0, 0x64, respond_to_D     # Check if the key d was pressed

    b game_loop
    
respond_to_P:
    li $t2, 0
    li $t3, 32
    li $t4, 0xff0000
    lw $t5, ADDR_DSPL
draw_pause:
    beq $t2, $t3, waiting_for_signal
    sw $t4, 0($t5)
    addi $t5, $t5, 4
    addi $t2, $t2, 1
    j draw_pause
waiting_for_signal:
    li $v0, 32
	li $a0, 1
	syscall                         # Sleep for 1 time unit
	lw $t4, 0($s0)
    beq $t4, 1, resume
    b waiting_for_signal
resume:
    lw $a0, 4($s0)
    bne $a0, 0x70, waiting_for_signal
erase_pause:
    li $t2, 0
    li $t3, 32
    lw $t5, ADDR_DSPL
erase_pause_loop:
    beq $t2, $t3, back_and_resume
    sw $zero, 0($t5)
    addi $t5, $t5, 4
    addi $t2, $t2, 1
    j erase_pause_loop
back_and_resume:
    j game_loop

respond_to_Q:
	li $v0, 10                      # Quit gracefully
	syscall
respond_to_W:
    lw $t5, 0x10000204              # t5 = color of the second box
    lw $t4, 0x10000104              # t4 = coordinate of the second box
    lw $t3, 0x10000200              # t3 = color of the first box
    lw $t2, 0x10000100              # t2 = coordinate of the first box

    jal check_w                     # Check for collisions when rotating

    add $a0, $zero, $t4
    jal erase                       # Erase second box at old position

    add $a0, $zero, $t2
    jal erase                       # Erase first box at old position

    # Determine the position of the second box relative to the first box and adjust accordingly
    sub $t6, $t4, $t2               # Compute position difference: $t6 = $t4 - $t2

    # Rotate the capsule clockwise
    beq $t6, 4, rotate_to_bottom    # If $t6 == 4, current position is right of first box
    beq $t6, 128, rotate_to_left    # If $t6 == 128, current position is below first box
    beq $t6, -4, rotate_to_top      # If $t6 == -4, current position is left of first box
    beq $t6, -128, rotate_to_right  # If $t6 == -128, current position is above first box


rotate_to_bottom:
    addi $t4, $t2, 128              # Move second box below first box
    sw $t4, 0x10000104              # Save new coordinate of the second box
    addi $s1, $zero, 0
    sw $s1, 0x10000300              # Set the position state of box to 0 (box1 above box2)
    j draw_rotated

rotate_to_left:
    addi $t4, $t2, -4               # Move second box to the left of first box
    sw $t4, 0x10000104              # Save new coordinate of the second box
    addi $s1, $zero, 1
    sw $s1, 0x10000300              # Set the position state of box to 1 (box1 to the left box2)
    j draw_rotated

rotate_to_top:
    addi $t4, $t2, -128             # Move second box above first box
    sw $t4, 0x10000104              # Save new coordinate of the second box
    addi $s1, $zero, 2
    sw $s1, 0x10000300              # Set the position state of box to 2 (box1 below box2)
    j draw_rotated

rotate_to_right:
    addi $t4, $t2, 4                # Move second box to the right of first box
    sw $t4, 0x10000104              # Save new coordinate of the second box
    addi $s1, $zero, 3
    sw $s1, 0x10000300              # Set the position state of box to 3 (box1 to the right box2)
    j draw_rotated

draw_rotated:
    # Redraw the rotated capsule
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box                # Draw second box at new position

    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box                # Draw first box (position unchanged)
    
    # Save new coordinates
    sw $t2, 0x10000100              # Save coordinate of the first box
    sw $t4, 0x10000104              # Save coordinate of the second box
    li $v0, 31
    li $a0, 66
    li $a1, 100
    li $a2, 2
    li $a3, 80
    syscall
    j game_loop

respond_to_A:
    lw $t5, 0x10000204              # $t5 = color of the second box
    lw $t4, 0x10000104              # $t4 = coordinate of the second box
    lw $t3, 0x10000200              # $t3 = color of the first box
    lw $t2, 0x10000100              # $t2 = coordinate of the first box

    jal check_a                     # Check for collisions when moving left

    add $a0, $zero, $t4
    jal erase                       # Erase second box at old position

    add $a0, $zero, $t2
    jal erase                       # Erase first box at old position

    addi $t4, $t4, -4               # Move second box left
    addi $t2, $t2, -4               # Move first box left
    sw $t4, 0x10000104              # Save new coordinate of the second box
    sw $t2, 0x10000100              # Save new coordinate of the first box
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box                # Draw second box at new position
    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box                # Draw first box at new position
    li $v0, 31
    li $a0, 62
    li $a1, 100
    li $a2, 2
    li $a3, 80
    syscall
    j game_loop

respond_to_S:
    bne $a2, $a3, s_body            # check if this respond is requested by the gravity
    sw $zero, 0x10000020($zero)     # if so, clear the gravity counter
s_body:
    lw $t5, 0x10000204              # $t5 = color of the second box
    lw $t4, 0x10000104              # $t4 = coordinate of the second box
    lw $t3, 0x10000200              # $t3 = color of the first box
    lw $t2, 0x10000100              # $t2 = coordinate of the first box

    jal check_s                     # Check for collisions when moving down

    add $a0, $zero, $t4
    jal erase                       # Erase second box at old position

    add $a0, $zero, $t2
    jal erase                       # Erase first box at old position

    addi $t4, $t4, 128              # Move second box down
    addi $t2, $t2, 128              # Move first box down
    sw $t4, 0x10000104              # Save new coordinate of the second box
    sw $t2, 0x10000100              # Save new coordinate of the first box

    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box                # Draw second box at new position

    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box                # Draw first box at new position
    li $v0, 31
    li $a0, 60
    li $a1, 100
    li $a2, 2
    li $a3, 80
    syscall

    j game_loop

respond_to_D:
    lw $t5, 0x10000204              # $t5 = color of the second box
    lw $t4, 0x10000104              # $t4 = coordinate of the second box
    lw $t3, 0x10000200              # $t3 = color of the first box
    lw $t2, 0x10000100              # $t2 = coordinate of the first box

    jal check_d                     # Check for collisions when moving right

    add $a0, $zero, $t4
    jal erase                       # Erase second box at old position

    add $a0, $zero, $t2
    jal erase                       # Erase first box at old position

    addi $t4, $t4, 4                # Move second box right
    addi $t2, $t2, 4                # Move first box right
    sw $t4, 0x10000104              # Save new coordinate of the second box
    sw $t2, 0x10000100              # Save new coordinate of the first box
    add $a0, $zero, $t4
    add $a1, $zero, $t5
    jal draw_new_box                # Draw second box at new position
    add $a0, $zero, $t2
    add $a1, $zero, $t3
    jal draw_new_box                # Draw first box at new position
    li $v0, 31
    li $a0, 64
    li $a1, 100
    li $a2, 2
    li $a3, 80
    syscall
    j game_loop

# Collision checking functions (check_w, check_a, check_s, check_d) and other helper functions
check_w:
    beq $s1, 0, check_w_0        # If capsule is in position state 0 (vertical)
    beq $s1, 1, check_w_1        # If capsule is in position state 1 (horizontal)
    beq $s1, 2, check_w_2        # If capsule is in position state 2 (vertical inverted)
    beq $s1, 3, check_w_3        # If capsule is in position state 3 (horizontal inverted)
    jr $ra                       # Return from function
check_w_0:
    lw $s2, 0x10000100           # Load coordinate of the first box (capsule part)
    addi $s2, $s2, -4            # Move left by one pixel (to check rotation possibility)
    lw $s3, 0($s2)               # Load value at that position
    # If the position is occupied by any block (grey, yellow, green, or blue), rotation is not possible
    beq $s3, $t1, game_loop      # If grey (bottle wall), return to game loop without rotating
    beq $s3, $t7, game_loop      # If yellow block, return
    beq $s3, $t8, game_loop      # If green block, return
    beq $s3, $t9, game_loop      # If blue block, return
    jr $ra                       # Else, rotation is possible
check_w_1:
    lw $s2, 0x10000100           # Load coordinate of the first box
    addi $s2, $s2, -128          # Move up by one row (128 bytes)
    lw $s3, 0($s2)               # Load value at that position
    # Check for occupation
    beq $s3, $t1, game_loop      # If position occupied, return to game loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra                       # Else, rotation is possible
check_w_2:
    lw $s2, 0x10000100           # Load coordinate of the first box
    addi $s2, $s2, 4             # Move right by one pixel
    lw $s3, 0($s2)               # Load value at that position
    # Check for occupation
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra                       # Else, rotation is possible
check_w_3:
    lw $s2, 0x10000100           # Load coordinate of the first box
    addi $s2, $s2, 128           # Move down by one row
    lw $s3, 0($s2)               # Load value at that position
    # Check for occupation
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra                       # Else, rotation is possible

# Similar comments to W (Check A, S, D)
check_a:
    beq $s1, 0, check_a_0
    beq $s1, 1, check_a_1
    beq $s1, 2, check_a_2
    beq $s1, 3, check_a_3
    jr $ra
check_a_0:
    lw $s2, 0x10000100
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    lw $s2, 0x10000104
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_a_1:
    lw $s2, 0x10000104
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_a_2:
    lw $s2, 0x10000100
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    lw $s2, 0x10000104
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_a_3:
    lw $s2, 0x10000100
    addi $s2, $s2, -4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra

check_s:
    beq $s1, 0, check_s_0
    beq $s1, 1, check_s_1
    beq $s1, 2, check_s_2
    beq $s1, 3, check_s_3
    jr $ra
check_s_0:
    lw $s2, 0x10000104
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    jr $ra
check_s_1:
    lw $s2, 0x10000100
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    lw $s2, 0x10000104
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    jr $ra
check_s_2:
    lw $s2, 0x10000100
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    jr $ra
check_s_3:
    lw $s2, 0x10000100
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    lw $s2, 0x10000104
    addi $s2, $s2, 128
    lw $s3, 0($s2)
    beq $s3, $t1, collisions
    beq $s3, $t7, collisions
    beq $s3, $t8, collisions
    beq $s3, $t9, collisions
    jr $ra

check_d:
    beq $s1, 0, check_d_0
    beq $s1, 1, check_d_1
    beq $s1, 2, check_d_2
    beq $s1, 3, check_d_3
    jr $ra
check_d_0:
    lw $s2, 0x10000100
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    lw $s2, 0x10000104
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_d_1:
    lw $s2, 0x10000100
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_d_2:
    lw $s2, 0x10000100
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    lw $s2, 0x10000104
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra
check_d_3:
    lw $s2, 0x10000104
    addi $s2, $s2, 4
    lw $s3, 0($s2)
    beq $s3, $t1, game_loop
    beq $s3, $t7, game_loop
    beq $s3, $t8, game_loop
    beq $s3, $t9, game_loop
    jr $ra

collisions:
    addi $t4, $t0, 816
    lw $t5, 0($t4)
    bne $t5, $zero, exit        # check if the top of bottle is empty, if not then exit
    addi $t4, $t0, 0
    lw $t2, ADDR_DSPL           # i = ADDR_DSPL
    addi $s4, $t2, 4096         # set loop constraints
iter_through:
    beq $t2, $s4, capsule_new   # when done the loop through all element in bitmap, go generate next capsule
    lw $t4, 0($t2)
    bne $t4, 0, if_grey
    addi $t2, $t2, 4
    j iter_through
if_grey:
    bne $t4, 0xa9a9a9, check_vertical
    addi $t2, $t2, 4
    j iter_through
check_vertical:
    lw $t4, 0($t2)
    lw $t5, 128($t2)
    lw $t6, 256($t2)
    lw $s7, 384($t2)
    bne $t4, $t5, check_horizontal
    bne $t4, $t6, check_horizontal
    bne $t4, $s7, check_horizontal
    addi $a0, $t2, 0
    jal erase
    addi $a0, $t2, 128
    jal erase
    addi $a0, $t2, 256
    jal erase
    addi $a0, $t2, 384
    jal erase
    addi $t4, $t2, 128
    addi $t5, $t2, 256
    addi $t6, $t2, 384
    lw $s7, 0x10000000
    bne $s7, $t2, check_virus1
    sw $zero, 0x10000000($zero)
check_virus1:
    bne $s7, $t4, check_virus2
    sw $zero, 0x10000000($zero)
check_virus2:
    bne $s7, $t5, check_virus3
    sw $zero, 0x10000000($zero)
check_virus3:
    bne $s7, $t6, check_virus4
    sw $zero, 0x10000000($zero)
check_virus4:
    lw $s7, 0x10000004
    bne $s7, $t2, check_virus5
    sw $zero, 0x10000004($zero)
check_virus5:
    bne $s7, $t4, check_virus6
    sw $zero, 0x10000004($zero)
check_virus6:
    bne $s7, $t5, check_virus7
    sw $zero, 0x10000004($zero)
check_virus7:
    bne $s7, $t6, check_virus8
    sw $zero, 0x10000004($zero)
check_virus8:
    lw $s7, 0x10000008
    bne $s7, $t2, check_virus9
    sw $zero, 0x10000008($zero)
check_virus9:
    bne $s7, $t4, check_virus10
    sw $zero, 0x10000008($zero)
check_virus10:
    bne $s7, $t5, check_virus11
    sw $zero, 0x10000008($zero)
check_virus11:
    bne $s7, $t6, check_virus12
    sw $zero, 0x10000008($zero)
check_virus12:
    lw $s7, 0x1000000c
    bne $s7, $t2, check_virus13
    sw $zero, 0x1000000c($zero)
check_virus13:
    bne $s7, $t4, check_virus14
    sw $zero, 0x1000000c($zero)
check_virus14:
    bne $s7, $t5, check_virus15
    sw $zero, 0x1000000c($zero)
check_virus15:
    bne $s7, $t6, check_virus16
    sw $zero, 0x1000000c($zero)
check_virus16:
    lw $s7, 0x10000010
    bne $s7, $t2, check_virus17
    sw $zero, 0x10000010($zero)
check_virus17:
    bne $s7, $t4, check_virus18
    sw $zero, 0x10000010($zero)
check_virus18:
    bne $s7, $t5, check_virus19
    sw $zero, 0x10000010($zero)
check_virus19:
    bne $s7, $t6, check_virus20
    sw $zero, 0x10000010($zero)
check_virus20:
    lw $s7, 0x10000014
    bne $s7, $t2, check_virus21
    sw $zero, 0x10000014($zero)
check_virus21:
    bne $s7, $t4, check_virus22
    sw $zero, 0x10000014($zero)
check_virus22:
    bne $s7, $t5, check_virus23
    sw $zero, 0x10000014($zero)
check_virus23:
    bne $s7, $t6, check_virus24
    sw $zero, 0x10000014($zero)
check_virus24:
    lw $s7, 0x10000018
    bne $s7, $t2, check_virus25
    sw $zero, 0x10000018($zero)
check_virus25:
    bne $s7, $t4, check_virus26
    sw $zero, 0x10000018($zero)
check_virus26:
    bne $s7, $t5, check_virus27
    sw $zero, 0x10000018($zero)
check_virus27:
    bne $s7, $t6, check_virus28
    sw $zero, 0x10000018($zero)
check_virus28:
    lw $s7, 0x1000001c
    bne $s7, $t2, check_virus29
    sw $zero, 0x1000001c($zero)
check_virus29:
    bne $s7, $t4, check_virus30
    sw $zero, 0x1000001c($zero)
check_virus30:
    bne $s7, $t5, check_virus31
    sw $zero, 0x1000001c($zero)
check_virus31:
    bne $s7, $t6, vertical_done
    sw $zero, 0x1000001c($zero)
vertical_done:
    addi $a0, $t2, 388
    jal fall_down
    addi $a0, $t2, 260
    jal fall_down
    addi $a0, $t2, 132
    jal fall_down
    addi $a0, $t2, 4
    jal fall_down
    addi $a0, $t2, -128
    jal fall_down
    addi $a0, $t2, 380
    jal fall_down
    addi $a0, $t2, 252
    jal fall_down
    addi $a0, $t2, 124
    jal fall_down
    addi $a0, $t2, -4
    jal fall_down
    addi $t2, $t2, 4
    li $v0, 31
    li $a0, 70
    li $a1, 100
    li $a2, 24
    li $a3, 80
    syscall
    j collisions
check_horizontal:
    lw $t4, 0($t2)
    lw $t5, 4($t2)
    lw $t6, 8($t2)
    lw $s7, 12($t2)
    bne $t4, $t5, update
    bne $t4, $t6, update
    bne $t4, $s7, update
    addi $a0, $t2, 0
    jal erase
    addi $a0, $t2, 4
    jal erase
    addi $a0, $t2, 8
    jal erase
    addi $a0, $t2, 12
    jal erase
    addi $t4, $t2, 4
    addi $t5, $t2, 8
    addi $t6, $t2, 12
    lw $s7, 0x10000000
    bne $s7, $t2, check1_virus1
    sw $zero, 0x10000000($zero)
check1_virus1:
    bne $s7, $t4, check1_virus2
    sw $zero, 0x10000000($zero)
check1_virus2:
    bne $s7, $t5, check1_virus3
    sw $zero, 0x10000000($zero)
check1_virus3:
    bne $s7, $t6, check1_virus4
    sw $zero, 0x10000000($zero)
check1_virus4:
    lw $s7, 0x10000004
    bne $s7, $t2, check1_virus5
    sw $zero, 0x10000004($zero)
check1_virus5:
    bne $s7, $t4, check1_virus6
    sw $zero, 0x10000004($zero)
check1_virus6:
    bne $s7, $t5, check1_virus7
    sw $zero, 0x10000004($zero)
check1_virus7:
    bne $s7, $t6, check1_virus8
    sw $zero, 0x10000004($zero)
check1_virus8:
    lw $s7, 0x10000008
    bne $s7, $t2, check1_virus9
    sw $zero, 0x10000008($zero)
check1_virus9:
    bne $s7, $t4, check1_virus10
    sw $zero, 0x10000008($zero)
check1_virus10:
    bne $s7, $t5, check1_virus11
    sw $zero, 0x10000008($zero)
check1_virus11:
    bne $s7, $t6, check1_virus12
    sw $zero, 0x10000008($zero)
check1_virus12:
    lw $s7, 0x1000000c
    bne $s7, $t2, check1_virus13
    sw $zero, 0x1000000c($zero)
check1_virus13:
    bne $s7, $t4, check_virus14
    sw $zero, 0x1000000c($zero)
check1_virus14:
    bne $s7, $t5, check1_virus15
    sw $zero, 0x1000000c($zero)
check1_virus15:
    bne $s7, $t6, check1_virus16
    sw $zero, 0x1000000c($zero)
check1_virus16:
    lw $s7, 0x10000010
    bne $s7, $t2, check1_virus17
    sw $zero, 0x10000010($zero)
check1_virus17:
    bne $s7, $t4, check1_virus18
    sw $zero, 0x10000010($zero)
check1_virus18:
    bne $s7, $t5, check1_virus19
    sw $zero, 0x10000010($zero)
check1_virus19:
    bne $s7, $t6, check1_virus20
    sw $zero, 0x10000010($zero)
check1_virus20:
    lw $s7, 0x10000014
    bne $s7, $t2, check1_virus21
    sw $zero, 0x10000014($zero)
check1_virus21:
    bne $s7, $t4, check1_virus22
    sw $zero, 0x10000014($zero)
check1_virus22:
    bne $s7, $t5, check1_virus23
    sw $zero, 0x10000014($zero)
check1_virus23:
    bne $s7, $t6, check1_virus24
    sw $zero, 0x10000014($zero)
check1_virus24:
    lw $s7, 0x10000018
    bne $s7, $t2, check1_virus25
    sw $zero, 0x10000018($zero)
check1_virus25:
    bne $s7, $t4, check1_virus26
    sw $zero, 0x10000018($zero)
check1_virus26:
    bne $s7, $t5, check1_virus27
    sw $zero, 0x10000018($zero)
check1_virus27:
    bne $s7, $t6, check1_virus28
    sw $zero, 0x10000018($zero)
check1_virus28:
    lw $s7, 0x1000001c
    bne $s7, $t2, check1_virus29
    sw $zero, 0x1000001c($zero)
check1_virus29:
    bne $s7, $t4, check1_virus30
    sw $zero, 0x1000001c($zero)
check1_virus30:
    bne $s7, $t5, check1_virus31
    sw $zero, 0x1000001c($zero)
check1_virus31:
    bne $s7, $t6, horizontal_done
    sw $zero, 0x1000001c($zero)
horizontal_done:
    addi $a0, $t2, -4
    jal fall_down
    addi $a0, $t2, -128
    jal fall_down
    addi $a0, $t2, -124
    jal fall_down
    addi $a0, $t2, -120
    jal fall_down
    addi $a0, $t2, -116
    jal fall_down
    addi $a0, $t2, 16
    jal fall_down
    addi $t2, $t2, 4
    li $v0, 31
    li $a0, 70
    li $a1, 100
    li $a2, 24
    li $a3, 80
    syscall
    j collisions
update:
    addi $t2, $t2, 4
    j iter_through
    
fall_down:
    add $s6, $ra, $zero
    add $t4, $a0, $zero
    lw $t5, 0($t4)
    beq $t5, 0, jump_back
    beq $t5, 0xa9a9a9, jump_back
fall_loop:
    addi $t5, $t4, 128
    lw $t5, 0($t5)
    bne $t5, 0, jump_back       # check next empty
    lw $t6, 0x10000000
    beq $t6, 0x0, check1
    beq $t4, $t6, jump_back
    j check1
check1:
    lw $t6, 0x10000004
    beq $t6, 0x0, check2
    beq $t4, $t6, jump_back
    j check2
check2:
    lw $t6, 0x10000008
    beq $t6, 0x0, check3
    beq $t4, $t6, jump_back
    j check3
check3:
    lw $t6, 0x1000000c
    beq $t6, 0x0, check4
    beq $t4, $t6, jump_back
    j check4
check4:
    lw $t6, 0x10000010
    beq $t6, 0x0, check5
    beq $t4, $t6, jump_back
    j check5
check5:
    lw $t6, 0x10000014
    beq $t6, 0x0, not_virus
    beq $t4, $t6, jump_back     # check if virus
not_virus:
    lw $t5, 0($t4)
    addi $t6, $t4, 128
    addi $a0, $t4, 0
    jal erase
    addi $a0, $t6, 0
    addi $a1, $t5, 0
    jal draw_new_box
    addi $t4, $t4, 128
    j fall_loop
jump_back:
    jr $s6

erase:
    li $t3, 0x000000            # Black color (erase)
    sw $t3, 0($a0)              # Erase pixel at address $a0
    lw $t3, 0x10000200          # Keep the value of $t3 unchanged after call erase
    jr $ra

draw_new_box:
    sw $a1, 0($a0)              # Draw box with color $a1 at address $a0
    jr $ra
    
erase_choose:
    addi $t1, $t0, 1428
    li $t2, 0
    li $t3, 6
draw_easy1:
    beq $t2, $t3, pre_draw_mid_11
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_easy1
pre_draw_mid_11:
    li $t2, 0
    addi $t1, $t0, 1468
draw_mid_11:
    beq $t2, $t3, pre_draw_mid_21
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_mid_11
pre_draw_mid_21:
    li $t2, 0
    addi $t1, $t0, 1476
draw_mid_21:
    beq $t2, $t3, pre_draw_hard11
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_mid_21
pre_draw_hard11:
    li $t2, 0
    addi $t1, $t0, 1508
draw_hard11:
    beq $t2, $t3, pre_draw_hard21
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard11
pre_draw_hard21:
    li $t2, 0
    addi $t1, $t0, 1516
draw_hard21:
    beq $t2, $t3, pre_draw_hard31
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard21
pre_draw_hard31:
    li $t2, 0
    addi $t1, $t0, 1524
draw_hard31:
    beq $t2, $t3, go_back
    sw $zero, 0($t1)
    addi $t1, $t1, 128
    addi $t2, $t2, 1
    j draw_hard31
go_back:
    jr $ra
    

	
	
	
exit:
    li $v0, 31
    li $a0, 42
    li $a1, 100
    li $a2, 2
    li $a3, 100
    syscall
    li $t2, 0
    li $t3, 4096
    addi $t1, $t0, 0
clear_loop:
    beq $t2, $t3, end_view
    sw $zero, 0($t1)
    addi $t1, $t1, 4
    addi $t2, $t2, 1
    j clear_loop
end_view:
    addi $t4, $t0, 1428
    li $t5, 0xff0000
    sw $t5, 0($t4)
    addi $t4, $t0, 1516
    sw $t8, 0($t4)
end_loop:
    li $v0, 32
	li $a0, 1
	syscall                         # Sleep for 1 time unit
    lw $t4, 0($s0)
    beq $t4, 1, end_select
    b end_loop
end_select:
    lw $a0, 4($s0)
    beq $a0, 0x71, end              # end the game
    beq $a0, 0x77, new_game         # new game
    b end_select
end:
    li $v0, 10                      # Terminate the program gracefully
    syscall
new_game:
    j main