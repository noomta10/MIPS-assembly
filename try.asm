    .data
array:  .space 3    # Allocate space for 3 characters

    .text
    .globl main

main:
    li $v0, 12          # syscall code 12 for reading a character
    li $t0, 3           # Counter to read 3 characters
    la $t1, array       # Load address of array into $t1

read_loop:
    syscall             # Read a character
    sb $v0, ($t1)       # Store the character in the array
    addi $t0, $t0, -1   # Decrement counter
    addi $t1, $t1, 1    # Move to the next element in the array
    bnez $t0, read_loop # Loop until 3 characters are read

    # Printing the array
    li $v0, 4           # syscall code 4 for printing string
    la $a0, array       # Load address of array into $a0
    syscall             # Print the array

    li $v0, 10          # syscall code 10 for exit
    syscall             # Exit the program
