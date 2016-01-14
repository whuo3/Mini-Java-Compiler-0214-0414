main:
 jal mj_main
 li $v0, 10
 syscall

minijavaNew:
 move $t0, $a0
 mul $a0, $a1, 4
 li $v0, 9
 syscall
 sw $t0, ($v0)
 j $ra

minijavaNewArray:
 move $t0, $a0
 mul $a0, $a0, 4
 add $a0, $a0, 4
 li $v0, 9
 syscall
 sw $t0, ($v0)
 j $ra

.data
.align 4
minijavaNewline:
 .asciiz "\n"

.text
minijavaPrint:
 li $v0, 1
 syscall
 la $a0, minijavaNewline
 li $v0, 4
 syscall
 j $ra

mj_main:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 0(0): NewObj *TV :TV
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 la $a0, mj__v_TV
 li $a1, 1
 jal minijavaNew
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 # a0: 1(0): Call 0 *Start() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 move $v0, $a0
 lw $v1, ($v0)
 lw $v1, 0($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 # a0: 2(0): Print 1 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 .ret_mj_main:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
.data
.align 4
mj__v_TV:
 .word mj__m_TV_Start
.text
mj__m_TV_Start:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -20
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 3(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 4(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a0: 5(0): Null *Type(int) :int
 move $a0, $zero
 # a0: 6(0): Null *Type(MyVisitor) :MyVisitor
 move $a0, $zero
 # a0: 7(0): NewObj *Tree :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 la $a0, mj__v_Tree
 li $a1, 7
 jal minijavaNew
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a1: 8(1): VarAssg 7 *root :Tree
 move $a1, $a0
 # a0: 9(0): Int *16 :int
 li $a0, 16
 # a0: 10(0): Arg 9 *0 :int
 move $a0, $a0
 # a0: 11(0): Call 8 *Init(10) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 0($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 12(0): VarAssg 11 *ntb :boolean
 move $a0, $a0
 # a0: 13(0): Call 8 *Print() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 72($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 14(0): VarAssg 13 *ntb :boolean
 move $a0, $a0
 # a0: 15(0): Int *100000000 :int
 li $a0, 100000000
 # a0: 16(0): Print 15 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 17(0): Int *8 :int
 li $a0, 8
 # a0: 18(0): Arg 17 *0 :int
 move $a0, $a0
 # a0: 19(0): Call 8 *Insert(18) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 20(0): VarAssg 19 *ntb :boolean
 move $a0, $a0
 # a0: 21(0): Int *24 :int
 li $a0, 24
 # a0: 22(0): Arg 21 *0 :int
 move $a0, $a0
 # a0: 23(0): Call 8 *Insert(22) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 24(0): VarAssg 23 *ntb :boolean
 move $a0, $a0
 # a0: 25(0): Int *4 :int
 li $a0, 4
 # a0: 26(0): Arg 25 *0 :int
 move $a0, $a0
 # a0: 27(0): Call 8 *Insert(26) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 28(0): VarAssg 27 *ntb :boolean
 move $a0, $a0
 # a0: 29(0): Int *12 :int
 li $a0, 12
 # a0: 30(0): Arg 29 *0 :int
 move $a0, $a0
 # a0: 31(0): Call 8 *Insert(30) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 32(0): VarAssg 31 *ntb :boolean
 move $a0, $a0
 # a0: 33(0): Int *20 :int
 li $a0, 20
 # a0: 34(0): Arg 33 *0 :int
 move $a0, $a0
 # a0: 35(0): Call 8 *Insert(34) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 36(0): VarAssg 35 *ntb :boolean
 move $a0, $a0
 # a0: 37(0): Int *28 :int
 li $a0, 28
 # a0: 38(0): Arg 37 *0 :int
 move $a0, $a0
 # a0: 39(0): Call 8 *Insert(38) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 40(0): VarAssg 39 *ntb :boolean
 move $a0, $a0
 # a0: 41(0): Int *14 :int
 li $a0, 14
 # a0: 42(0): Arg 41 *0 :int
 move $a0, $a0
 # a0: 43(0): Call 8 *Insert(42) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 48($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 44(0): VarAssg 43 *ntb :boolean
 move $a0, $a0
 # a0: 45(0): Call 8 *Print() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 72($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 46(0): VarAssg 45 *ntb :boolean
 move $a0, $a0
 # a0: 47(0): Int *100000000 :int
 li $a0, 100000000
 # a0: 48(0): Print 47 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 49(0): NewObj *MyVisitor :MyVisitor
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 la $a0, mj__v_MyVisitor
 li $a1, 3
 jal minijavaNew
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 50(0): VarAssg 49 *v :MyVisitor
 move $a0, $a0
 # a2: 51(2): Int *50000000 :int
 li $a2, 50000000
 # a2: 52(2): Print 51 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a2
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 53(0): Arg 50 *0 :MyVisitor
 move $a0, $a0
 # a0: 54(0): Call 8 *accept(53) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 80($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 55(0): VarAssg 54 *nti :int
 move $a0, $a0
 # a0: 56(0): Int *100000000 :int
 li $a0, 100000000
 # a0: 57(0): Print 56 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 58(0): Int *24 :int
 li $a0, 24
 # a0: 59(0): Arg 58 *0 :int
 move $a0, $a0
 # a0: 60(0): Call 8 *Search(59) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 61(0): Print 60 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 62(0): Int *12 :int
 li $a0, 12
 # a0: 63(0): Arg 62 *0 :int
 move $a0, $a0
 # a0: 64(0): Call 8 *Search(63) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 65(0): Print 64 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 66(0): Int *16 :int
 li $a0, 16
 # a0: 67(0): Arg 66 *0 :int
 move $a0, $a0
 # a0: 68(0): Call 8 *Search(67) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 69(0): Print 68 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 70(0): Int *50 :int
 li $a0, 50
 # a0: 71(0): Arg 70 *0 :int
 move $a0, $a0
 # a0: 72(0): Call 8 *Search(71) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 73(0): Print 72 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 74(0): Int *12 :int
 li $a0, 12
 # a0: 75(0): Arg 74 *0 :int
 move $a0, $a0
 # a0: 76(0): Call 8 *Search(75) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 77(0): Print 76 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 78(0): Int *12 :int
 li $a0, 12
 # a0: 79(0): Arg 78 *0 :int
 move $a0, $a0
 # a0: 80(0): Call 8 *Delete(79) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 52($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 81(0): VarAssg 80 *ntb :boolean
 move $a0, $a0
 # a0: 82(0): Call 8 *Print() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 72($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 83(0): VarAssg 82 *ntb :boolean
 move $a0, $a0
 # a0: 84(0): Int *12 :int
 li $a0, 12
 # a0: 85(0): Arg 84 *0 :int
 move $a0, $a0
 # a0: 86(0): Call 8 *Search(85) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 68($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 87(0): Print 86 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 88(0): Int *0 :int
 li $a0, 0
 # a0: 89(0): Return 88 :void
 move $v0, $a0
 j .ret_mj__m_TV_Start
 .ret_mj__m_TV_Start:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
.data
.align 4
mj__v_Tree:
 .word mj__m_Tree_Init
 .word mj__m_Tree_SetRight
 .word mj__m_Tree_SetLeft
 .word mj__m_Tree_GetRight
 .word mj__m_Tree_GetLeft
 .word mj__m_Tree_GetKey
 .word mj__m_Tree_SetKey
 .word mj__m_Tree_GetHas_Right
 .word mj__m_Tree_GetHas_Left
 .word mj__m_Tree_SetHas_Left
 .word mj__m_Tree_SetHas_Right
 .word mj__m_Tree_Compare
 .word mj__m_Tree_Insert
 .word mj__m_Tree_Delete
 .word mj__m_Tree_Remove
 .word mj__m_Tree_RemoveRight
 .word mj__m_Tree_RemoveLeft
 .word mj__m_Tree_Search
 .word mj__m_Tree_Print
 .word mj__m_Tree_RecPrint
 .word mj__m_Tree_accept
.text
mj__m_Tree_Init:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 90(0): Parameter *0 :int
 # a0: 91(0): VarAssg 90 *v_key :int
 move $a0, $a0
 # a1: 92(1): This :Tree
 move $a1, $v0
 # a0: 93(0): MemberAssg 92 91 *key :int
 sw $a0, 12($a1)
 move $a0, $a0
 # a1: 94(1): This :Tree
 move $a1, $v0
 # a0: 95(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 96(0): MemberAssg 94 95 *has_left :boolean
 sw $a0, 16($a1)
 move $a0, $a0
 # a1: 97(1): This :Tree
 move $a1, $v0
 # a0: 98(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 99(0): MemberAssg 97 98 *has_right :boolean
 sw $a0, 20($a1)
 move $a0, $a0
 # a0: 100(0): Boolean *true :boolean
 li $a0, 1
 # a0: 101(0): Return 100 :void
 move $v0, $a0
 j .ret_mj__m_Tree_Init
 .ret_mj__m_Tree_Init:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_SetRight:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 102(0): Parameter *0 :Tree
 # a0: 103(0): VarAssg 102 *rn :Tree
 move $a0, $a0
 # a1: 104(1): This :Tree
 move $a1, $v0
 # a0: 105(0): MemberAssg 104 103 *right :Tree
 sw $a0, 8($a1)
 move $a0, $a0
 # a0: 106(0): Boolean *true :boolean
 li $a0, 1
 # a0: 107(0): Return 106 :void
 move $v0, $a0
 j .ret_mj__m_Tree_SetRight
 .ret_mj__m_Tree_SetRight:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_SetLeft:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 108(0): Parameter *0 :Tree
 # a1: 109(1): VarAssg 108 *ln :Tree
 move $a1, $a0
 # a0: 110(0): This :Tree
 move $a0, $v0
 # a0: 111(0): MemberAssg 110 109 *left :Tree
 sw $a1, 4($a0)
 move $a0, $a1
 # a0: 112(0): Boolean *true :boolean
 li $a0, 1
 # a0: 113(0): Return 112 :void
 move $v0, $a0
 j .ret_mj__m_Tree_SetLeft
 .ret_mj__m_Tree_SetLeft:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_GetRight:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 114(0): This :Tree
 move $a0, $v0
 # a0: 115(0): Member 114 *right :Tree
 lw $a0, 8($a0)
 # a0: 116(0): Return 115 :void
 move $v0, $a0
 j .ret_mj__m_Tree_GetRight
 .ret_mj__m_Tree_GetRight:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_GetLeft:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 117(0): This :Tree
 move $a0, $v0
 # a0: 118(0): Member 117 *left :Tree
 lw $a0, 4($a0)
 # a0: 119(0): Return 118 :void
 move $v0, $a0
 j .ret_mj__m_Tree_GetLeft
 .ret_mj__m_Tree_GetLeft:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_GetKey:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 120(0): This :Tree
 move $a0, $v0
 # a0: 121(0): Member 120 *key :int
 lw $a0, 12($a0)
 # a0: 122(0): Return 121 :void
 move $v0, $a0
 j .ret_mj__m_Tree_GetKey
 .ret_mj__m_Tree_GetKey:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_SetKey:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 123(0): Parameter *0 :int
 # a1: 124(1): VarAssg 123 *v_key :int
 move $a1, $a0
 # a0: 125(0): This :Tree
 move $a0, $v0
 # a0: 126(0): MemberAssg 125 124 *key :int
 sw $a1, 12($a0)
 move $a0, $a1
 # a0: 127(0): Boolean *true :boolean
 li $a0, 1
 # a0: 128(0): Return 127 :void
 move $v0, $a0
 j .ret_mj__m_Tree_SetKey
 .ret_mj__m_Tree_SetKey:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_GetHas_Right:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 129(0): This :Tree
 move $a0, $v0
 # a0: 130(0): Member 129 *has_right :boolean
 lw $a0, 20($a0)
 # a0: 131(0): Return 130 :void
 move $v0, $a0
 j .ret_mj__m_Tree_GetHas_Right
 .ret_mj__m_Tree_GetHas_Right:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_GetHas_Left:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -12
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 132(0): This :Tree
 move $a0, $v0
 # a0: 133(0): Member 132 *has_left :boolean
 lw $a0, 16($a0)
 # a0: 134(0): Return 133 :void
 move $v0, $a0
 j .ret_mj__m_Tree_GetHas_Left
 .ret_mj__m_Tree_GetHas_Left:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_SetHas_Left:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 135(0): Parameter *0 :boolean
 # a0: 136(0): VarAssg 135 *val :boolean
 move $a0, $a0
 # a1: 137(1): This :Tree
 move $a1, $v0
 # a0: 138(0): MemberAssg 137 136 *has_left :boolean
 sw $a0, 16($a1)
 move $a0, $a0
 # a0: 139(0): Boolean *true :boolean
 li $a0, 1
 # a0: 140(0): Return 139 :void
 move $v0, $a0
 j .ret_mj__m_Tree_SetHas_Left
 .ret_mj__m_Tree_SetHas_Left:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_SetHas_Right:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 141(0): Parameter *0 :boolean
 # a0: 142(0): VarAssg 141 *val :boolean
 move $a0, $a0
 # a1: 143(1): This :Tree
 move $a1, $v0
 # a0: 144(0): MemberAssg 143 142 *has_right :boolean
 sw $a0, 20($a1)
 move $a0, $a0
 # a0: 145(0): Boolean *true :boolean
 li $a0, 1
 # a0: 146(0): Return 145 :void
 move $v0, $a0
 j .ret_mj__m_Tree_SetHas_Right
 .ret_mj__m_Tree_SetHas_Right:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Compare:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -20
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 147(0): Parameter *0 :int
 # a1: 148(1): Parameter *1 :int
 # a2: 149(2): VarAssg 147 *num1 :int
 move $a2, $a0
 # a0: 150(0): VarAssg 148 *num2 :int
 move $a0, $a1
 # a1: 151(1): Null *Type(boolean) :boolean
 move $a1, $zero
 # a1: 152(1): Null *Type(int) :int
 move $a1, $zero
 # a1: 153(1): Boolean *false :boolean
 move $a1, $zero
 # a1: 154(1): VarAssg 153 *ntb :boolean
 move $a1, $a1
 # a1: 155(1): Int *1 :int
 li $a1, 1
 # a1: 156(1): Plus 150 155 :int
 add $a1, $a0, $a1
 # a1: 157(1): VarAssg 156 *nti :int
 move $a1, $a1
 # a0: 158(0): Lt 149 150 :boolean
 slt $a0, $a2, $a0
 # a0: 159(0): NBranch 158 *lif_1858758426_else :void
 beq $a0, $zero, .lif_1858758426_else
 # a0: 160(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 161(0): VarAssg 160 *ntb :boolean
 move $a0, $a0
 # a1: 162(1): Goto *lif_1858758426_done :void
 j .lif_1858758426_done
 # a0: 163(0): Label *lif_1858758426_else :void
 .lif_1858758426_else:
 # a0: 164(0): Lt 149 157 :boolean
 slt $a0, $a2, $a1
 # a0: 165(0): Not 164 :boolean
 seq $a0, $zero, $a0
 # a0: 166(0): NBranch 165 *lif_708252873_else :void
 beq $a0, $zero, .lif_708252873_else
 # a0: 167(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 168(0): VarAssg 167 *ntb :boolean
 move $a0, $a0
 # a1: 169(1): Goto *lif_708252873_done :void
 j .lif_708252873_done
 # a0: 170(0): Label *lif_708252873_else :void
 .lif_708252873_else:
 # a0: 171(0): Boolean *true :boolean
 li $a0, 1
 # a0: 172(0): VarAssg 171 *ntb :boolean
 move $a0, $a0
 # a1: 173(1): Label *lif_708252873_done :void
 .lif_708252873_done:
 # a0: 174(0): Unify 168 172 :boolean
 # a1: 175(1): Label *lif_1858758426_done :void
 .lif_1858758426_done:
 # a0: 176(0): Unify 161 174 :boolean
 # a0: 177(0): Return 176 :void
 move $v0, $a0
 j .ret_mj__m_Tree_Compare
 .ret_mj__m_Tree_Compare:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Insert:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -36
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 178(0): Parameter *0 :int
 # t0: 179(4): VarAssg 178 *v_key :int
 move $t0, $a0
 # a0: 180(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 181(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a0: 182(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 183(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a2: 184(2): Null *Type(int) :int
 move $a2, $zero
 # a0: 185(0): NewObj *Tree :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 la $a0, mj__v_Tree
 li $a1, 7
 jal minijavaNew
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a1: 186(1): VarAssg 185 *new_node :Tree
 move $a1, $a0
 # a0: 187(0): Arg 179 *0 :int
 move $a0, $t0
 # a0: 188(0): Call 186 *Init(187) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 0($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # t1: 189(5): VarAssg 188 *ntb :boolean
 move $t1, $a0
 # a0: 190(0): This :Tree
 move $a0, $v0
 # a3: 191(3): VarAssg 190 *current_node :Tree
 move $a3, $a0
 # a0: 192(0): Boolean *true :boolean
 li $a0, 1
 # t2: 193(6): VarAssg 192 *cont :boolean
 move $t2, $a0
 # a0: 194(0): Label *lwhile_774088025_start :void
 .lwhile_774088025_start:
 # a0: 195(0): NBranch 193 *lwhile_774088025_end :void
 beq $t2, $zero, .lwhile_774088025_end
 # a0: 196(0): Call 191 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a2: 197(2): VarAssg 196 *key_aux :int
 move $a2, $a0
 # a0: 198(0): Lt 179 197 :boolean
 slt $a0, $t0, $a2
 # a0: 199(0): NBranch 198 *lif_641502649_else :void
 beq $a0, $zero, .lif_641502649_else
 # a0: 200(0): Call 191 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a0: 201(0): NBranch 200 *lif_1367113803_else :void
 beq $a0, $zero, .lif_1367113803_else
 # a0: 202(0): Call 191 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a3: 203(3): VarAssg 202 *current_node :Tree
 move $a3, $a0
 # a0: 204(0): Goto *lif_1367113803_done :void
 j .lif_1367113803_done
 # a0: 205(0): Label *lif_1367113803_else :void
 .lif_1367113803_else:
 # a0: 206(0): Boolean *false :boolean
 move $a0, $zero
 # t2: 207(6): VarAssg 206 *cont :boolean
 move $t2, $a0
 # a0: 208(0): Boolean *true :boolean
 li $a0, 1
 # a0: 209(0): Arg 208 *0 :boolean
 move $a0, $a0
 # a0: 210(0): Call 191 *SetHas_Left(209) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 36($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a0: 211(0): VarAssg 210 *ntb :boolean
 move $a0, $a0
 # a0: 212(0): Arg 186 *0 :Tree
 move $a0, $a1
 # a0: 213(0): Call 191 *SetLeft(212) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 8($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # t1: 214(5): VarAssg 213 *ntb :boolean
 move $t1, $a0
 # a0: 215(0): Label *lif_1367113803_done :void
 .lif_1367113803_done:
 # t1: 216(5): Unify 189 214 :boolean
 # t2: 217(6): Unify 193 207 :boolean
 # a3: 218(3): Unify 203 191 :Tree
 # a0: 219(0): Goto *lif_641502649_done :void
 j .lif_641502649_done
 # a0: 220(0): Label *lif_641502649_else :void
 .lif_641502649_else:
 # a0: 221(0): Call 191 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a0: 222(0): NBranch 221 *lif_1154147768_else :void
 beq $a0, $zero, .lif_1154147768_else
 # a0: 223(0): Call 191 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a3: 224(3): VarAssg 223 *current_node :Tree
 move $a3, $a0
 # a0: 225(0): Goto *lif_1154147768_done :void
 j .lif_1154147768_done
 # a0: 226(0): Label *lif_1154147768_else :void
 .lif_1154147768_else:
 # a0: 227(0): Boolean *false :boolean
 move $a0, $zero
 # t2: 228(6): VarAssg 227 *cont :boolean
 move $t2, $a0
 # a0: 229(0): Boolean *true :boolean
 li $a0, 1
 # a0: 230(0): Arg 229 *0 :boolean
 move $a0, $a0
 # a0: 231(0): Call 191 *SetHas_Right(230) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 40($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # a0: 232(0): VarAssg 231 *ntb :boolean
 move $a0, $a0
 # a0: 233(0): Arg 186 *0 :Tree
 move $a0, $a1
 # a0: 234(0): Call 191 *SetRight(233) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 4($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 # t1: 235(5): VarAssg 234 *ntb :boolean
 move $t1, $a0
 # a0: 236(0): Label *lif_1154147768_done :void
 .lif_1154147768_done:
 # t1: 237(5): Unify 189 235 :boolean
 # t2: 238(6): Unify 193 228 :boolean
 # a3: 239(3): Unify 224 191 :Tree
 # a0: 240(0): Label *lif_641502649_done :void
 .lif_641502649_done:
 # t2: 241(6): Unify 217 238 :boolean
 # t1: 242(5): Unify 216 237 :boolean
 # a3: 243(3): Unify 218 239 :Tree
 # a0: 244(0): Goto *lwhile_774088025_start :void
 j .lwhile_774088025_start
 # a0: 245(0): Label *lwhile_774088025_end :void
 .lwhile_774088025_end:
 # t1: 246(5): Unify 189 242 :boolean
 # a2: 247(2): Unify 184 197 :int
 # t2: 248(6): Unify 193 241 :boolean
 # a3: 249(3): Unify 191 243 :Tree
 # a0: 250(0): Boolean *true :boolean
 li $a0, 1
 # a0: 251(0): Return 250 :void
 move $v0, $a0
 j .ret_mj__m_Tree_Insert
 .ret_mj__m_Tree_Insert:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Delete:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -44
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 252(0): Parameter *0 :int
 # a3: 253(3): VarAssg 252 *v_key :int
 move $a3, $a0
 # a0: 254(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 255(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 256(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a0: 257(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a1: 258(1): Null *Type(boolean) :boolean
 move $a1, $zero
 # a0: 259(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # t1: 260(5): Null *Type(int) :int
 move $t1, $zero
 # a0: 261(0): This :Tree
 move $a0, $v0
 # t2: 262(6): VarAssg 261 *current_node :Tree
 move $t2, $a0
 # a0: 263(0): This :Tree
 move $a0, $v0
 # t0: 264(4): VarAssg 263 *parent_node :Tree
 move $t0, $a0
 # a0: 265(0): Boolean *true :boolean
 li $a0, 1
 # t4: 266(8): VarAssg 265 *cont :boolean
 move $t4, $a0
 # a0: 267(0): Boolean *false :boolean
 move $a0, $zero
 # t3: 268(7): VarAssg 267 *found :boolean
 move $t3, $a0
 # a0: 269(0): Boolean *true :boolean
 li $a0, 1
 # a0: 270(0): VarAssg 269 *is_root :boolean
 move $a0, $a0
 # a2: 271(2): Label *lwhile_1689237072_start :void
 .lwhile_1689237072_start:
 # a2: 272(2): NBranch 266 *lwhile_1689237072_end :void
 beq $t4, $zero, .lwhile_1689237072_end
 # a2: 273(2): Call 262 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a2, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # t1: 274(5): VarAssg 273 *key_aux :int
 move $t1, $a2
 # a2: 275(2): Lt 253 274 :boolean
 slt $a2, $a3, $t1
 # a2: 276(2): NBranch 275 *lif_1273655764_else :void
 beq $a2, $zero, .lif_1273655764_else
 # a0: 277(0): Call 262 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a0: 278(0): NBranch 277 *lif_215432252_else :void
 beq $a0, $zero, .lif_215432252_else
 # t0: 279(4): VarAssg 262 *parent_node :Tree
 move $t0, $t2
 # a0: 280(0): Call 262 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # t2: 281(6): VarAssg 280 *current_node :Tree
 move $t2, $a0
 # a0: 282(0): Goto *lif_215432252_done :void
 j .lif_215432252_done
 # a0: 283(0): Label *lif_215432252_else :void
 .lif_215432252_else:
 # a0: 284(0): Boolean *false :boolean
 move $a0, $zero
 # t4: 285(8): VarAssg 284 *cont :boolean
 move $t4, $a0
 # a0: 286(0): Label *lif_215432252_done :void
 .lif_215432252_done:
 # t0: 287(4): Unify 279 264 :Tree
 # t4: 288(8): Unify 266 285 :boolean
 # t2: 289(6): Unify 281 262 :Tree
 # a0: 290(0): Goto *lif_1273655764_done :void
 j .lif_1273655764_done
 # a2: 291(2): Label *lif_1273655764_else :void
 .lif_1273655764_else:
 # a2: 292(2): Lt 274 253 :boolean
 slt $a2, $t1, $a3
 # a2: 293(2): NBranch 292 *lif_112430522_else :void
 beq $a2, $zero, .lif_112430522_else
 # a0: 294(0): Call 262 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a0: 295(0): NBranch 294 *lif_1981657541_else :void
 beq $a0, $zero, .lif_1981657541_else
 # t0: 296(4): VarAssg 262 *parent_node :Tree
 move $t0, $t2
 # a0: 297(0): Call 262 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # t2: 298(6): VarAssg 297 *current_node :Tree
 move $t2, $a0
 # a0: 299(0): Goto *lif_1981657541_done :void
 j .lif_1981657541_done
 # a0: 300(0): Label *lif_1981657541_else :void
 .lif_1981657541_else:
 # a0: 301(0): Boolean *false :boolean
 move $a0, $zero
 # t4: 302(8): VarAssg 301 *cont :boolean
 move $t4, $a0
 # a0: 303(0): Label *lif_1981657541_done :void
 .lif_1981657541_done:
 # t0: 304(4): Unify 296 264 :Tree
 # t4: 305(8): Unify 266 302 :boolean
 # t2: 306(6): Unify 298 262 :Tree
 # a0: 307(0): Goto *lif_112430522_done :void
 j .lif_112430522_done
 # a1: 308(1): Label *lif_112430522_else :void
 .lif_112430522_else:
 # a0: 309(0): NBranch 270 *lif_394410264_else :void
 beq $a0, $zero, .lif_394410264_else
 # a0: 310(0): Call 262 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a1: 311(1): Not 310 :boolean
 seq $a1, $zero, $a0
 # a0: 312(0): Call 262 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $t2
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a0: 313(0): Not 312 :boolean
 seq $a0, $zero, $a0
 # a0: 314(0): And 311 313 :boolean
 and $a0, $a1, $a0
 # a0: 315(0): NBranch 314 *lif_1718772406_else :void
 beq $a0, $zero, .lif_1718772406_else
 # a0: 316(0): Boolean *true :boolean
 li $a0, 1
 # a1: 317(1): VarAssg 316 *ntb :boolean
 move $a1, $a0
 # a0: 318(0): Goto *lif_1718772406_done :void
 j .lif_1718772406_done
 # a0: 319(0): Label *lif_1718772406_else :void
 .lif_1718772406_else:
 # a2: 320(2): This :Tree
 move $a2, $v0
 # a0: 321(0): Arg 264 *0 :Tree
 move $a0, $t0
 # a1: 322(1): Arg 262 *1 :Tree
 move $a1, $t2
 # a0: 323(0): Call 320 *Remove(321, 322) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 56($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a1: 324(1): VarAssg 323 *ntb :boolean
 move $a1, $a0
 # a0: 325(0): Label *lif_1718772406_done :void
 .lif_1718772406_done:
 # a1: 326(1): Unify 317 324 :boolean
 # a0: 327(0): Goto *lif_394410264_done :void
 j .lif_394410264_done
 # a0: 328(0): Label *lif_394410264_else :void
 .lif_394410264_else:
 # a2: 329(2): This :Tree
 move $a2, $v0
 # a0: 330(0): Arg 264 *0 :Tree
 move $a0, $t0
 # a1: 331(1): Arg 262 *1 :Tree
 move $a1, $t2
 # a0: 332(0): Call 329 *Remove(330, 331) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 sw $t2, -36($fp)
 sw $t3, -40($fp)
 sw $t4, -44($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 56($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 lw $t2, -36($fp)
 lw $t3, -40($fp)
 lw $t4, -44($fp)
 # a1: 333(1): VarAssg 332 *ntb :boolean
 move $a1, $a0
 # a0: 334(0): Label *lif_394410264_done :void
 .lif_394410264_done:
 # a1: 335(1): Unify 326 333 :boolean
 # a0: 336(0): Boolean *true :boolean
 li $a0, 1
 # t3: 337(7): VarAssg 336 *found :boolean
 move $t3, $a0
 # a0: 338(0): Boolean *false :boolean
 move $a0, $zero
 # t4: 339(8): VarAssg 338 *cont :boolean
 move $t4, $a0
 # a0: 340(0): Label *lif_112430522_done :void
 .lif_112430522_done:
 # t0: 341(4): Unify 304 264 :Tree
 # a1: 342(1): Unify 258 335 :boolean
 # t4: 343(8): Unify 305 339 :boolean
 # t3: 344(7): Unify 268 337 :boolean
 # t2: 345(6): Unify 306 262 :Tree
 # a0: 346(0): Label *lif_1273655764_done :void
 .lif_1273655764_done:
 # t0: 347(4): Unify 287 341 :Tree
 # a1: 348(1): Unify 258 342 :boolean
 # t4: 349(8): Unify 288 343 :boolean
 # t2: 350(6): Unify 289 345 :Tree
 # t3: 351(7): Unify 268 344 :boolean
 # a0: 352(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 353(0): VarAssg 352 *is_root :boolean
 move $a0, $a0
 # a2: 354(2): Goto *lwhile_1689237072_start :void
 j .lwhile_1689237072_start
 # a2: 355(2): Label *lwhile_1689237072_end :void
 .lwhile_1689237072_end:
 # a0: 356(0): Unify 270 353 :boolean
 # t0: 357(4): Unify 264 347 :Tree
 # a1: 358(1): Unify 258 348 :boolean
 # t1: 359(5): Unify 260 274 :int
 # t4: 360(8): Unify 266 349 :boolean
 # t3: 361(7): Unify 268 351 :boolean
 # t2: 362(6): Unify 262 350 :Tree
 # a0: 363(0): Return 361 :void
 move $v0, $t3
 j .ret_mj__m_Tree_Delete
 .ret_mj__m_Tree_Delete:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Remove:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -32
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 364(0): Parameter *0 :Tree
 # a1: 365(1): Parameter *1 :Tree
 # t0: 366(4): VarAssg 364 *p_node :Tree
 move $t0, $a0
 # a1: 367(1): VarAssg 365 *c_node :Tree
 move $a1, $a1
 # a0: 368(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a2: 369(2): Null *Type(int) :int
 move $a2, $zero
 # a3: 370(3): Null *Type(int) :int
 move $a3, $zero
 # a0: 371(0): Call 367 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 372(0): NBranch 371 *lif_1605291845_else :void
 beq $a0, $zero, .lif_1605291845_else
 # t1: 373(5): This :Tree
 move $t1, $v0
 # a0: 374(0): Arg 366 *0 :Tree
 move $a0, $t0
 # a1: 375(1): Arg 367 *1 :Tree
 move $a1, $a1
 # a0: 376(0): Call 373 *RemoveLeft(374, 375) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t1
 lw $v1, ($v0)
 lw $v1, 64($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a1: 377(1): VarAssg 376 *ntb :boolean
 move $a1, $a0
 # a0: 378(0): Goto *lif_1605291845_done :void
 j .lif_1605291845_done
 # a0: 379(0): Label *lif_1605291845_else :void
 .lif_1605291845_else:
 # a0: 380(0): Call 367 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 381(0): NBranch 380 *lif_1302981654_else :void
 beq $a0, $zero, .lif_1302981654_else
 # t1: 382(5): This :Tree
 move $t1, $v0
 # a0: 383(0): Arg 366 *0 :Tree
 move $a0, $t0
 # a1: 384(1): Arg 367 *1 :Tree
 move $a1, $a1
 # a0: 385(0): Call 382 *RemoveRight(383, 384) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t1
 lw $v1, ($v0)
 lw $v1, 60($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a1: 386(1): VarAssg 385 *ntb :boolean
 move $a1, $a0
 # a0: 387(0): Goto *lif_1302981654_done :void
 j .lif_1302981654_done
 # a0: 388(0): Label *lif_1302981654_else :void
 .lif_1302981654_else:
 # a0: 389(0): Call 367 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a2: 390(2): VarAssg 389 *auxkey1 :int
 move $a2, $a0
 # a0: 391(0): Call 366 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t0
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 392(0): Call 391 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a0
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a3: 393(3): VarAssg 392 *auxkey2 :int
 move $a3, $a0
 # t1: 394(5): This :Tree
 move $t1, $v0
 # a0: 395(0): Arg 390 *0 :int
 move $a0, $a2
 # a1: 396(1): Arg 393 *1 :int
 move $a1, $a3
 # a0: 397(0): Call 394 *Compare(395, 396) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t1
 lw $v1, ($v0)
 lw $v1, 44($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 398(0): NBranch 397 *lif_1321910319_else :void
 beq $a0, $zero, .lif_1321910319_else
 # a0: 399(0): This :Tree
 move $a0, $v0
 # a0: 400(0): Member 399 *my_null :Tree
 lw $a0, 24($a0)
 # a0: 401(0): Arg 400 *0 :Tree
 move $a0, $a0
 # a0: 402(0): Call 366 *SetLeft(401) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t0
 lw $v1, ($v0)
 lw $v1, 8($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 403(0): VarAssg 402 *ntb :boolean
 move $a0, $a0
 # a0: 404(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 405(0): Arg 404 *0 :boolean
 move $a0, $a0
 # a0: 406(0): Call 366 *SetHas_Left(405) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t0
 lw $v1, ($v0)
 lw $v1, 36($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a1: 407(1): VarAssg 406 *ntb :boolean
 move $a1, $a0
 # a0: 408(0): Goto *lif_1321910319_done :void
 j .lif_1321910319_done
 # a0: 409(0): Label *lif_1321910319_else :void
 .lif_1321910319_else:
 # a0: 410(0): This :Tree
 move $a0, $v0
 # a0: 411(0): Member 410 *my_null :Tree
 lw $a0, 24($a0)
 # a0: 412(0): Arg 411 *0 :Tree
 move $a0, $a0
 # a0: 413(0): Call 366 *SetRight(412) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t0
 lw $v1, ($v0)
 lw $v1, 4($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 414(0): VarAssg 413 *ntb :boolean
 move $a0, $a0
 # a0: 415(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 416(0): Arg 415 *0 :boolean
 move $a0, $a0
 # a0: 417(0): Call 366 *SetHas_Right(416) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $t0
 lw $v1, ($v0)
 lw $v1, 40($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a1: 418(1): VarAssg 417 *ntb :boolean
 move $a1, $a0
 # a0: 419(0): Label *lif_1321910319_done :void
 .lif_1321910319_done:
 # a1: 420(1): Unify 407 418 :boolean
 # a0: 421(0): Label *lif_1302981654_done :void
 .lif_1302981654_done:
 # a2: 422(2): Unify 369 390 :int
 # a3: 423(3): Unify 370 393 :int
 # a1: 424(1): Unify 386 420 :boolean
 # a0: 425(0): Label *lif_1605291845_done :void
 .lif_1605291845_done:
 # a1: 426(1): Unify 377 424 :boolean
 # a2: 427(2): Unify 369 422 :int
 # a3: 428(3): Unify 370 423 :int
 # a0: 429(0): Boolean *true :boolean
 li $a0, 1
 # a0: 430(0): Return 429 :void
 move $v0, $a0
 j .ret_mj__m_Tree_Remove
 .ret_mj__m_Tree_Remove:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_RemoveRight:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -24
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 431(0): Parameter *0 :Tree
 # a1: 432(1): Parameter *1 :Tree
 # a3: 433(3): VarAssg 431 *p_node :Tree
 move $a3, $a0
 # a2: 434(2): VarAssg 432 *c_node :Tree
 move $a2, $a1
 # a0: 435(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a1: 436(1): Label *lwhile_1628403218_start :void
 .lwhile_1628403218_start:
 # a1: 437(1): Call 434 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a1, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a1: 438(1): NBranch 437 *lwhile_1628403218_end :void
 beq $a1, $zero, .lwhile_1628403218_end
 # a0: 439(0): Call 434 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 440(0): Call 439 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a0
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 441(0): Arg 440 *0 :int
 move $a0, $a0
 # a0: 442(0): Call 434 *SetKey(441) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 24($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 443(0): VarAssg 442 *ntb :boolean
 move $a0, $a0
 # a3: 444(3): VarAssg 434 *p_node :Tree
 move $a3, $a2
 # a1: 445(1): Call 434 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a1, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a2: 446(2): VarAssg 445 *c_node :Tree
 move $a2, $a1
 # a1: 447(1): Goto *lwhile_1628403218_start :void
 j .lwhile_1628403218_start
 # a1: 448(1): Label *lwhile_1628403218_end :void
 .lwhile_1628403218_end:
 # a0: 449(0): Unify 435 443 :boolean
 # a3: 450(3): Unify 433 444 :Tree
 # a2: 451(2): Unify 434 446 :Tree
 # a0: 452(0): This :Tree
 move $a0, $v0
 # a0: 453(0): Member 452 *my_null :Tree
 lw $a0, 24($a0)
 # a0: 454(0): Arg 453 *0 :Tree
 move $a0, $a0
 # a0: 455(0): Call 450 *SetRight(454) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 4($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 456(0): VarAssg 455 *ntb :boolean
 move $a0, $a0
 # a0: 457(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 458(0): Arg 457 *0 :boolean
 move $a0, $a0
 # a0: 459(0): Call 450 *SetHas_Right(458) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 40($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 460(0): VarAssg 459 *ntb :boolean
 move $a0, $a0
 # a0: 461(0): Boolean *true :boolean
 li $a0, 1
 # a0: 462(0): Return 461 :void
 move $v0, $a0
 j .ret_mj__m_Tree_RemoveRight
 .ret_mj__m_Tree_RemoveRight:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_RemoveLeft:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -24
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 463(0): Parameter *0 :Tree
 # a1: 464(1): Parameter *1 :Tree
 # a2: 465(2): VarAssg 463 *p_node :Tree
 move $a2, $a0
 # a1: 466(1): VarAssg 464 *c_node :Tree
 move $a1, $a1
 # a3: 467(3): Null *Type(boolean) :boolean
 move $a3, $zero
 # a0: 468(0): Label *lwhile_1041287558_start :void
 .lwhile_1041287558_start:
 # a0: 469(0): Call 466 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 470(0): NBranch 469 *lwhile_1041287558_end :void
 beq $a0, $zero, .lwhile_1041287558_end
 # a0: 471(0): Call 466 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 472(0): Call 471 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a0
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 473(0): Arg 472 *0 :int
 move $a0, $a0
 # a0: 474(0): Call 466 *SetKey(473) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 24($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a3: 475(3): VarAssg 474 *ntb :boolean
 move $a3, $a0
 # a2: 476(2): VarAssg 466 *p_node :Tree
 move $a2, $a1
 # a0: 477(0): Call 466 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a1: 478(1): VarAssg 477 *c_node :Tree
 move $a1, $a0
 # a0: 479(0): Goto *lwhile_1041287558_start :void
 j .lwhile_1041287558_start
 # a0: 480(0): Label *lwhile_1041287558_end :void
 .lwhile_1041287558_end:
 # a3: 481(3): Unify 467 475 :boolean
 # a2: 482(2): Unify 465 476 :Tree
 # a1: 483(1): Unify 466 478 :Tree
 # a0: 484(0): This :Tree
 move $a0, $v0
 # a0: 485(0): Member 484 *my_null :Tree
 lw $a0, 24($a0)
 # a0: 486(0): Arg 485 *0 :Tree
 move $a0, $a0
 # a0: 487(0): Call 482 *SetLeft(486) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 8($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 488(0): VarAssg 487 *ntb :boolean
 move $a0, $a0
 # a0: 489(0): Boolean *false :boolean
 move $a0, $zero
 # a0: 490(0): Arg 489 *0 :boolean
 move $a0, $a0
 # a0: 491(0): Call 482 *SetHas_Left(490) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 36($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 # a0: 492(0): VarAssg 491 *ntb :boolean
 move $a0, $a0
 # a0: 493(0): Boolean *true :boolean
 li $a0, 1
 # a0: 494(0): Return 493 :void
 move $v0, $a0
 j .ret_mj__m_Tree_RemoveLeft
 .ret_mj__m_Tree_RemoveLeft:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Search:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -32
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 495(0): Parameter *0 :int
 # a2: 496(2): VarAssg 495 *v_key :int
 move $a2, $a0
 # a0: 497(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 498(0): Null *Type(int) :int
 move $a0, $zero
 # a0: 499(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # t0: 500(4): Null *Type(int) :int
 move $t0, $zero
 # a0: 501(0): This :Tree
 move $a0, $v0
 # a3: 502(3): VarAssg 501 *current_node :Tree
 move $a3, $a0
 # a0: 503(0): Boolean *true :boolean
 li $a0, 1
 # t1: 504(5): VarAssg 503 *cont :boolean
 move $t1, $a0
 # a0: 505(0): Int *0 :int
 li $a0, 0
 # a1: 506(1): VarAssg 505 *ifound :int
 move $a1, $a0
 # a0: 507(0): Label *lwhile_1075747903_start :void
 .lwhile_1075747903_start:
 # a0: 508(0): NBranch 504 *lwhile_1075747903_end :void
 beq $t1, $zero, .lwhile_1075747903_end
 # a0: 509(0): Call 502 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # t0: 510(4): VarAssg 509 *key_aux :int
 move $t0, $a0
 # a0: 511(0): Lt 496 510 :boolean
 slt $a0, $a2, $t0
 # a0: 512(0): NBranch 511 *lif_430181628_else :void
 beq $a0, $zero, .lif_430181628_else
 # a0: 513(0): Call 502 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 514(0): NBranch 513 *lif_1632665994_else :void
 beq $a0, $zero, .lif_1632665994_else
 # a0: 515(0): Call 502 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a3: 516(3): VarAssg 515 *current_node :Tree
 move $a3, $a0
 # a0: 517(0): Goto *lif_1632665994_done :void
 j .lif_1632665994_done
 # a0: 518(0): Label *lif_1632665994_else :void
 .lif_1632665994_else:
 # a0: 519(0): Boolean *false :boolean
 move $a0, $zero
 # t1: 520(5): VarAssg 519 *cont :boolean
 move $t1, $a0
 # a0: 521(0): Label *lif_1632665994_done :void
 .lif_1632665994_done:
 # t1: 522(5): Unify 504 520 :boolean
 # a3: 523(3): Unify 516 502 :Tree
 # a0: 524(0): Goto *lif_430181628_done :void
 j .lif_430181628_done
 # a0: 525(0): Label *lif_430181628_else :void
 .lif_430181628_else:
 # a0: 526(0): Lt 510 496 :boolean
 slt $a0, $t0, $a2
 # a0: 527(0): NBranch 526 *lif_1818803439_else :void
 beq $a0, $zero, .lif_1818803439_else
 # a0: 528(0): Call 502 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a0: 529(0): NBranch 528 *lif_1347167875_else :void
 beq $a0, $zero, .lif_1347167875_else
 # a0: 530(0): Call 502 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 sw $a3, -24($fp)
 sw $t0, -28($fp)
 sw $t1, -32($fp)
 move $v0, $a3
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 lw $a3, -24($fp)
 lw $t0, -28($fp)
 lw $t1, -32($fp)
 # a3: 531(3): VarAssg 530 *current_node :Tree
 move $a3, $a0
 # a0: 532(0): Goto *lif_1347167875_done :void
 j .lif_1347167875_done
 # a0: 533(0): Label *lif_1347167875_else :void
 .lif_1347167875_else:
 # a0: 534(0): Boolean *false :boolean
 move $a0, $zero
 # t1: 535(5): VarAssg 534 *cont :boolean
 move $t1, $a0
 # a0: 536(0): Label *lif_1347167875_done :void
 .lif_1347167875_done:
 # t1: 537(5): Unify 504 535 :boolean
 # a3: 538(3): Unify 531 502 :Tree
 # a0: 539(0): Goto *lif_1818803439_done :void
 j .lif_1818803439_done
 # a0: 540(0): Label *lif_1818803439_else :void
 .lif_1818803439_else:
 # a0: 541(0): Int *1 :int
 li $a0, 1
 # a1: 542(1): VarAssg 541 *ifound :int
 move $a1, $a0
 # a0: 543(0): Boolean *false :boolean
 move $a0, $zero
 # t1: 544(5): VarAssg 543 *cont :boolean
 move $t1, $a0
 # a0: 545(0): Label *lif_1818803439_done :void
 .lif_1818803439_done:
 # t1: 546(5): Unify 537 544 :boolean
 # a1: 547(1): Unify 506 542 :int
 # a3: 548(3): Unify 538 502 :Tree
 # a0: 549(0): Label *lif_430181628_done :void
 .lif_430181628_done:
 # t1: 550(5): Unify 522 546 :boolean
 # a1: 551(1): Unify 506 547 :int
 # a3: 552(3): Unify 523 548 :Tree
 # a0: 553(0): Goto *lwhile_1075747903_start :void
 j .lwhile_1075747903_start
 # a0: 554(0): Label *lwhile_1075747903_end :void
 .lwhile_1075747903_end:
 # a1: 555(1): Unify 506 551 :int
 # t0: 556(4): Unify 500 510 :int
 # t1: 557(5): Unify 504 550 :boolean
 # a3: 558(3): Unify 502 552 :Tree
 # a0: 559(0): Return 555 :void
 move $v0, $a1
 j .ret_mj__m_Tree_Search
 .ret_mj__m_Tree_Search:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_Print:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 560(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a0: 561(0): Null *Type(Tree) :Tree
 move $a0, $zero
 # a0: 562(0): This :Tree
 move $a0, $v0
 # a0: 563(0): VarAssg 562 *current_node :Tree
 move $a0, $a0
 # a1: 564(1): This :Tree
 move $a1, $v0
 # a0: 565(0): Arg 563 *0 :Tree
 move $a0, $a0
 # a0: 566(0): Call 564 *RecPrint(565) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 76($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 # a0: 567(0): VarAssg 566 *ntb :boolean
 move $a0, $a0
 # a0: 568(0): Boolean *true :boolean
 li $a0, 1
 # a0: 569(0): Return 568 :void
 move $v0, $a0
 j .ret_mj__m_Tree_Print
 .ret_mj__m_Tree_Print:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_RecPrint:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -20
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 570(0): Parameter *0 :Tree
 # a2: 571(2): VarAssg 570 *node :Tree
 move $a2, $a0
 # a0: 572(0): Null *Type(boolean) :boolean
 move $a0, $zero
 # a0: 573(0): Call 571 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 574(0): NBranch 573 *lif_930384804_else :void
 beq $a0, $zero, .lif_930384804_else
 # a1: 575(1): This :Tree
 move $a1, $v0
 # a0: 576(0): Call 571 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 577(0): Arg 576 *0 :Tree
 move $a0, $a0
 # a0: 578(0): Call 575 *RecPrint(577) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 76($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 579(0): VarAssg 578 *ntb :boolean
 move $a0, $a0
 # a1: 580(1): Goto *lif_930384804_done :void
 j .lif_930384804_done
 # a0: 581(0): Label *lif_930384804_else :void
 .lif_930384804_else:
 # a0: 582(0): Boolean *true :boolean
 li $a0, 1
 # a0: 583(0): VarAssg 582 *ntb :boolean
 move $a0, $a0
 # a1: 584(1): Label *lif_930384804_done :void
 .lif_930384804_done:
 # a0: 585(0): Unify 579 583 :boolean
 # a0: 586(0): Call 571 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 587(0): Print 586 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 588(0): Call 571 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 589(0): NBranch 588 *lif_1148967021_else :void
 beq $a0, $zero, .lif_1148967021_else
 # a1: 590(1): This :Tree
 move $a1, $v0
 # a0: 591(0): Call 571 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 592(0): Arg 591 *0 :Tree
 move $a0, $a0
 # a0: 593(0): Call 590 *RecPrint(592) :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 76($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a1: 594(1): VarAssg 593 *ntb :boolean
 move $a1, $a0
 # a0: 595(0): Goto *lif_1148967021_done :void
 j .lif_1148967021_done
 # a0: 596(0): Label *lif_1148967021_else :void
 .lif_1148967021_else:
 # a0: 597(0): Boolean *true :boolean
 li $a0, 1
 # a1: 598(1): VarAssg 597 *ntb :boolean
 move $a1, $a0
 # a0: 599(0): Label *lif_1148967021_done :void
 .lif_1148967021_done:
 # a1: 600(1): Unify 594 598 :boolean
 # a0: 601(0): Boolean *true :boolean
 li $a0, 1
 # a0: 602(0): Return 601 :void
 move $v0, $a0
 j .ret_mj__m_Tree_RecPrint
 .ret_mj__m_Tree_RecPrint:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
mj__m_Tree_accept:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -16
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 603(0): Parameter *0 :Visitor
 # a1: 604(1): VarAssg 603 *v :Visitor
 move $a1, $a0
 # a0: 605(0): Null *Type(int) :int
 move $a0, $zero
 # a0: 606(0): Int *333 :int
 li $a0, 333
 # a0: 607(0): Print 606 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 # a0: 608(0): This :Tree
 move $a0, $v0
 # a0: 609(0): Arg 608 *0 :Tree
 move $a0, $a0
 # a0: 610(0): Call 604 *visit(609) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 0($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 # a0: 611(0): VarAssg 610 *nti :int
 move $a0, $a0
 # a0: 612(0): Int *0 :int
 li $a0, 0
 # a0: 613(0): Return 612 :void
 move $v0, $a0
 j .ret_mj__m_Tree_accept
 .ret_mj__m_Tree_accept:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
.data
.align 4
mj__v_Visitor:
 .word mj__m_Visitor_visit
.text
mj__m_Visitor_visit:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -20
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 614(0): Parameter *0 :Tree
 # a2: 615(2): VarAssg 614 *n :Tree
 move $a2, $a0
 # a0: 616(0): Null *Type(int) :int
 move $a0, $zero
 # a0: 617(0): Call 615 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 618(0): NBranch 617 *lif_1626380693_else :void
 beq $a0, $zero, .lif_1626380693_else
 # a1: 619(1): This :Visitor
 move $a1, $v0
 # a0: 620(0): Call 615 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 621(0): MemberAssg 619 620 *r :Tree
 sw $a0, 8($a1)
 move $a0, $a0
 # a0: 622(0): This :Visitor
 move $a0, $v0
 # a1: 623(1): Member 622 *r :Tree
 lw $a1, 8($a0)
 # a0: 624(0): This :Visitor
 move $a0, $v0
 # a0: 625(0): Arg 624 *0 :Visitor
 move $a0, $a0
 # a0: 626(0): Call 623 *accept(625) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 80($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 627(0): VarAssg 626 *nti :int
 move $a0, $a0
 # a1: 628(1): Goto *lif_1626380693_done :void
 j .lif_1626380693_done
 # a0: 629(0): Label *lif_1626380693_else :void
 .lif_1626380693_else:
 # a0: 630(0): Int *0 :int
 li $a0, 0
 # a0: 631(0): VarAssg 630 *nti :int
 move $a0, $a0
 # a1: 632(1): Label *lif_1626380693_done :void
 .lif_1626380693_done:
 # a0: 633(0): Unify 627 631 :int
 # a0: 634(0): Call 615 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 635(0): NBranch 634 *lif_1408448235_else :void
 beq $a0, $zero, .lif_1408448235_else
 # a1: 636(1): This :Visitor
 move $a1, $v0
 # a0: 637(0): Call 615 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 638(0): MemberAssg 636 637 *l :Tree
 sw $a0, 4($a1)
 move $a0, $a0
 # a0: 639(0): This :Visitor
 move $a0, $v0
 # a1: 640(1): Member 639 *l :Tree
 lw $a1, 4($a0)
 # a0: 641(0): This :Visitor
 move $a0, $v0
 # a0: 642(0): Arg 641 *0 :Visitor
 move $a0, $a0
 # a0: 643(0): Call 640 *accept(642) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 80($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a1: 644(1): VarAssg 643 *nti :int
 move $a1, $a0
 # a0: 645(0): Goto *lif_1408448235_done :void
 j .lif_1408448235_done
 # a0: 646(0): Label *lif_1408448235_else :void
 .lif_1408448235_else:
 # a0: 647(0): Int *0 :int
 li $a0, 0
 # a1: 648(1): VarAssg 647 *nti :int
 move $a1, $a0
 # a0: 649(0): Label *lif_1408448235_done :void
 .lif_1408448235_done:
 # a1: 650(1): Unify 644 648 :int
 # a0: 651(0): Int *0 :int
 li $a0, 0
 # a0: 652(0): Return 651 :void
 move $v0, $a0
 j .ret_mj__m_Visitor_visit
 .ret_mj__m_Visitor_visit:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra
.data
.align 4
mj__v_MyVisitor:
 .word mj__m_MyVisitor_visit
.text
mj__m_MyVisitor_visit:
 add $sp, $sp, -4
 sw $fp, ($sp)
 move $fp, $sp
 add $sp, $sp, -20
 add $sp, $sp, -4
 sw $ra, ($sp)
 # a0: 653(0): Parameter *0 :Tree
 # a2: 654(2): VarAssg 653 *n :Tree
 move $a2, $a0
 # a0: 655(0): Null *Type(int) :int
 move $a0, $zero
 # a0: 656(0): Call 654 *GetHas_Right() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 28($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 657(0): NBranch 656 *lif_77244764_else :void
 beq $a0, $zero, .lif_77244764_else
 # a1: 658(1): This :MyVisitor
 move $a1, $v0
 # a0: 659(0): Call 654 *GetRight() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 12($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 660(0): MemberAssg 658 659 *r :Tree
 sw $a0, -4($a1)
 move $a0, $a0
 # a0: 661(0): This :MyVisitor
 move $a0, $v0
 # a1: 662(1): Member 661 *r :Tree
 lw $a1, -4($a0)
 # a0: 663(0): This :MyVisitor
 move $a0, $v0
 # a0: 664(0): Arg 663 *0 :MyVisitor
 move $a0, $a0
 # a0: 665(0): Call 662 *accept(664) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 80($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a1: 666(1): VarAssg 665 *nti :int
 move $a1, $a0
 # a0: 667(0): Goto *lif_77244764_done :void
 j .lif_77244764_done
 # a0: 668(0): Label *lif_77244764_else :void
 .lif_77244764_else:
 # a0: 669(0): Int *0 :int
 li $a0, 0
 # a1: 670(1): VarAssg 669 *nti :int
 move $a1, $a0
 # a0: 671(0): Label *lif_77244764_done :void
 .lif_77244764_done:
 # a1: 672(1): Unify 666 670 :int
 # a0: 673(0): Call 654 *GetKey() :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 20($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 674(0): Print 673 :void
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a0, -12($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $a0, $a0
 jal minijavaPrint
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a0, -12($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 675(0): Call 654 *GetHas_Left() :boolean
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 32($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 676(0): NBranch 675 *lif_1172625760_else :void
 beq $a0, $zero, .lif_1172625760_else
 # a1: 677(1): This :MyVisitor
 move $a1, $v0
 # a0: 678(0): Call 654 *GetLeft() :Tree
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a2
 lw $v1, ($v0)
 lw $v1, 16($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 679(0): MemberAssg 677 678 *l :Tree
 sw $a0, -4($a1)
 move $a0, $a0
 # a0: 680(0): This :MyVisitor
 move $a0, $v0
 # a1: 681(1): Member 680 *l :Tree
 lw $a1, -4($a0)
 # a0: 682(0): This :MyVisitor
 move $a0, $v0
 # a0: 683(0): Arg 682 *0 :MyVisitor
 move $a0, $a0
 # a0: 684(0): Call 681 *accept(683) :int
 sw $v0, -4($fp)
 sw $v1, -8($fp)
 sw $a1, -16($fp)
 sw $a2, -20($fp)
 move $v0, $a1
 lw $v1, ($v0)
 lw $v1, 80($v1)
 jal $v1
 move $a0, $v0
 lw $v0, -4($fp)
 lw $v1, -8($fp)
 lw $a1, -16($fp)
 lw $a2, -20($fp)
 # a0: 685(0): VarAssg 684 *nti :int
 move $a0, $a0
 # a1: 686(1): Goto *lif_1172625760_done :void
 j .lif_1172625760_done
 # a0: 687(0): Label *lif_1172625760_else :void
 .lif_1172625760_else:
 # a0: 688(0): Int *0 :int
 li $a0, 0
 # a0: 689(0): VarAssg 688 *nti :int
 move $a0, $a0
 # a1: 690(1): Label *lif_1172625760_done :void
 .lif_1172625760_done:
 # a0: 691(0): Unify 685 689 :int
 # a0: 692(0): Int *0 :int
 li $a0, 0
 # a0: 693(0): Return 692 :void
 move $v0, $a0
 j .ret_mj__m_MyVisitor_visit
 .ret_mj__m_MyVisitor_visit:
 lw $ra, ($sp)
 add $sp, $sp, 4
 move $sp, $fp
 lw $fp, ($sp)
 add $sp, $sp, 4
 j $ra

