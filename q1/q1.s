.global make_node
.global insert
.global get
.global getAtMost

#make_node(int val)

make_node:
    addi sp,sp,-16
    sd a0,8(sp)
    sd ra,0(sp)
    li a0,24
    call malloc     #get memory malloc(24)
    ld t1,8(sp)     #instead of getting it back in a0 we get it back in t1
    sd t1,0(a0)     #store the value in the given space (0->8 is val,8->16 is left,16->24 is right)
    sd x0,8(a0)     #store NULL in left and return
    sd x0,16(a0)
    ld ra,0(sp)     #get the return addy back
    addi sp,sp,16
    ret             #return a pointer to the node we just made

#insert(node* root,int val)

insert:
    addi sp,sp,-32
    sd a0,24(sp)
    sd a1,16(sp)
    sd ra,8(sp)
    ld t1,0(a0)        #load the value at the node
    blt a1,t1,goleft   #is less then go left j like in c
    ld t2,16(a0)       #root=root->right
    bne t2,x0,skip     #if !=NULL then go to make a node
    addi a0,a1,0       # if == NULL then make node (a0=val cuz the first parameter)
    call make_node
    add x3,a0,x0
    ld a0,24(sp)
    sd x3,16(a0)       #store the value the in val part of the new node and return
    j finish           #this is where any part of th efunc goes after its finished

skip:
    ld t3,16(a0)       #not equal to null branch so itll recurse again
    add a0,t3,x0       #root = root->right and then insert(root,val) a1 is a1
    call insert
    j finish           #and then after u return come here and goo all the way back

goleft:
    ld t4,8(a0)        
    bne t4,x0,skipl
    addi a0,a1,0
    call make_node     # same thing we did for right but with left and we load form 8 instead of 16 
    add x3,a0,x0
    ld a0,24(sp)
    sd x3,8(a0)
    j finish

skipl:
    ld t5,8(a0)
    add a0,t5,x0
    call insert
    j finish  #for the laughs

finish:
    ld a0,24(sp)
    ld a1,16(sp)
    ld ra,8(sp)
    addi sp,sp,32     # now we revert all the changes made and then call it a day
    ret

#node* get(node* root,int val)

get:
    addi sp,sp,-32
    sd a0,24(sp)
    sd a1,16(sp)
    sd ra,8(sp)
    beq a0,x0,iszero       # if node ==NULL then return null
    ld t0,0(a0)
    blt a1,t0,wentleft     # if out val(a1) is less than the node val then go left
    beq t0,a1,finshi       # if its equal then we found it and w can return
    ld a0,16(a0)           # gretwr than part  going right basically
    beq a0,x0,iszero
    call get               # recurse again and gotoinshi after done 
    j finshi

wentleft:
    ld a0,8(a0)
    beq a0,x0,iszero    #same recursion but for left
    call get
    j finshi

iszero:
    ld a0,24(sp)        # really useless but ok
    li a0,0             #to return NULL

finshi:
    ld a1,16(sp)
    ld ra,8(sp)
    addi sp,sp,32      #reverting out changes
    ret

#int getAtMost(int val,node* root)

getAtMost:
    addi sp,sp,-32
    sd a1,24(sp)
    sd a0,16(sp)
    sd ra,8(sp)
    addi t1,x0,-1
loop:
    beq a1,x0,ginish
    ld t2,0(a1)
    beq a0,t2,found         # j impliment the c code striaght away 
    blt a0,t2,goneleft
    addi t1,t2,0
    ld a1,16(a1)            # check the c while loop code for refernece
    j loop
goneleft:
    ld a1,8(a1)
    j loop
found:
    addi t1,a0,0

ginish:
    addi a0,t1,0
    ld ra,8(sp)
    addi sp,sp,32
    ret

