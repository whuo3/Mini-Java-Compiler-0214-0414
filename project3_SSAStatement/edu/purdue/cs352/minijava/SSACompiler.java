package edu.purdue.cs352.minijava;

import java.util.*;

import edu.purdue.cs352.minijava.ast.*;
import edu.purdue.cs352.minijava.ssa.*;

public class SSACompiler extends ASTVisitor.SimpleASTVisitor {
    // The method body currently being compiled
    List<SSAStatement> body = new ArrayList<SSAStatement>();

    // Create a field for local variables (symbol table)
    HashMap<String, SSAStatement> symboltab = new HashMap<String, SSAStatement>();

    public static SSAProgram compile(Program prog) {
        SSAMethod main = compile(prog.getMain());
        List<SSAClass> classes = new ArrayList<SSAClass>();

        for (ClassDecl cl : prog.getClasses())
            classes.add(compile(cl));

        return new SSAProgram(main, classes);
    }

    public static SSAClass compile(ClassDecl cl) {
        List<SSAMethod> methods = new ArrayList<SSAMethod>();
        for (MethodDecl md : cl.getMethods())
            methods.add(compile(md));
        return new SSAClass(cl, methods);
    }

    public static SSAMethod compile(Main main) {
        SSACompiler compiler = new SSACompiler();

        // there's only a body
        main.getBody().accept(compiler);

        return new SSAMethod(main, compiler.getBody());
    }

    public static SSAMethod compile(MethodDecl method) {
        SSACompiler compiler = new SSACompiler();
        SSAStatement temp;
        int index = 0;
        // visit the parameters
        for (Parameter pr : method.getParameters()){
            compiler.getBody().add((temp = new SSAStatement(pr, SSAStatement.Op.Parameter, index++)));
            compiler.getBody().add((temp = new SSAStatement(pr, SSAStatement.Op.VarAssg, temp, null, pr.getName())));
            compiler.symboltab.put(pr.getName(), temp);
        }

        // and the variable declarations
        for (VarDecl vl : method.getVarDecls())
            vl.accept(compiler);

        // then compile the body
        for (Statement st : method.getBody())
            st.accept(compiler);

        // and the return
        compiler.compileReturn(method.getRetExp());

        return new SSAMethod(method, compiler.getBody());
    }

    @Override public Object defaultVisit(ASTNode node) {
        throw new Error("Unsupported visitor in SSACompiler: " + node.getClass().getSimpleName());
    }

    

    //**************************************************************Statement***********************************************************************
    @Override public Object visit(ExpStatement node) {
        node.getExp().accept(this);
        return null;
    }

    @Override public Object visit(BlockStatement node) {
        List<Statement> listSt = node.getBody();
        for(Statement st : listSt){
            st.accept(this);
        }
        return null;
    }
    @Override public Object visit(PrintStatement node) {
        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Print, (SSAStatement)node.getValue().accept(this), null, null));
        return null;
    }


    @Override public Object visit(IfStatement node) {
        HashMap<String, SSAStatement> originTab = this.symboltab, ifTab, elseTab;

        SSAStatement ifcond = (SSAStatement)node.getCondition().accept(this);
        this.getBody().add(new SSAStatement(node, SSAStatement.Op.NBranch, ifcond, null, "lif_" + node.hashCode() + "_else"));
        
        this.symboltab = (HashMap)originTab.clone();
        node.getIfPart().accept(this);
        ifTab = this.symboltab;

        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Goto, "lif_" + node.hashCode() + "_done"));
        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Label, "lif_" + node.hashCode() + "_else"));

        this.symboltab = (HashMap)originTab.clone();
        if(node.getElsePart() != null)
            node.getElsePart().accept(this);
        elseTab = this.symboltab;

        this.symboltab = originTab;

        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Label, "lif_" + node.hashCode() + "_done"));
        
        for(String key : this.symboltab.keySet()){
            if(ifTab.get(key) != elseTab.get(key)){
                this.symboltab.put(key, new SSAStatement(node, SSAStatement.Op.Unify, ifTab.get(key), elseTab.get(key)));
                this.getBody().add(this.symboltab.get(key));
            }
            else{
                //ifTab.get(key) == elseTab.get(key), add either one of them...
                this.symboltab.put(key, ifTab.get(key));
            }
        }

        return null;
    }

    @Override public Object visit(WhileStatement node) { 
        HashMap<String, SSAStatement> originTab = this.symboltab, whileTab = (HashMap)originTab.clone();

        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Label, "lwhile_" + node.hashCode() + "_start"));

        SSAStatement whileCond = (SSAStatement)node.getCondition().accept(this);

        this.getBody().add(new SSAStatement(node, SSAStatement.Op.NBranch, whileCond, null, "lwhile_" + node.hashCode() + "_end"));

        this.symboltab = whileTab;
        node.getBody().accept(this);
        whileTab = this.symboltab;
        this.symboltab = originTab;

        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Goto, "lwhile_" + node.hashCode() + "_start"));
        this.getBody().add(new SSAStatement(node, SSAStatement.Op.Label, "lwhile_" + node.hashCode() + "_end"));

        for(String key : this.symboltab.keySet()){
            if(this.symboltab.get(key) != whileTab.get(key)){
                this.symboltab.put(key, new SSAStatement(node, SSAStatement.Op.Unify, this.symboltab.get(key), whileTab.get(key)));
                this.getBody().add(this.symboltab.get(key));
            }
        }

        return null;
    }


    //******************************************************************Expression*****************************************************************

    
    @Override public Object visit(AssignExp exp) {
        // what sort of statement we make, if any, depends on the LHS
        Exp target = exp.getTarget();
        SSAStatement ret, temp;

        if (target instanceof VarExp) {
            //For variable assignment, if it is in the table, that means it has been initiallize... otherwise it is member assignment or illegel(I believe it's not the part of this lab)
            if(this.symboltab.containsKey(((VarExp)target).getName())){
                this.getBody().add((temp = new SSAStatement(exp, SSAStatement.Op.VarAssg, (ret = (SSAStatement)exp.getValue().accept(this)), null, ((VarExp)target).getName())));
                this.symboltab.put(((VarExp)target).getName(), temp);
            }
            else{
                SSAStatement This;
                this.getBody().add((This = new SSAStatement(target, SSAStatement.Op.This)));
                this.getBody().add((temp = new SSAStatement(exp, SSAStatement.Op.MemberAssg, This ,(ret = (SSAStatement)exp.getValue().accept(this)), ((VarExp)target).getName())));
            }

        } else if (target instanceof MemberExp) {
            
            this.getBody().add(new SSAStatement(exp, SSAStatement.Op.MemberAssg, (SSAStatement)((MemberExp)target).getSub().accept(this), (ret = (SSAStatement)exp.getValue().accept(this)), ((MemberExp)target).getMember()));
        
        } else if (target instanceof IndexExp) {
            
            this.getBody().add(new SSAStatement(exp, SSAStatement.Op.IndexAssg, (SSAStatement)((IndexExp)target).getTarget().accept(this), (ret = (SSAStatement)exp.getValue().accept(this)), (SSAStatement)((IndexExp)target).getIndex().accept(this)));

        } else {
            throw new Error("Invalid LHS: " + target.getClass().getSimpleName());

        }

        return ret;
    }
    @Override public Object visit(IndexExp node) {
        SSAStatement index = new SSAStatement(node, SSAStatement.Op.Index, (SSAStatement)node.getTarget().accept(this), (SSAStatement)node.getIndex().accept(this));
        this.getBody().add(index);
        return index;
    }
    @Override public Object visit(IntLiteralExp node) {
        SSAStatement intliteral = new SSAStatement(node, SSAStatement.Op.Int, node.getValue());
        this.getBody().add(intliteral);
        return intliteral;
    }
    @Override public Object visit(BinaryExp node) {
        SSAStatement.Op op;
        SSAStatement binary;
        switch(node.getOp().toString()){
            case "<":
                op = SSAStatement.Op.Lt;
                break;
            case "<=":
                op = SSAStatement.Op.Le;
                break;
            case "==":
                op = SSAStatement.Op.Eq;
                break;
            case "!=":
                op = SSAStatement.Op.Ne;
                break;
            case ">":
                op = SSAStatement.Op.Gt;
                break;
            case ">=":
                op = SSAStatement.Op.Ge;
                break;
            case "&&":
                op = SSAStatement.Op.And;
                break;
            case "||":
                op = SSAStatement.Op.Or;
                break;
            case "+":
                op = SSAStatement.Op.Plus;
                break;
            case "-":
                op = SSAStatement.Op.Minus;
                break;
            case "*":
                op = SSAStatement.Op.Mul;
                break;
            case "/":
                op = SSAStatement.Op.Div;
                break;
            case "%":
                op = SSAStatement.Op.Mod;
                break;
            default:
                throw new Error("Wrong binary "+node.getOp().toString()+".....");
        }
        binary = new SSAStatement(node, op, (SSAStatement)node.getLeft().accept(this), (SSAStatement)node.getRight().accept(this));
        this.getBody().add(binary);
        return binary;
    }
    @Override public Object visit(BooleanLiteralExp node) {
        SSAStatement booleanliteral = new SSAStatement(node, SSAStatement.Op.Boolean, node.getValue());
        this.getBody().add(booleanliteral);
        return booleanliteral;
    }
    @Override public Object visit(CallExp node) {
        List<SSAStatement> paraList = new ArrayList<SSAStatement>();
        for(Exp ep : node.getArguments()){
            SSAStatement exp = (SSAStatement)ep.accept(this);
            SSAStatement para = new SSAStatement(exp.getASTNode(), SSAStatement.Op.Arg, exp, null, paraList.size());
            this.getBody().add(para);
            paraList.add(para);
        }
        SSAStatement call = new SSAStatement(node, SSAStatement.Op.Call, (SSAStatement)node.getTarget().accept(this), null, new SSACall(node.getMethod(), paraList));
        this.getBody().add(call);
        return call;
    }
    @Override public Object visit(MemberExp node) {
        SSAStatement member = new SSAStatement(node, SSAStatement.Op.Member, (SSAStatement)node.getSub().accept(this), null, node.getMember());
        this.getBody().add(member);
        return member;
    }
    @Override public Object visit(NewIntArrayExp node) {
        SSAStatement newintarray = new SSAStatement(node, SSAStatement.Op.NewIntArray, (SSAStatement)node.getSize().accept(this), null);
        this.getBody().add(newintarray);
        return newintarray;
    }
    @Override public Object visit(NewObjectExp node) {
        SSAStatement newobjectexp = new SSAStatement(node, SSAStatement.Op.NewObj, node.getName());
        this.getBody().add(newobjectexp);
        return newobjectexp;
    }
    @Override public Object visit(NotExp node) {
        SSAStatement not = new SSAStatement(node, SSAStatement.Op.Not, (SSAStatement)node.getSub().accept(this), null);
        this.getBody().add(not);
        return not;
    }
    @Override public Object visit(ThisExp node) {
        SSAStatement This = new SSAStatement(node, SSAStatement.Op.This);
        this.getBody().add(This);
        return This;
    }
    @Override public Object visit(VarExp node) { 
        SSAStatement var, This;
        if (this.symboltab.containsKey(node.getName())) {
            return this.symboltab.get(node.getName());
        }
        This = new SSAStatement(node, SSAStatement.Op.This);
        this.getBody().add(This);
        var = new SSAStatement(node, SSAStatement.Op.Member, This, null, node.getName());
        this.getBody().add(var);
        //No need to add to symboltab because it will be done in vardecl globally...
        return var;
    }


    //***************************************************************Decaration***************************************************************************


    @Override public Object visit(VarDecl vl) {
        SSAStatement var;
        this.getBody().add((var = new SSAStatement(vl, SSAStatement.Op.Null, vl.getType())));
        this.symboltab.put(vl.getName(), var);
        return var; 
    }


    //*************************************************************Type**********************************************************************************

    /*@Override public Object visit(TypeBoolean node) { 
        SSAStatement typeBoo;
    }
    @Override public Object visit(TypeIntArray node) { 
        return defaultVisit(node); 
    }
    @Override public Object visit(TypeInt node) { 
        return defaultVisit(node); 
    }
    @Override public Object visit(Type node) { 
        return defaultVisit(node); 
    }*/

    //************************************************************Others*********************************************************************************

    /*@Override public Object visit(ASTNode node) {
        return defaultVisit(node); 
    }
    @Override public Object visit(Parameter node) {
        return defaultVisit(node); 
    }
    @Override public Object visit(Program node) {
        return defaultVisit(node); 
    }*/



    public void compileReturn(Exp retExp) {
        SSAStatement ret;
        ret = new SSAStatement(retExp, SSAStatement.Op.Return, (SSAStatement)retExp.accept(this), null);
        this.getBody().add(ret);
    }

    public List<SSAStatement> getBody() { return body; }
}
