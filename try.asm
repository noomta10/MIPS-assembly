.data
input_string: .space 4      # Allocate space for a 4-byte string (3 characters + null terminator)
buffer: .space 4             # Buffer to store user input as a word
.text
.globl main

main:
    li $v0, 8                 # System call code for reading string
    la $a0, buffer            # Load the address of the buffer into $a0
    li $a1, 3                 # Maximum number of characters to read
    syscall                   # Perform the syscall to read the string

    lw $t0, buffer            # Load the word (user input) into $t0
    #sw $t0, buffer     # Store the word in the input_string array

    # Print the array (for verification)
    li $v0, 4                 # System call code for printing string
    la $a0, buffer      # Load the address of the array to print
    syscall

    # Exit program
    li $v0, 10                # System call code for exit
    syscall
