.section .bss
.align 3
arr: .space 40000
st: .space 40000
res: .space 40000

.section .data
percnd: .string "%d"
minusone: .string "-1"
spas: .string " "

.section .text
.global main

main:
addi sp,sp,-48
sd ra,0(sp)
sd s0,8(sp)
sd s1,16(sp)
sd s2,24(sp)
sd s3,32(sp)
sd s4,40(sp)
addi s0,a0,-1          #s0=n-1
addi s1,a1,8           #the input array (skipping the ./a.out)
add t0,x0,x0           #t1 = i =0

buildarr:
bge t0,s0,buildarrdone
slli t1,t0,3           #cuz 8 byytes
add t2,s1,t1
ld t3,0(t2)            #loadinng form the argv they all are 8 bytes lowkey
add a0,t3,x0
call atoi              #convert string to int
slli t1,t0,2           #int is 4 bytes
la t2,arr              #t2 is the "arr" in c
add t2,t2,t1
sw a0,0(t2)            #store the number is arr
addi t0,t0,1           #i++
j buildarr

buildarrdone:
add t0,x0,x0

fillminusone:
bge t0,s0,fillminusonedone
slli t1,t0,2
addi t3,x0,-1
la t2,res
add t2,t2,t1
sw t3,0(t2)
addi t0,t0,1
j fillminusone

fillminusonedone:
add s2,x0,x0           #st.size in c top = st.size-1
addi s3,s0,-1           # i = n-1 cant use temp variable here cuz we might call some functions

realfunc:
blt s3,x0,realfuncdone #i>=0

realfuncpop:
beq s2,x0,realfuncpopdone
addi t0,s2,-1
slli t1,t0,2
la t2,st              # load address
add t2,t2,t1
lw t3,0(t2)           # t3= st[top]=some index in arr
slli t4,t3,2          #to load that element in arr and compare if less like in the while loop
la t5,arr
add t5,t5,t4          #t4=arr[st[top]]
lw t4,0(t5)           # overwrite considering the limitations on the number of temps
slli t3,s3,2
la t1,arr             #keep overwriting temps for fun
add t1,t1,t3
lw t5,0(t1)           #t5=arr[i]
bgt t4,t5,realfuncpopdone #if arr[st[top]]>arr[i] then while loop overwrite
addi s2,s2,-1         #st.pop() (while loop)
j realfuncpop

realfuncpopdone:
beq s2,x0,realfuncpush  #if stack is infact empty
addi t0,s2,-1           #top = size-1
slli t1,t0,2
la t2,st
add t2,t2,t1
lw t1,0(t2)             #same process to get there annd load value
la t3,res
slli t4,s3,2
add t3,t3,t4
sw t1,0(t3)             #store that value here that if statement below while is over now

realfuncpush:
la t1,st
slli t2,s2,2
add t1,t1,t2
sw s3,0(t1)
addi s2,s2,1            #same process to store as above(at ++top or st.size)
addi s3,s3,-1           #i--
j realfunc

realfuncdone:
add s3,x0,x0

printing:
bge s3,s0,wraps
slli t1,s3,2
la t2,res
add t2,t2,t1
lw s4,0(t2)
bne s3,x0,forspace     #if i==0 then theres no need of space before it lowk
j printoff

forspace:
la a0,spas
call printf            #just printf(" ")

printoff:
blt s4,x0,printminusone
la a0,percnd
add a1,s4,x0
call printf            #print the number ("%d",num)
j nextnumber

printminusone:
la a0,minusone          # no percnd cuz its a string lmao
call printf

nextnumber:
addi s3,s3,1            # i++
j printing

wraps:
addi a0,x0,0           #return 0; fire fire fire
ld ra,0(sp)
ld s0,8(sp)
ld s1,16(sp)
ld s2,24(sp)
ld s3,32(sp)
ld s4,40(sp)
addi sp,sp,48
ret

#ok

