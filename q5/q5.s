.section .data
filename: .string "input.txt"
mode: .string "r" #since we only real 
yes: .string "Yes"
no: .string "No"

.section .text
.global main

main:
addi sp,sp,-40
sd ra,0(sp)
sd s0,8(sp)        # file pointer
sd s1,16(sp)       # file size
sd s2,24(sp)       # i
sd s3,32(sp)       # to store the left char
la a0,filename
la a1,mode
call fopen
add s0,a0,x0        # s0 is now the file pointer
add a0,s0,x0
add a1,x0,x0        # 0 offset we qant the LAST element
addi a2,x0,2        # we get the last element of the file so that we get the size of the file
call fseek          # fseek(file pointer,offset,begininng(0)/current(1)/end(2))
add a0,s0,x0
call ftell
add s1,a0,x0        # we have the size of the entire file here s1=file size
add s2,x0,x0        # i=0=s2

ispalindrome:
srli t0,s1,1
bge s2,t0,printoffyes   #if we havent found a bne then printyes
add a0,s0,x0
add a1,s2,x0
add a2,x0,x0
call fseek              #fseek(file pointer,i,0(start))
add a0,s0,x0
call fgetc
add s3,a0,x0       # save the left charecter
add a0,s0,x0
addi t0,s2,1
sub a1,x0,t0       # -i-1 cuz we need ith element from the end
addi a2,x0,2
call fseek         # fseek(file pointer, -i -1, 2(end))
add a0,s0,x0
call fgetc          # get ith charecter form the end 
bne s3,a0,printoffno    #if not equal print no
addi s2,s2,1            # i++
j ispalindrome          # loop back again

printoffyes:
la a0,yes
call printf
j wraps

printoffno:
la a0,no
call printf
j wraps         #for satisfaction (not really needed)

wraps:
ld ra,0(sp)
ld s0,8(sp)
ld s1,16(sp)
ld s2,24(sp)
ld s3,32(sp)   
addi sp,sp,40
ret

#ok
