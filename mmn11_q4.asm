# Name: Noam Tamir 213712284
# Due date: 14.01.2024

# Description:
# This program takes a 3 digit number from the user. digits are unique and witin the range '0'-'9'.
# Then it plays 'Bool-Pgia' with user's guesses (assuming that are valid), prints 'b' for every exact match, 'p' for every match, and 'n' for no matches.
# The game continues until the user succeeds to guess the number that was entered in the beginning of the game.	
# Finally, the user can choose whether to continue for another game or end the game.

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
# $a1 = bool array address
# $a2 = guess array address


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
    input_prompt: .asciiz "\nEnter 3 different digits:\n"
    invalid_character_prompt: .asciiz "Invalid digit. Digit must be between 0 and 9."
    not_unique_prompt: .asciiz "Invalid input. Digits must be unique."
    get_guess_prompt:  .asciiz "\nGuess my number: " 
    bingo_prompt: .asciiz "Bingo!\n"
    end_game_prompt: .asciiz "Another game? ('y' for yes, 'n' for no): "
    invalid_option_prompt: .asciiz "Invalid option. Option must be 'y' or 'n'.\n"
    bool: .space 3
    guess: .space 4
    

.text
    main:   
    	# Argumnets for procedures 
    	la $a1, bool
    	la $a2, guess       	  	
    	jal get_number # Get input

    # Get guess
    call_get_guess:
    	beq $v0, -1, handle_end_game # If $v0 contains -1, handle end game
    	jal get_guess 
    
    # Get input from user	   	
    get_number:
    	move $t0, $a1 # Store bool array in $t0
    	li $t1, 0 # Initialize digits counter to 0
        print_string(input_prompt) 
    	j get_number_loop   	
    
    # Loop to get 3 digits characaters
    get_number_loop:
    	bge $t1, 3, check_uniqueness # if 3 digits were read, continue and check their uniqueness
    	li $v0, 12
    	syscall 
    	move $t2, $v0	  
     
    # Validate that the digit is a character between '0'-'9'
    validate_digit:
        bgt $t2, '9', invalid_character
    	blt $t2, '0', invalid_character	
	
    # If the digit is valid, store it in bool array  	      	
    valid_digit:
        sb $t2, 0($t0) # Store digit in bool array
    	addi $t0, $t0, 1 # Move to next position in the array
    	addi $t1, $t1, 1 # Add one to digits counter
    	j get_number_loop
  
    # Check that each digit in bool is unique
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
      
    # Handle when bool contains a digit that appears more than once
    not_unique:
    	# Print an error message and ask again for input
    	print_string(not_unique_prompt)
    	j get_number
    
    # Handle when a character that is not in range was entered
    invalid_character:
    	# Print an error message and ask again for input
    	print_string(invalid_character_prompt)
    	j get_number
    
    # Get user's guess
    get_guess:
    	beq $v0, -1, call_get_guess # if $v0 contains -1, user guessed correctly, return to main
    	move $t0, $a1 # Store bool array in $t0
    	move $t6, $a2 # Store guess array in $t6	
    	# Get user's guess into guess array
    	print_string(get_guess_prompt)
    	li $v0, 8
    	la $a0, ($t6)
    	syscall	
    	# Store guessed digits in registers
   	lb $t7, 0x00($t6)
   	lb $t8, 0x01($t6)
   	lb $t9, 0x02($t6)
   	j compare
   	
    # Compare digits from bool array to digits from guess array
    compare:
        move $t0, $a1 # Store bool array in $t0
        move $t6, $a2 # Store guess array in $t6	
        # Initialize bool counter and p counter
	li $t1, 0
   	li $t2, 0  	
   	jal first_character_bool_check # Check bools	
   	beq $t1, 3, bingo # Check if there are 3 bools   	
   	jal first_character_p_check # Check ps   	
   	jal check_no_bools # Check no matches (no bools and no ps)
   	# Print 'b' and 'p' 
   	jal print_bools
   	jal print_ps   	
   	j get_guess # Continue getting guesses if user did not guess correctly yet
   	
    # Check bools
    first_character_bool_check:
   	beq $t7, $t3,  first_character_is_bool # Compare first digit in bool array to first digit in guess array
   	j second_character_bool_check # If they are not equal, continue to compare second digits
   
    first_character_is_bool:
    	addi $t1, $t1, 1 # If digits are equal, add 1 to bool counter
   	
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

    # Check ps		    		
    first_character_p_check:
    	beq $t7, $t4, first_character_is_p # Compare first digit in guess array to second digit in bool array
    	beq $t7, $t5, first_character_is_p # Compare first digit in guess array to third digit in bool array
    	j second_character_p_check  # If they are not equal, continue to compare second digits
    
    first_character_is_p:
    	addi, $t2, $t2, 1  #If digits are equal, add 1 to p counter
    	
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
    
    # When user guessed 3 bools, return value -1 in $v0 to get_guess
    bingo: 
    	li $v0, -1
    	j get_guess
    	
    # Check if there are any bools			
    check_no_bools:
    	beqz $t1, check_no_ps
    	jr $ra

    # Check if there are any ps    
    check_no_ps:
    	beqz $t2, print_no_matches
    	jr $ra
    
    # Print 'n' when no bools or ps in guess
    print_no_matches:
    	li $v0, 11
    	li $a0, 'n'
    	syscall
    	j get_guess
      
    # Print bools  
    print_bools:
	bnez, $t1, print_bools_loop # Continue printing as long as bools counter is not 0
        jr $ra
    
    print_bools_loop:
        li $v0, 11
        li $a0, 'b'
        syscall
        addi, $t1, $t1, -1
        j print_bools

    # Print ps
    print_ps:
	bnez, $t2, print_ps_loop # Continue printing as long as ps counter is not 0
        jr $ra
    
    print_ps_loop:
        li $v0, 11
        li $a0, 'p'
        syscall
        addi, $t2, $t2, -1
        j print_ps   					
 
    # Handle end game
    handle_end_game:
    	print_string(bingo_prompt)
    	j ask_for_another_game
    
    # Ask if the user wants to continue for another game
    ask_for_another_game:
    	print_string(end_game_prompt)
    	li $v0, 12
    	syscall
    	beq $v0, 'y', main
    	beq $v0, 'n', exit_program
    	j invalid_option
    
    # If an invalid option was entered, ask again for input
    invalid_option:
    	print_string(invalid_option_prompt)
    	j ask_for_another_game
   	
    # Exit program				   					   					  					   					   					  					   					   					  					   					   					
    exit_program:
   	li $v0, 10
   	syscall
