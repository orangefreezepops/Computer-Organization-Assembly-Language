#.text
#lui $at, 0xabcd
#ori $t0, $at, 0xdcba

.data

y: .byte 23
z: .byte 7
x: .byte 11

.text
la $t1, x
lb $t0, 0($t1)

la $t2, y
lb $t3, 0($t2)

la $t4, z


sub $t5, $t3, $t0
sb $t5, 0($t4)

sb $t5, -2($t1)
sb $t5, 0($t1)
 







#syscall

