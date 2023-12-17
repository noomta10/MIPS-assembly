.data
    prompt: .asciiz "Enter a number between -9999 and 9999:\n"
    invalid_prompt: .asciiz "Invalid number. number must be between -9999 and 9999:\n"
    
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
