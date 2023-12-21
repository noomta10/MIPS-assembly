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

.text
    get_number:
        	print_string(input_prompt)
        	li $v0, 12    	
    	syscall 
    	move $t2, $v0
    
     print_char:       
	# Print char
    	li $v0, 11
    	move $a0, $t2
    	syscall
    	 # Print new line
   	li $v0,11
    	li $a0,'\n'
        j get_number 
