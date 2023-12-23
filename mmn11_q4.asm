# Registers:
# $t0 = copy of bool array
# $t1 = counter for number of digits, and counter for number of bool
# $t2 = store user's character input, and counter for number of p
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
    end_game_prompt: .asciiz "Bingo! Another game? "
    bool: .space 3
    guess: .space 4
    

.text
    main:   
    	# Argumnets for procedures 
    	la $a1, bool
    	la $a2, guess       	  	
    	jal get_number # Get input   

    call_get_guess:
    	beq $v0, -1, handle_end_game
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
    	beq $v0, -1, call_get_guess
    	move $t0, $a1 # Store bool array in $t0
    	move $t6, $a2 # Store guess array in $t6	
    	# Get user's guess
    	print_string(get_guess_prompt)
    	li $v0, 8
    	la $a0, ($t6)
    	syscall	
    	# Store guessed digits in registers
   	lb $t7, 0x00($a2)
   	lb $t8, 0x01($a2)
   	lb $t9, 0x02($a2)
   	j compare
   	  
    compare:
        move $t0, $a1 # Store bool array in $t0
        move $t6, $a2 # Store guess array in $t6	
        # Initialize bool counter and p counter
	li $t1, 0
   	li $t2, 0
   	jal first_character_bool_check
   	beq $t1, 3, bingo
   	jal first_character_p_check
   	jal check_no_bools
   	jal print_bools
   	jal print_ps
   	j get_guess
   	
    first_character_bool_check:
   	beq $t7, $t3,  first_character_is_bool
   	j second_character_bool_check
   
    first_character_is_bool:
    	addi $t1, $t1, 1
   	
    second_character_bool_check:   
   	beq $t8, $t4, second_character_is_bool
 	j third_character_bool_check
 
    second_character_is_bool:
    	addi $t1, $t1, 1	
 		
    third_character_bool_check:   
   	beq $t9, $t5, third_character_is_bool
 	jr $ra
 
    third_character_is_bool:
    	addi $t1, $t1, 1
    	jr $ra
    		
    first_character_p_check:
    	beq $t7, $t4, first_character_is_p
    	beq $t7, $t5, first_character_is_p
    	j second_character_p_check
    
    first_character_is_p:
    	addi, $t2, $t2, 1
    	
    second_character_p_check:
    	beq $t8, $t3, second_character_is_p
    	beq $t8, $t5, second_character_is_p
    	j third_character_p_check
    	
    second_character_is_p: 
    	addi, $t2, $t2, 1
     
    third_character_p_check:
    	beq $t9, $t3, third_character_is_p
    	beq $t9, $t4, third_character_is_p
    	jr $ra
    	
    third_character_is_p: 
    	addi, $t2, $t2, 1
    	jr $ra		
    
    bingo: 
    	li $v0, -1
    	j get_guess
    		
    check_no_bools:
    	beqz $t1, check_no_ps
    	jr $ra
    
    check_no_ps:
    	beqz $t2, print_no_matches
    	jr $ra
    
    print_no_matches:
    	li $v0, 11
    	li $a0, 'n'
    	syscall
    	j get_guess
      
    print_bools:
	bnez, $t1, print_bools_loop # Continue printing as long as bools counter is not 0
        jr $ra
    
    print_bools_loop:
        li $v0, 11
        li $a0, 'b'
        syscall
        addi, $t1, $t1, -1
        j print_bools

    print_ps:
	bnez, $t2, print_ps_loop # Continue printing as long as ps counter is not 0
        jr $ra
    
    print_ps_loop:
        li $v0, 11
        li $a0, 'p'
        syscall
        addi, $t2, $t2, -1
        j print_ps   					
 
    handle_end_game:
    	print_string(end_game_prompt)
    	li $v0, 12
    	syscall
    	beq $v0, 'y', main
    	beq $v0, 'n', exit_program
   					   					   					  					   					   					  					   					   					  					   					   					
    exit_program:
   	li $v0, 10
   	syscall
