package edu.purdue.cs352.minijava.backend;

import java.util.*;

import edu.purdue.cs352.minijava.ssa.*;

public class ClassLayout {
    // get the number of fields in an instance of this object
    public static int objectFields(SSAProgram prog, SSAClass cl) {
        int num_Fields = 0;
        SSAClass cur_class = cl;
        while(cur_class != null){
            num_Fields += cur_class.getFieldsOrdered().size();
            cur_class = cur_class.superclass(prog);
        }
        return num_Fields;
    }

    // get the size of an object (its number of fields plus one for the vtable)
    public static int objectSize(SSAProgram prog, SSAClass cl) {
        return objectFields(prog, cl) + 1;
    }

    // get the offset of a field within an object
    public static int fieldOffset(SSAProgram prog, SSAClass cl, String field) {
        if(cl == null)
            return -1;
        SSAClass cur_class = cl;
        SSAField cur_Field = cur_class.getField(field);
        int offset = 0;
        while(cur_class != null){
            //Field is in current field.
            if(cur_Field != null){
                offset = objectFields(prog, cur_class.superclass(prog)) + cur_Field.getIndex();
                break;
            }
            else{
                cur_class = cur_class.superclass(prog);
            }
        }
        //Can't find any field.
        if(cur_class == null)
            return -1;
        return offset + 1;
    }

    // a vtable
    public static class Vtable {
        public final List<String> methods;
        public final Map<String, Integer> methodOffsets;

        public Vtable(List<String> methods) {
            this.methods = methods;

            methodOffsets = new HashMap<String, Integer>();
            int off = 0;
            for (String m : methods)
                methodOffsets.put(m, off++);
        }
    }

    // get the complete vtable layout for this class
    // Note: MiniJava do not have method overload.
    public static Vtable getVtable(SSAProgram prog, SSAClass cl) {
        SSAClass cur_class = cl;
        List<String> methods = new ArrayList<String>();
        Stack<SSAClass> stack = new Stack<SSAClass>();
        Set<String> hash = new HashSet<String>();
        while(cur_class != null){
            stack.push(cur_class);
            cur_class = cur_class.superclass(prog);
        }
        while(!stack.empty()){
            cur_class = stack.pop();
            for(SSAMethod method : cur_class.getMethodsOrdered()){
                String str = method.getMethod().getName();
                if(!hash.contains(str)) {
                    hash.add(str);
                    methods.add(str);
                }
            }
        }
        return new Vtable(methods);
    }

    // get the size of the vtable for a class
    public static int vtableSize(SSAProgram prog, SSAClass cl) {
        SSAClass cur_class = cl;
        Stack<SSAClass> stack = new Stack<SSAClass>();
        Set<String> hash = new HashSet<String>();
        while(cur_class != null){
            stack.push(cur_class);
            cur_class = cur_class.superclass(prog);
        }
        while(!stack.empty()){
            cur_class = stack.pop();
            for(SSAMethod method : cur_class.getMethodsOrdered()){
                String str = method.getMethod().getName();
                if(!hash.contains(str)) {
                    hash.add(str);
                }
            }
        }
        return hash.size();    
    }

    // for a given method, get the implementing class
    public SSAClass getImplementor(SSAProgram prog, SSAClass cl, String method) {
        return cl.getMethodProvider(prog, method);
    }
}
