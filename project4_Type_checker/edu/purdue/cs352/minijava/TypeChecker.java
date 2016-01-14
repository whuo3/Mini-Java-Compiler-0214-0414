package edu.purdue.cs352.minijava;

import java.util.*;

import edu.purdue.cs352.minijava.ast.*;
import edu.purdue.cs352.minijava.ssa.*;
import edu.purdue.cs352.minijava.types.*;

public class TypeChecker {
    SSAProgram prog;
    Map<String, StaticType> types;

    public TypeChecker(SSAProgram prog) {
        this.prog = prog;
        types = new HashMap<String, StaticType>();
        types.put("Object", new ObjectType("Object", null));
    }

    public void typeCheck() {
        // (Hint: Create types, then assign types to SSAFields/SSAMethods, then check types in SSAStatements)

        //Create types, then assign types to SSAFields/SSAMethods...
        for(SSAClass cls : prog.getClassesOrdered()){
            _Class(cls);
        }

        //Type checking... Both main and other classes...
        mainTypeCheck(this.prog.getMain());

        for(SSAClass cls : prog.getClassesOrdered()){
            typeCheck(cls);
        }
    }

//**************************************************Create types and assign types to SSAFields/SSAMethods************************************************
    public void _Class(SSAClass cls){

        //The type already in the vardecl(getFeild()), make it explicitly...   ********getField()<->VarDecl...
        for(SSAField fd : cls.getFieldsOrdered())
            fd.setType(findType(fd.getField().getType()));

        //Set paramtypes and return type...  **********Method...
        for(SSAMethod meth : cls.getMethodsOrdered()){
            meth.setRetType(findType(meth.getMethod().getType()));
            //Set parameters type...
            ArrayList<StaticType> cur = new ArrayList<StaticType>();
            for(Parameter para : meth.getMethod().getParameters()){
                cur.add(findType(para.getType()));
            }
            meth.setParamTypes(cur);
        }
    }
    //findType check if the type already exists in the type table(hash), if it's it directly return the coresponding type. Otherwise, it create the type in 
    //the table.. and return the type...
    public StaticType findType(Type node){
        String Typename = (node == null? "void" : node.getName());
        StaticType Stype;
        if(this.types.containsKey(Typename))     
            return (StaticType)this.types.get(Typename);

        if(Typename.equals("Object")){
            Stype = new ObjectType(Typename, null);
        }
        else if(node == null){
            Stype = new VoidType();
        }
        else if(node instanceof TypeInt){
            Stype = new PrimitiveType.IntType();
        }
        else if(node instanceof TypeBoolean){
            Stype = new PrimitiveType.BooleanType();
        }
        else if(node instanceof TypeIntArray){
            Stype = new ObjectType("int[]", (ObjectType)this.types.get("Object"));
        }
        //IF TYPE IS CLASS NAME....
        else{
            //ClassType need to be created to check the extension recursively...
            Stype = ClassType(Typename);
        }

        this.types.put(Typename, Stype);
        return Stype;
    }
    //Check type is class name ...(Recursive)
    public ObjectType ClassType(String classname){
        ObjectType Otype;
        //For the usage of checking extension class name...
        if(this.types.containsKey(classname))
            return (ObjectType)this.types.get(classname);

        //Type are not defined...
        SSAClass class_object = this.prog.getClass(classname);
        if(this.prog.getClass(classname) == null){
            throw new Error("No such Type :" + classname + "....");
        }
        //Check whether there is inheritation... ASTNODE <-> ClassDecl
        String extension = class_object.getASTNode().getExtends();
        if(extension != null){
            Otype = ClassType(extension);
        }
        else{
            Otype = (ObjectType)this.types.get("Object");
        }

        Otype = new ObjectType(classname, Otype);
        this.types.put(classname, Otype);
        
        return Otype; 
    }

//************************************************************Check types in SSAStatements**************************************************************
    public void typeCheck(SSAClass cl){
        for(SSAMethod md : cl.getMethodsOrdered())
            typeCheck(cl, md);
    }

    public void mainTypeCheck(SSAMethod main){
        HashMap<String, StaticType> local = new HashMap<String, StaticType>();
        for(SSAStatement st : main.getBody()){
            typeCheck(null, main, st, local);
        }
    }

    public void typeCheck(SSAClass cl, SSAMethod md){
        HashMap<String, StaticType> local = new HashMap<String, StaticType>();
        //Record the defined variable using hash...
        int i = 0;

        for(Parameter para : md.getMethod().getParameters()){
            local.put(para.getName(), md.getParamType(i++));
        }

        for(VarDecl var : md.getMethod().getVarDecls()){
            local.put(var.getName(), findType(var.getType()));
        }

        for(SSAStatement st : md.getBody()){
            typeCheck(cl, md, st, local);
        }
    }

    public void typeCheck(SSAClass cl, SSAMethod md, SSAStatement st, HashMap<String, StaticType> local){
        SSAStatement left = st.getLeft();
        SSAStatement right = st.getRight();
        switch(st.getOp()){
            // Meta:
            case Unify:
                StaticType temp; 
                if((temp = left.getType().commonSupertype(right.getType())) == null)
                    throw new Error("Incorrect unify types...");
                st.setType(temp);
                break;
            case Alias:
                st.setType(left.getType());
                break;
            // Data:
            case This:
                st.setType(ClassType(cl.getASTNode().getName()));
                break;
            case Parameter:
                st.setType(md.getParamType((int)st.getSpecial()));
                break;
            case Arg:
                st.setType(left.getType());
                break;
            case Null:
                st.setType(findType((Type)(st.getSpecial())));
                break;
            case Int:
                st.setType(findType(new TypeInt(null)));
                break;
            case Boolean:
                st.setType(findType(new TypeBoolean(null)));
                break;
            case NewObj:
                st.setType(ClassType((String)st.getSpecial()));
                break;
            case NewIntArray:
                //left.getType() => Size
                if(left.getType() instanceof PrimitiveType.IntType)
                    st.setType(findType(new TypeIntArray(null)));
                else
                    throw new Error("New intArray with size of not integer type...");
                break;
            // Control flow:
            case Label:
            case Goto:
                st.setType(findType(null));
                break;

            case Branch:
            case NBranch:
                if (!(left.getType() instanceof PrimitiveType.BooleanType))
                    throw new Error("Branch condition not boolean...");
                st.setType(findType(null));
                break;
            // Calls:
            case Call:
                //Object's class or superclass must have a method with the given name. 
                SSAMethod target_method = this.prog.getClass(left.getType().toString()).getMethod(this.prog, ((SSACall)(st.getSpecial())).getMethod());
                if(target_method == null)
                    throw new Error("Can not locate the method(not in the target class)...");

                //Each of the arguments must reference an 'Arg' SSAStatement.
                List<SSAStatement> call_arg_list = ((SSACall)(st.getSpecial())).getArgs();
                List<Parameter> method_arg_list = target_method.getMethod().getParameters();
                if(call_arg_list.size() != method_arg_list.size())
                    throw new Error("Incorrect number of argumets for the method...");

                //Each of the argument types must be a subtype of the method's corresponding parameter type
                int i = 0;
                for (SSAStatement para : call_arg_list) {
                    //SSAStatement for parameter has been seted before SSAStatement for function call...
                    if(!para.getType().subtypeOf(target_method.getParamType(i++)))
                        throw new Error("argument"+ i +"'s type does not match parameter subtype of " + target_method.getMethod().getName());
                }
                st.setType(target_method.getRetType());
                break;
            case Print:
                if(!(left.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Print with incorrect type...");
                st.setType(findType(null));
                break;
            case Return:
                if(left.getType().subtypeOf(md.getRetType()))
                    st.setType(findType(null));
                else
                    throw new Error("Return type dose not match method type...");
                break;
            // Member access:
            case Member:
            //first.second.third =>>
                    //Member first
                    //Member second
                    //Member third

            //Need to consider if member is "length", whether the target is array or not..
                if(((String)(st.getSpecial())).equals("length")){
                    if((left.getType() != this.types.get("int[]")))
                        throw new Error("Incorrect member: length...");
                    st.setType(findType(new TypeInt(null)));
                }
                else{
                    SSAField t;
                    if( (t = this.prog.getClass(left.getType().toString()).getField(this.prog, (String)(st.getSpecial()))) == null)
                        throw new Error("Incorrect member accessment ....");
                    st.setType(t.getType());
                }
                break;
            case Index:
                if((left.getType() != this.types.get("int[]")))
                    throw new Error("Incorrect Index target type...");
                if(!(right.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Incorrect Index type...");
                st.setType(findType(new TypeInt(null)));
                break;
            // Stack:
            case Store:
                st.setType(findType(null));
                break;
            case Load:
                //???
                break;
            // Assignments:
            case VarAssg:
                //if it's not defined, throw error...
                if(!local.containsKey((String)st.getSpecial()))
                    throw new Error("Variable has not been defined yet...");
                if(left.getType().subtypeOf(local.get((String)st.getSpecial())))
                    st.setType(local.get((String)st.getSpecial()));
                else
                    throw new Error("Incorrect value assignment...");
                break;
            case MemberAssg:
                //check whether the value type is the subtype of the target type...
                if(right.getType().subtypeOf(this.prog.getClass(left.getType().toString()).getField(this.prog, (String)st.getSpecial()).getType()))
                    st.setType(cl.getField(this.prog, (String)st.getSpecial()).getType());
                else
                    throw new Error("Incorrect Member assignment...");
                break;
            case IndexAssg:
                if((left.getType() != this.types.get("int[]")))
                    throw new Error("Incorrect type for the array in IndexAssg...");
                if(!(right.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Incorrect type for the value in IndexAssg...");
                if(!(((SSAStatement)st.getSpecial()).getType() instanceof PrimitiveType.IntType))
                    throw new Error("Incorrect type for the index in IndexAssg...");
                st.setType(right.getType());
                break;
            // Unary operator (left = operand):
            case Not:
                if(!(left.getType() instanceof PrimitiveType.BooleanType))
                    throw new Error("Not opperand is not Boolean...");
                st.setType(left.getType());
                break;
            // Binary operators (left, right = operands):
            case Lt:
            case Le:
                if(!(left.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Left opperand is not integer type...");
                if(!(right.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Right opperand is not integer type...");
                st.setType(findType(new TypeBoolean(null)));
                break;
            case Eq:
            case Ne:
                st.setType(findType(new TypeBoolean(null)));
                break;
            case Gt:
            case Ge:
                if(!(left.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Left opperand is not integer type...");
                if(!(right.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Right opperand is not integer type...");
                st.setType(findType(new TypeBoolean(null)));
                break;
            case And:
            case Or:
                if(!(left.getType() instanceof PrimitiveType.BooleanType))
                    throw new Error("Left opperand is not boolean type...");
                if(!(right.getType() instanceof PrimitiveType.BooleanType))
                    throw new Error("Right opperand is not boolean type...");
                st.setType(findType(new TypeBoolean(null)));
                break;
            case Plus:
            case Minus:
            case Mul:
            case Div:
            case Mod:
                if(!(left.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Left opperand is not integer type...");
                if(!(right.getType() instanceof PrimitiveType.IntType))
                    throw new Error("Right opperand is not integer type...");
                st.setType(findType(new TypeInt(null)));
                break;
            default:
        }
    }
    
}
