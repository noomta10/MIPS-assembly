# Registers:
# $t0 = copy of bool array
# $t1 = counter for number of digits
# $t2 = store user's character input
# $t3 = first user's digit
# $t4 = second user's digit
# $t5 = third user's digit 

.macro  print_string(%x)
    # Print new line
    li $v0, 11
    li $a0,'\n'
    syscall
    # Print string
    li $v0, 4
    la $a0, %x
    syscall
.end_macro


.data
    input_prompt: .asciiz "Enter 3 different digits:\n"
    invalid_character_prompt: "Invalid digit. Digit must be between 0 and 9:\n"
    not_unique_prompt: "Invalid input. Digits must be unique.\n"
    bool: .space 3


.text
    main:   
    	la $a0, bool  # Put bool in $a0 for get_number use
    	li $t1, 0 # Initialize digits counter to 0
    	
    	   	
    get_numbers:
        	print_string(input_prompt)
    	move $t0, $a0 # Copy bool array to $t0  
    	j get_digit_loop   	
    
    get_digit_loop:
        # Get digit
    	bge $t1, 3, done_getting_input
    	li $v0, 12
    	syscall 
    	move $t2, $v0
    	# Print new line
   	li $v0, 11
    	li $a0,'\n'
        syscall	  
     
    validate_digit:
        	bgt $t2, '9', invalid_input	
    	blt $t2, '0', invalid_input   	
	      	
    valid_digit:
        sb $t2, 0($t0) # Store digit in bool array
    	addi $t0, $t0, 1 # Move to next position in the array
    	addi $t1, $t1, 1 # Add one to digits counter
    	j get_digit_loop
  
    done_getting_input:
      	# Print the value stored in the register
   	 addi $t0, $t0, -3 # Go back to beginning of bool
   	 # Store digits in registers
   	 lb $t3, 0x00($t0)
   	 lb $t4, 0x01($t0)
   	 lb $t5, 0x02($t0)
   	 # Check uniqueness
   	 beq $t3, $t4, not_unique 
   	 beq $t3, $t5, not_unique     
   	 beq $t4, $t5, not_unique 
   	j exit_program
      
    not_unique:
    	print_string(not_unique_prompt)
    	j main   	
    
    invalid_input:
    	print_string(invalid_character_prompt)
    	j main
    	
    exit_program:
   	li $v0, 10
   	syscall
