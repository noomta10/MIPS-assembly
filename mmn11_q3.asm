# Name: Noam Tamir 213712284
# Due date: 14.01.2024

# Description:
# This program takes a 4 digit number from the user.
# Then it prints its binary value, its reverse binary value and the decimal value of the reverse binary value.

# Registers:
# $t0 = user's number  
# $t1 = counter for 16 bits
# $t2 = mask to extract bits for binary print
# $t3 = placeholder to store a bit
# $t4 = copy of user's number 
# $t5 = stores the decimal value of the reverse binary
# $t6 = mask to extract bits for decimal print

.macro  print_string(%x)
    # Print new line
    li $v0,11
    li $a0,'\n'
    syscall
    # Print string
    li $v0, 4
    la $a0, %x
    syscall
.end_macro


.data
    prompt: .asciiz "Enter a number between -9999 and 9999:\n"
    invalid_prompt: .asciiz "Invalid number. number must be between -9999 and 9999:\n"
    binary_prompt: .asciiz "Binary representation in 16 bits: "
    reverse_binary_prompt: .asciiz "Reverse binary representation in 16 bits: "
    decimal_prompt: .asciiz "Decimal value of reverse binary: "
    
    
.text
    main:
        # Prompt the user to enter a number
        print_string(prompt)
	              
    get_input:
        # Get the user's number
        li $v0, 5 
        syscall        
        # Store the number in $t0, $t4 and $t7
        move $t0, $v0
        move $t4, $t0         
        blt $t0, -9999, invalid_input  # Branch if less than -9999	
        bgt $t0, 9999, invalid_input   # Branch if grater than 9999
          
     print_string(binary_prompt)
         
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
         
    print_string(reverse_binary_prompt)  
                           
    set_reverse_variables:
        li $t1, 16      # Reset counter for 16 bits      
        li $t2, 0x0001  # Mask to extract each bit      
        li $t5, 0       # Initialize decimal value of reverse binary      
    	li $t6, 0x8000  # Mask to extract decimal value of reverse binary
       
    print_binary_reverse_loop:	
        and $t3, $t4, $t2            # Extract a bit using AND operation        
        beqz $t3, load_zero_reverse  # Check if bit is equal to zero       
    	li $a0, '1'                  # If the bit value is not zero, load one   	
    	or $t5, $t5, $t6             # Add to decimal value using OR operation
    	srl $t6, $t6, 1              # Shift right decimal mask
     	j print_bit_reverse
    
    load_zero_reverse:   	
    	li $a0, '0'      # Load zero     	
    	srl $t6, $t6, 1  # Shift right decimal mask
    	
    print_bit_reverse:
    	# Print a single bit
    	li $v0, 11
        syscall   
    	addi $t1, $t1, -1                    # Decrement counter by one
    	srl $t4, $t4, 1                      # Shift right to get next bit   	
    	bnez $t1, print_binary_reverse_loop  # Loop until counter is zero 
    	    	
    print_string(decimal_prompt)	
       
    get_decimal: 
    	andi $t3, $t5, 0x8000 # Put MSB to $t3
    	bnez $t3, negative    # If MSB is one, treat negative
    	j print_decimal
    	
    negative:
    	lui $t3, 0xffff # Sign extend
        
    print_decimal:
    	or $t3, $t3, $t5 # Sign extend
    	# Print decimal value
    	li $v0, 1
    	move $a0, $t3
    	syscall
    
    exit_program:     
    	# Exit the program 
        li $v0, 10
        syscall    
     
    invalid_input:
        # Print invalid prompt 
        print_string(invalid_prompt)        
        j get_input  # Jump back to get_input
