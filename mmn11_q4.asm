# Registers:
# $t0 = copy of bool array
# $t1 = counter for number of digits
# $t2 = store user's character input
# $t3 = first user's digit
# $t4 = second user's digit
# $t5 = third user's digit
# $t6 = copy of guess array 
# $t7 = first guessed digit
# $t8 = second guessed digit
# $t9 = third guessed digit

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
    invalid_character_prompt: .asciiz "Invalid digit. Digit must be between 0 and 9:\n"
    not_unique_prompt: .asciiz "Invalid input. Digits must be unique.\n"
    get_guess_prompt:  .asciiz "Guess my number: " 
    bool: .space 3
    guess: .space 3
    debug: .asciiz "debug\n"


.text
    main:   
    	# Argumnets for procedures 
    	la $a1, bool
    	la $a2, guess       	  	
    	jal get_number # Get input   
    	jal get_guess # Start guessing
    	j exit_program
    	    	   	
    get_number:
    	move $t0, $a1 # Store bool array in $t0
    	li $t1, 0 # Initialize digits counter to 0
        	print_string(input_prompt) 
    	j get_digit_loop   	
    
    get_digit_loop:
        # Get digit
    	bge $t1, 3, check_uniqueness
    	li $v0, 12
    	syscall 
    	move $t2, $v0
    	# Print new line
   	li $v0, 11
    	li $a0,'\n'
        syscall	  
     
    validate_digit:
        	bgt $t2, '9', invalid_character
    	blt $t2, '0', invalid_character	
	      	
    valid_digit:
        sb $t2, 0($t0) # Store digit in bool array
    	addi $t0, $t0, 1 # Move to next position in the array
    	addi $t1, $t1, 1 # Add one to digits counter
    	j get_digit_loop
  
    check_uniqueness:
   	# Store digits in registers
   	lb $t3, 0x00($a1)
   	lb $t4, 0x01($a1)
   	lb $t5, 0x02($a1)
   	# Check uniqueness
   	beq $t3, $t4, not_unique 
   	beq $t3, $t5, not_unique     
   	beq $t4, $t5, not_unique 
	jr $ra
      
    not_unique:
    	# When digits are not unique, print an error message and ask again for input
    	print_string(not_unique_prompt)
    	j get_number
    
    invalid_character:
    	# When characters are not in range, print an error message and ask again for input
    	print_string(invalid_character_prompt)
    	j get_number
    
    get_guess:
    	move $t0, $a1 # Store bool array in $t0
    	move $t6, $a2 # Store guess array in $t6	
    	print_string(get_guess_prompt)
    	li $v0, 8
    	syscall
    	move $t6, $v0
    	# Store guessed digits in registers
   	lb $t7, 0x00($a2)
   	lb $t8, 0x01($a2)
   	lb $t9, 0x02($a2)
   	li $v0, 11
   	move $a0, $t7
   	syscall
   	
    			
    exit_program:
   	li $v0, 10
   	syscall
