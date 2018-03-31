#MIPS test program for our processor to make sure branching and storing are working
addi $10,$10,6 #set R10 to 6
addi $11,$11,2
sub $10,$10,$11 #R10 = R10-R11 = 4
addi $12,$12,2 #R12 = 2
addi $7,$7,30 #load 30 into R7
mult $7,$12 # $LO should be 30 now
mflo $9 #free up LO register for testing div
addi $8,$8,-30 #testing negative add immediate
start: add $2,$1,$2 
add $3,$2,$2
bne $3,$7,start #keeps looping until R3 = R7 (30)
jal next #jump to next set of tests
sw $1,0($10) #store into memory at address 4
sw $2,1($10) #address 5
sw $3,2($0) #address 2
sw $7,2($10)
sw $8,3($10)
sw $9,4($10)
sw $10,5($10)
sw $11,6($10)
sw $12,7($10)
sw $13,8($10)
sw $14,9($10)
sw $15,10($10)
sw $16,11($10)
sw $17,12($10)
sw $18,13($10)
lw $4,0($10) #load the contents previously stored into new registers
lw $5,1($10)
lw $6,2($0)
j infloop
next: addi $13,$13,1
addi $14,$14,5
div $14,$13 # 5/1 test divide
mflo $15
addi $16,$16,37
sll $16,$16,$11 #shift left by 2
xor $18,$17,$16 
jr $31 #will go to the storing and loading to wrap up our tests
infloop: add $0,$0,$0
beq $0,$0,infloop #programming ending in an infinite loop