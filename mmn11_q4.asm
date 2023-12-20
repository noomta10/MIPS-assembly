.macro  print_string (%x)
    li $v0, 4
    la $a0, %x
    syscall
.end_macro


.data


.text