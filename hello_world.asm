.data
    msg: .asciiz "Hello World!\n"

.text
    main:
    li $v0, 4 # Put the number 4 into register v0
    la $a0, msg # Put the address of “msg” into register a0.
    syscall
    