# Registers:
# $t0 = user's number  
# $t1 = counter for 16 bits
# $t2 = mask to extract bits for binary print
# $t3 = placeholder to store a bit
# $t4, $t5 = copy of user's number 


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
        # Store the number in $t4 and $t5
        move $t4, $t0
        move $t5, $t0
        # Branch if less than -9999
        blt $t0, -9999, invalid_input
	# Branch if grater than 9999
        bgt $t0, 9999, invalid_input
      
     
     set_variables:
        # Counter for 16 bits
        li $t1, 16
        # Mask to extract each bit
        li $t2, 32768 
        
     
    print_binary:
        # Extract a bit using AND operation
        and $t3, $t0, $t2
        # Check if bit is equal to zero
        beqz $t3, load_zero
        # If the bit value is not zero, load one
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
    	# Shift left to get next bit
    	sll $t0, $t0, 1
    	# Loop until counter is zero 
    	bnez $t1, print_binary
        
        
    print_new_line:
        # Print new line
        li $v0, 4
        la $a0, new_line
        syscall 
        
          
    set_reverse_variables:
        # Reset counter for 16 bits
        li $t1, 16
        # Mask to extract each bit 
        li $t2, 1
    
    
    print_binary_reverse:
	# Extract a bit using AND operation
        and $t3, $t4, $t2
        # Check if bit is equal to zero
        beqz $t3, load_zero_reverse
        # If the bit value is not zero, load one
    	li $a0, '1'
     	j print_bit_reverse

    
    load_zero_reverse:
    	li $a0, '0'


    print_bit_reverse:
    	# Print a single bit
    	li $v0, 11
        syscall   
    	# Decrement counter by one
    	addi $t1, $t1, -1
    	# Shift right to get next bit
    	srl $t4, $t4, 1
    	# Loop until counter is zero 
    	bnez $t1, print_binary_reverse
    	
    	
    print_another_new_line:
    	li $v0, 4
        la $a0, new_line
        syscall 
    	li $v0, 1
    	move $a0, $t5
    	syscall
    	
    	
    set_decimal_values:
    	# Initialize decimal value
    	li $t6, 0
    	# Set counter 
    	li $t1, 16
    	
    			
    loop_reverse_binary_to_decimal:
    	# Extract a bit using AND operation
        and $t3, $t4, $t2
    		
    
    exit_program:     
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
