.data
    prompt: .asciiz "Enter a number between -9999 and 9999:\n"
    invalid_prompt: .asciiz "Invalid number. number must be between -9999 and 9999:\n"
    new_line: .asciiz "\n"
    
.text
    main:
        # Prompt the user to enter a number
        li $v0, 4
        la $a0, prompt
        syscall
        
        
    get_input:
        # Get the user's number
        li $v0, 5 
        syscall
        # Store the number in $t0
        move $t0, $v0
        # Branch if less than -9999
        blt $t0, -9999, invalid_input
	# Branch if grater than 9999
        bgt $t0, 9999, invalid_input
      
        # Print number
        li $v0, 1
        move $a0, $t0
        syscall  
        
        # Print new line
        li $v0, 4
        la $a0, new_line
        syscall 
        
        # Counter for 16 bits
        li $t1, 16
        # Mask to extract each bit
        li $t2, 1 
        
    print_binary:
        # Extract a bit using AND operation
        and $t3, $t0, $t2
        # Check if bit is equal to 0
        beqz $t3, load_zero
    	li $a0, '1'
     	j print_bit
    
    load_zero:
        li $a0, '0'
    
    print_bit:
    	# Print a single bit
    	li $v0, 11
        syscall   
        
    	# Decrement counter by one
    	addi $t1, $t1, -1
    	# Shift right to get next bit
    	srl $t0, $t0, 1
    	# Loop until conter is zero 
    	bnez $t1, print_binary
    	
        # Exit the program 
        li $v0, 10
        syscall
    

    
    invalid_input:
        # Print invalid prompt 
        li $v0, 4
        la $a0, invalid_prompt
        syscall
        # Jump back to get_input
        j get_input    
