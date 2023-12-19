# Registers:
# $t0 = user's number  
# $t1 = counter for 16 bits
# $t2 = mask to extract bits for binary print
# $t3 = placeholder to store a bit
# $t4, $t5 = copy of user's number 
# $t6 = stores the decimal value of the reverse binary
# $t7 = mask to extract bits for decimal print

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
        
        # Store the number in $t0, $t4 and $t5
        move $t0, $v0
        move $t4, $t0
        move $t5, $t0
                
        blt $t0, -9999, invalid_input  # Branch if less than -9999	
        bgt $t0, 9999, invalid_input   # Branch if grater than 9999
      
     
     set_variables:
        li $t1, 16      # Counter for 16 bits  
        li $t2, 0x8000  # Mask to extract each bit
        
     
    print_binary_loop:      
        and $t3, $t0, $t2    # Extract a bit using AND operation       
        beqz $t3, load_zero  # Check if bit is equal to zero        
    	li $a0, '1'          # If the bit value is not zero, load one
     	j print_bit
        

    load_zero:
        li $a0, '0'
    
    
    print_bit:
    	# Print a single bit
    	li $v0, 11
        syscall       	
    	addi $t1, $t1, -1            # Decrement counter by one    	
    	sll $t0, $t0, 1              # Shift left to get next bit    	
    	bnez $t1, print_binary_loop  # Loop until counter is zero 
        
        
    print_new_line:
        # Print new line
        li $v0, 4
        la $a0, new_line
        syscall 
        
          
    set_reverse_variables:
        li $t1, 16      # Reset counter for 16 bits      
        li $t2, 0x0001  # Mask to extract each bit      
        li $t6, 0       # Initialize decimal value of reverse binary      
    	li $t7, 0x8000  # Mask to extract decimal value of reverse binary
    
    
    print_binary_reverse_loop:	
        and $t3, $t4, $t2            # Extract a bit using AND operation        
        beqz $t3, load_zero_reverse  # Check if bit is equal to zero       
    	li $a0, '1'                  # If the bit value is not zero, load one   	
    	or $t6, $t6, $t7             # Add to decimal value using OR operation
     	j print_bit_reverse

    
    load_zero_reverse:   	
    	li $a0, '0'      # Load zero     	
    	srl $t7, $t7, 1  # Shift right decimal mask
    	

    print_bit_reverse:
    	# Print a single bit
    	li $v0, 11
        syscall   
    	# Decrement counter by one
    	addi $t1, $t1, -1
    	# Shift right to get next bit
    	srl $t4, $t4, 1
    	# Loop until counter is zero 
    	bnez $t1, print_binary_reverse_loop
    	
    	
    print_another_new_line:
    	li $v0, 4
        la $a0, new_line
        syscall 
    	
    
    debug:
    	li $v0, 1
    	move $a0, $t6
    	syscall
    
    
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
