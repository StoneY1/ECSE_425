#MIPS test program for our processor to make sure branching and storing are working
addi $10,$10,4 #set R10 to 4 for memory addressing
addi $7,$7,30 #register 7 will be 30 for the bne
start: add $2,$1,$2 
add $3,$2,$2
bne $3,$7,start #keeps looping until R3 = R7 (30)
sw $1,0($10) #store into memory at address 4
sw $2,1($10) #address 5
sw $3,2($0) #address 2
lw $4,0($10) #load the contents previously stored into new registers
lw $5,1($10)
lw $6,2($0)
