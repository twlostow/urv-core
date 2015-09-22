.text

.global main2
main2:

    li t0, 1000
    li t1, 7
    
    div t2,t0,t1
    li t0,2000
    divu t2,t0,t1

forever:
    j forever