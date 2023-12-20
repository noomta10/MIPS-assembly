# Registers:
# $t0 = copy of bool array
# $t1 = first digit
# $t2 = second digit
# $t3 = third digit

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
    input_prompt: .asciiz "Enter 3 different digits:\n"
    invalid_input_prompt: "Invalid digit. Digit must be between 0 and 9:\n"
    bool: .space 4


.text
    main:   
    	la $a0, bool  # Put bool in $a0 for get_number use
    	
    get_number:
        	print_string(input_prompt)
    	move $t0, $a0 # Copy bool array to $t0
    	jal get_digit
        
    invalid_input:
    	print_string(invalid_input_prompt)
    	j get_digit	
    
    get_digit:
    	li $v0, 12
    	syscall 
    	move $t1, $v0 # Copy digit to $t1
    
    validate_digit:
    	bgt $t1, '9', invalid_input	
    	blt $t1, '0', invalid_input
    	
   exit_program:
   	li $v0, 10
   	syscall
    	

    	
    	