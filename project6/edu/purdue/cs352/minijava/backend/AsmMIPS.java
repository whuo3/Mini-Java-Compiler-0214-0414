package edu.purdue.cs352.minijava.backend;

import java.util.*;

import edu.purdue.cs352.minijava.ssa.*;
import edu.purdue.cs352.minijava.types.*;

public class AsmMIPS {
    StringBuilder sb;

    int wordSize = 4;

    boolean[] cur_regTab;

    int cur_spillSpacd;

    // registers for MIPS:
    private static final String[] registers = {
        "zero",
        "at",
        "v0", "v1",
        "a0", "a1", "a2", "a3",
        "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
        "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
        "t8", "t9",
        "k0", "k1",
        "gp", "sp", "fp", "ra"
    };

    // registers free for normal use
    private static final int[] freeRegisters = {
        4, 5, 6, 7, // a*
        8, 9, 10, 11, 12, 13, 14, 15, // t*
        16, 17, 18, 19, 20, 21, 22, 23, // s*
        24, 25 // t*
    };

    // pinned registers for arguments:
    private static final int[] argRegisters = {
        4, 5, 6, 7
    };

    // mapping of arg register indexes to free register indexes
    private static final int[] argFreeRegisters = {
        0, 1, 2, 3
    };

    // callee-saved registers, excluding stack/base
    private static final int[] calleeSavedRegisters = {
        16, 17, 18, 19, 20, 21, 22, 23, // s*
        28, // gp
        31, // ra
    };

    // caller-saved registers, excluding stack/base
    private static final int[] callerSavedRegisters = {
        2, 3, // v*
        4, 5, 6, 7, // a*
        8, 9, 10, 11, 12, 13, 14, 15, 24, 25 // t*
    };

    private AsmMIPS(StringBuilder sb) {
        this.sb = sb;
    }

    public static String compile(SSAProgram prog) {
        AsmMIPS compiler = new AsmMIPS(new StringBuilder());

        // SPIM stuff
        compiler.sb.append(
            "main:\n" +
            " jal mj_main\n" +
            " li $v0, 10\n" +
            " syscall\n\n" +

            "minijavaNew:\n" +
            " move $t0, $a0\n" +
            " mul $a0, $a1, 4\n" +
            " li $v0, 9\n" +
            " syscall\n" +
            " sw $t0, ($v0)\n" +
            " j $ra\n\n" +

            "minijavaNewArray:\n" +
            " move $t0, $a0\n" +
            " mul $a0, $a0, 4\n" +
            " add $a0, $a0, 4\n" +
            " li $v0, 9\n" +
            " syscall\n" +
            " sw $t0, ($v0)\n" +
            " j $ra\n\n" +

            ".data\n" +
            ".align 4\n" +
            "minijavaNewline:\n" +
            " .asciiz \"\\n\"\n\n" +

            ".text\n" +
            "minijavaPrint:\n" +
            " li $v0, 1\n" +
            " syscall\n" +
            " la $a0, minijavaNewline\n" +
            " li $v0, 4\n" +
            " syscall\n" +
            " j $ra\n\n"
        ); 

        // first compile main
        compiler.compile(prog, prog.getMain(), "mj_main");

        // then compile all the classes
        for (SSAClass cl : prog.getClassesOrdered()) {
            compiler.compile(prog, cl);
        }

        return compiler.toString();
    }

    // compile this class
    private void compile(SSAProgram prog, SSAClass cl) {
        // first make the vtable for this class
        sb.append(".data\n.align ");
        sb.append(wordSize);
        sb.append("\n");
        sb.append("mj__v_" + cl.getASTNode().getName() + ":\n");

        //The vtable (virtual table) is a pointer to a static array (see line 122 of the template). 
        //That array contains pointers to each of the methods in the class, in the order they appear.
        ClassLayout.Vtable vTab = ClassLayout.getVtable(prog, cl);
        
        for(String mth : vTab.methods){
            sb.append(" .word mj__m_");
            sb.append(cl.getMethodProvider(prog, mth).getASTNode().getName());
            sb.append("_");
            sb.append(mth);
            sb.append("\n");
        }

        // now compile the actual methods
        sb.append(".text\n");
        for (SSAMethod m : cl.getMethodsOrdered()) {
            String name = "mj__m_" + cl.getASTNode().getName() + "_" + m.getMethod().getName();
            compile(prog, m, name);
        }
    }

    // compile this method with this name
    private void compile(SSAProgram prog, SSAMethod m, String name) {
        // beginning of the prologue
        sb.append(name);
        sb.append(":\n");
        sb.append(" add $sp, $sp, -");
        sb.append(wordSize);
        sb.append("\n");
        sb.append(" sw $fp, ($sp)\n");//Save old fp
        sb.append(" move $fp, $sp\n");//move current address to $fp(new frame pointer)

        // pin registers
        for (SSAStatement s : m.getBody()) {
            if (s.getOp() == SSAStatement.Op.Parameter) {
                int paramNum = ((Integer) s.getSpecial()).intValue();
                if (paramNum < argRegisters.length)
                    s.pinRegister(argFreeRegisters[paramNum]);
            }

            if (s.getOp() == SSAStatement.Op.Arg) {
                int argNum = ((Integer) s.getSpecial()).intValue();
                if (argNum < argRegisters.length)
                    s.pinRegister(argFreeRegisters[argNum]);
                else
                    s.pinRegister(-1); // pin to -1 to do this at Call time
            }
        }

        // perform register allocation
        RegisterAllocator.alloc(m, freeRegisters.length);

        boolean[] regTab = new boolean[registers.length];

        for(int i = 0; i < freeRegisters.length; i++){
            regTab[i] = false;
        }

        /*Set 
            *return Address $ra
            *$v0 - $v1(Note: Not Necessary return value, v0 may stores the address of newly created memory space for dynamic memory)
          in RegTab
        */
        regTab[2] = true;
        regTab[3] = true;
        regTab[31] = true;

        //figure out how much space we need to reserve for spills
        //Note: Register stored in SSAStatement is the location of freeRegister.
        for(SSAStatement ssastmt : m.getBody()){
            if(ssastmt.getRegister() >= 0)
                regTab[freeRegisters[ssastmt.getRegister()]] = true;
        }

        int spillSpace = 0;
        for(SSAStatement ssastmt : m.getBody()){
            if(ssastmt.getOp() == SSAStatement.Op.Load || ssastmt.getOp() == SSAStatement.Op.Store){
                if(((int)(ssastmt.getSpecial())) + 1 > spillSpace){
                    spillSpace = (int)(ssastmt.getSpecial()) + 1;
                }
            }
        }

        //other space we need to reserve (caller saved registers)
        int callerSavedReg = 0;
        for(int i = 0; i < callerSavedRegisters.length; i++){
            if(regTab[callerSavedRegisters[i]])
                callerSavedReg++;
        }

        //reserve space
        sb.append(" add $sp, $sp, -");
        sb.append(wordSize*(spillSpace + callerSavedReg));
        sb.append("\n");

        //the callee-saved registers, anything else that needs to be saved
        for(int i = 0; i < calleeSavedRegisters.length; i++){
            if(regTab[calleeSavedRegisters[i]]){
                sb.append(" add $sp, $sp, -");
                sb.append(this.wordSize);
                sb.append("\n");
                sb.append(" sw $");
                sb.append(registers[calleeSavedRegisters[i]]);
                sb.append(", ($sp)\n");
            }
        }

        //Unpinned Arg
        int argNum = 0;
        //Count how many unpinned registers
        for(SSAStatement ssastmt : m.getBody()){
            if(ssastmt.getOp() == SSAStatement.Op.Arg){
                int cur = (int)(ssastmt.getSpecial()) + 1 - argRegisters.length;
                if(cur > argNum)
                    argNum = cur;
            }
        }

        if(argNum > 0){
            sb.append(" add $sp, $sp, -");
            sb.append(wordSize * argNum);
            sb.append("\n");
        }

        //Refresh the current register Taber, as well as spillSpace
        cur_regTab = regTab;
        cur_spillSpacd = spillSpace;

        // now write the code
        for (SSAStatement s : m.getBody()) {
            compile(prog, name, s);
        }

        // the epilogue starts here
        sb.append(" .ret_");
        sb.append(name);
        sb.append(":\n");

        if(argNum > 0){
            sb.append(" add $sp, $sp, ");
            sb.append(wordSize * argNum);
            sb.append("\n");
        }

        // FILLIN: restore the callee-saved registers 
        // Because of the lay out of the stack pointer have to start from the end to the start
        for(int i = calleeSavedRegisters.length - 1; i >= 0; i--){
            if(regTab[calleeSavedRegisters[i]]){
                sb.append(" lw $");
                sb.append(registers[calleeSavedRegisters[i]]);
                sb.append(", ($sp)\n");
                sb.append(" add $sp, $sp, ");
                sb.append(this.wordSize);
                sb.append("\n");
            }
        }


        // and the rest of the epilogue
        sb.append(" move $sp, $fp\n");
        sb.append(" lw $fp, ($sp)\n");
        sb.append(" add $sp, $sp, ");
        sb.append(wordSize);
        sb.append("\n");
        sb.append(" j $ra\n");
    }

    // compile this statement (FILLIN: might need more registers, coming from above method)
    private void compile(SSAProgram prog, String methodName, SSAStatement s) {
        // recommended for debuggability:
        sb.append(" # ");
        if (s.getRegister() >= 0)
            sb.append(reg(s));
        sb.append(": ");
        sb.append(s.toString());
        sb.append("\n");

        ClassLayout.Vtable vTabtemp;

        switch (s.getOp()) {
            // Meta:
            case Unify:
            case Alias:
                break;

            // Data:
            case This:
                sb.append(" move $");
                sb.append(reg(s));
                sb.append(", $v0\n");
                break;
            case Parameter:
                //the parameter are stored before the fame pointer
                //For thoes registers which are already have been pinned, they are already
                //assigned to the register location in Arg SSAStatement in caller
                if(((int)(s.getSpecial()) + 1) > argRegisters.length){
                    sb.append(" lw $");
                    sb.append(reg(s));
                    sb.append(", ");
                    sb.append(wordSize * ((int)(s.getSpecial()) + 1 - argRegisters.length));
                    sb.append("($fp)\n"); 
                }
                break;
            case Arg:
                if(s.getRegister() >= 0){
                    //In this case the Arg is already pinned.
                    sb.append(" move $");
                    sb.append(registers[freeRegisters[s.getRegister()]]);
                    sb.append(", $");
                    sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                    sb.append("\n");
                }
                else{
                    //Note that this Arg value is saved in the Arg space which is reserved above.
                    sb.append(" sw $");
                    sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                    sb.append(", ");
                    sb.append(wordSize * ((int)s.getSpecial() + 1 - argRegisters.length - 1));
                    sb.append("($sp)\n");
                }
                break;
            case Null:
                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[0]);
                sb.append("\n");
                break;
            case Int:
                sb.append(" li $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", ");
                sb.append((int)(s.getSpecial()));
                sb.append("\n");
                break;
            case Boolean:
                //True: 1, False, null
                if (((Boolean)s.getSpecial())) {
                    sb.append(" li $");
                    sb.append(registers[freeRegisters[s.getRegister()]]);
                    sb.append(", 1\n");
                }
                else{
                    sb.append(" move $");
                    sb.append(registers[freeRegisters[s.getRegister()]]);
                    sb.append(", $");
                    sb.append(registers[0]);
                    sb.append("\n");
                }
                break;
            case NewObj:
                /*
                    *Caller saved register.
                    *Jump to minijavaNew
                        "minijavaNew:\n" +
                            " move $t0, $a0\n" +
                            " mul $a0, $a1, 4\n" +
                            " li $v0, 9\n" +
                            " syscall\n" +
                                //Note, this call sbrk.
                                The sbrk service returns the address to a block of memory containing n additional bytes. 
                                This would be used for dynamic memory allocation.
                            " sw $t0, ($v0)\n" +
                            " j $ra\n\n" +
                    *Caller restore register
                */

                callerSave(s);

                //Size need to allocated assigned to a0
                sb.append(" la $a0, mj__v_");
                sb.append((String)(s.getSpecial()));
                sb.append("\n");
                sb.append(" li $a1, "); //a1 fill the necessary size for the Class
                sb.append(ClassLayout.objectSize(prog, prog.getClass((String)(s.getSpecial()))));
                sb.append("\n");

                sb.append(" jal minijavaNew\n");

                //Use the current register for ssastatement to store the address of newly allocated memory for new Object
                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $v0");
                sb.append("\n");

                callerRestore(s);
                break;
            case NewIntArray:
                /*
                    *Caller saved register
                    *jal minijavaNewArray
                        *   "minijavaNewArray:\n" +
                            " move $t0, $a0\n" +
                            " mul $a0, $a0, 4\n" +
                            " add $a0, $a0, 4\n" +
                            " li $v0, 9\n" +
                            " syscall\n" +
                            " sw $t0, ($v0)\n" +
                            " j $ra\n\n" +
                    *Caller restore register
                */
                callerSave(s);

                //Size need to allocated assigned to a0
                sb.append(" move $a0, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");

                sb.append(" jal minijavaNewArray\n");

                //Use the current register for ssastatement to store the address of newly allocated memory for new Object
                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $v0");
                sb.append("\n");

                callerRestore(s);
                break;

            // Control flow:
            case Label:
                sb.append(" .");
                sb.append((String)s.getSpecial());
                sb.append(":\n");
                break;
            case Goto:
                sb.append(" j .");
                sb.append((String)s.getSpecial());
                sb.append("\n");
                break;
            case Branch:
                sb.append(" bne $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $zero, .");
                sb.append((String)s.getSpecial());
                sb.append("\n");
                break;
            case NBranch:
                sb.append(" beq $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $zero, .");
                sb.append((String)s.getSpecial());
                sb.append("\n");
                break;

            // Calls:
            case Call:
                //Get the class name SSAStatement for Call: left is target(most likely this) and the type is the name of the class
                /*
                    *The method name is stored right after the class name
                    *v0 always 
                */

                vTabtemp = ClassLayout.getVtable(prog, prog.getClass(/*Class Name*/s.getLeft().getType().toString()));
                callerSave(s);

                //Move the Class that the target function belongs to to register v0
                sb.append(" move $v0, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");

                //Load the name of the calling function to v1.
                sb.append(" lw $v1, ($v0)\n");
                //Acess the name of the method from an array of String(v1 store the address)
                sb.append(" lw $v1, ");
                sb.append(wordSize * (vTabtemp.methodOffsets.get( /*Method Name*/((SSACall)s.getSpecial()).getMethod() )));
                sb.append("($v1)\n");

                sb.append(" jal $v1\n");

                //Save the return value
                this.sb.append(" move $");
                this.sb.append(registers[freeRegisters[s.getRegister()]]);
                this.sb.append(", $v0\n");

                callerRestore(s);
                break;
            case Print:
                callerSave(s);

                //Save printing value to register $a0
                sb.append(" move $");
                sb.append(registers[argRegisters[0]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");

                sb.append(" jal minijavaPrint\n");

                callerRestore(s);
                break;
            case Return:
                sb.append(" move $v0, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");
                
                sb.append(" j .ret_");
                sb.append(methodName);
                sb.append("\n");                
                break;

            // Member access:
            case Member:
                if(((String)s.getSpecial()).equals("length") && s.getLeft().getType().toString().equals("int[]")){
                    sb.append(" lw $");
                    sb.append(registers[freeRegisters[s.getRegister()]]);
                    sb.append(", ($");
                    sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                    sb.append(")\n");
                }
                else{
                    sb.append(" lw $");
                    sb.append(registers[freeRegisters[s.getRegister()]]);
                    sb.append(", ");
                    sb.append(wordSize * /*Field Offset*/ClassLayout.fieldOffset(prog, prog.getClass(s.getLeft().getType().toString()), (String)s.getSpecial()));
                    sb.append("($");
                    sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                    sb.append(")\n");
                }
                break;
            case Index:
                sb.append(" mul $v1, $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append(", ");
                sb.append(wordSize);
                sb.append("\n");

                sb.append(" add $v1, $v1, ");
                sb.append(wordSize);
                sb.append("\n");

                sb.append(" add $v1, $v1, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");

                sb.append(" lw $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", ($v1)\n");
                break;

            // Stack:
            case Store://This is the place where spilled node is saved in spilledspace of memory
                sb.append(" sw $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", -");
                sb.append(wordSize * ((int)s.getSpecial() + 1));
                sb.append("($fp)\n");
                break;
            case Load:
                sb.append(" lw $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", -");
                sb.append(wordSize * ((int)s.getSpecial() + 1));
                sb.append("($fp)\n");
                break;

            // Assignments:
            case VarAssg:
                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");
                break;
            case MemberAssg:
                sb.append(" sw $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append(", ");
                sb.append(wordSize * ClassLayout.fieldOffset(prog, prog.getClass(s.getLeft().getType().toString()), (String)s.getSpecial()));
                sb.append("($");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(")\n");

                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case IndexAssg:
                sb.append(" mul $v1, $");
                sb.append(registers[freeRegisters[((SSAStatement)(s.getSpecial())).getRegister()]]);
                sb.append(", ");
                sb.append(this.wordSize);
                sb.append("\n");

                sb.append(" add $v1, $v1, ");
                sb.append(wordSize);
                sb.append("\n");

                sb.append(" add $v1, $v1, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");

                sb.append(" sw $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append(", ($v1)\n");

                sb.append(" move $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;

            // Unary operator (left = operand):
            case Not:
                sb.append(" seq $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $zero, $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append("\n");
                break;

            // Binary operators (left, right = operands):
            case Lt:
                sb.append(" slt");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Le:
                sb.append(" sle");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Eq:
                sb.append(" seq");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Ne:
                sb.append(" sne");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Gt:
                sb.append(" sgt");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Ge:
                sb.append(" sge");
                sb.append(" $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case And:
                sb.append(" and $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Or:
                sb.append(" or $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;    
            case Plus:
                sb.append(" add $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Minus:
                sb.append(" sub $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Mul:
                sb.append(" mul $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                break;
            case Div:
                //Check division by 0
                sb.append(" bne $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append(", $zero, 2\n");
                sb.append(" break $0\n");

                sb.append(" div $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                sb.append(" mflo $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append("\n");
                break;
            case Mod:
                sb.append(" div $");
                sb.append(registers[freeRegisters[s.getLeft().getRegister()]]);
                sb.append(", $");
                sb.append(registers[freeRegisters[s.getRight().getRegister()]]);
                sb.append("\n");
                sb.append(" mfhi $");
                sb.append(registers[freeRegisters[s.getRegister()]]);
                sb.append("\n");
                break;
            default:
                throw new Error("Implement MIPS compiler for " + s.getOp() + "!");
        }
    }

    // get the actual code generated
    public String toString() {
        return sb.toString();
    }

    private String reg(SSAStatement s) {
        return registers[freeRegisters[s.getRegister()]];
    }

    private void callerSave(SSAStatement s){
        for(int i = 0; i < callerSavedRegisters.length; i++){
            //In order to change the register which correspond to the current SSAStatement, avoid to save the cur register
            if((callerSavedRegisters[i] != freeRegisters[s.getRegister()] || s.getOp() == SSAStatement.Op.Print) && cur_regTab[callerSavedRegisters[i]]){
                sb.append(" sw $");
                sb.append(registers[callerSavedRegisters[i]]);
                sb.append(", -");
                sb.append(wordSize * (cur_spillSpacd + i + 1));
                sb.append("($fp)\n");
            }
        }
    }

    private void callerRestore(SSAStatement s){
        //In order to change the register which correspond to the current SSAStatement, avoid to load the cur register
        for(int i = 0; i < callerSavedRegisters.length; i++){
            if((callerSavedRegisters[i] != freeRegisters[s.getRegister()] || s.getOp() == SSAStatement.Op.Print) && cur_regTab[callerSavedRegisters[i]]){
                sb.append(" lw $");
                sb.append(registers[callerSavedRegisters[i]]);
                sb.append(", -");
                sb.append(wordSize * (cur_spillSpacd + i + 1));
                sb.append("($fp)\n");
            }
        }
    }
}
