.globl main
.text
main:
li a0, 0x40400000 #load 0x404..... as first function argument
li a1, 0x3d400000 # load 0x3d4.... as second function argument
jal function # call function()
addi a0, zero, 10 #return
ecall             # zero



function:
fmv.w.x f0, a0 # f0 = a0 (bitwise copy);
fmv.w.x f1, a1# f1 = a1; (bitwise copy)
addi t0, zero, 5 # t0 = 5
fcvt.s.w f2, t0 # f2 = (float) t0; =5.0
addi t0, zero, 2 # t0 = 2
fcvt.s.w f3, t0 # f3 = (float) t0; = 2.0
addi t0, zero, 0 # t0 = 0
loop: #while
fadd.s f2, f2, f3 #f2 += f3;
fdiv.s f0, f0, f2 # f0 /= f2;
fmul.s f4, f0, f2 # f4 = f0 * f2;
flt t1, f4, f1 #t1 = f4 <f1
beq t0, t1, loop # loop cond: t1 = 0;
end:
jr ra