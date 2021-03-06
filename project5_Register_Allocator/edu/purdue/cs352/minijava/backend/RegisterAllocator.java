package edu.purdue.cs352.minijava.backend;

import java.util.*;

import edu.purdue.cs352.minijava.ssa.*;

public class RegisterAllocator {

    // the block we're performing allocation over
    List<SSAStatement> block;
    List<CFNode> cfgList;

    Set<TempNode> interfList;
    Set<Variable> variables;

    Map<SSAStatement, Variable> var_binding;
    Map<SSAStatement, CFNode> cfgN_binding;
    Map<Variable, Set<CFNode>> var_use;
    Map<Variable, TempNode> tempN_binding;

    Map<TempNode, Integer> spill_binding = new HashMap<TempNode, Integer>();

    Map<String, CFNode> cfgN_label;

    int spill = 0;
    /* FILLIN: You may additionally need fields for, e.g.,
     * The number of spills you have performed (to fill the special field of Store and Load operations),-------
     * Your list of variables,-----------
     * Your SSAStatement->variable binding (def(v)),-------------
     * Your list of CFG nodes,---------------
     * Your SSAProgram->CFG node binding,---------
     * use(v),-----------
     * Your list of interference graph nodes,--------------
     * Your binding of variables to nodes in the interference graph.----------
     */

    /* a "variable" is just a set of SSA statements. We alias it (sort of) to
     * make this explicit. A Variable is thus equivalently a definition of
     * def(v). */

    static class Variable {
        public final SSAStatement master; // just for debugging
        public final Set<SSAStatement> v; //SSAStatement that point to the same Var
        public Variable(SSAStatement s) {
            master = s;
            v = new HashSet<SSAStatement>();
            v.add(s);
        }
    }

    // a node in the control flow graph
    class CFNode {

        private SSAStatement statement;

        private Set<Variable> in;
        private Set<Variable> out;

        private Variable def;
        private Set<Variable> use;
        private Set<CFNode> pred;
        private Set<CFNode> succ;

        public CFNode(SSAStatement cur){
            this.statement = cur;
            this.def = var_binding.get(cur);
            this.use = new HashSet<Variable>();
            this.pred = new HashSet<CFNode>();
            this.succ = new HashSet<CFNode>();
            this.in = new HashSet<Variable>();
            this.out = new HashSet<Variable>();
        }
        public void set_in(HashSet<Variable> new_in){
        	this.in = new_in;
        }
        
        public void set_out(HashSet<Variable> new_out){
        	this.out = new_out;
        }

        public SSAStatement get_stmt(){
            return statement;
        }
        public Set<Variable> get_in(){
            return in;
        }
        public Set<Variable> get_out(){
            return out;
        }
        public Variable get_def(){
            return def;
        }
        public Set<Variable> get_use(){
            return use;
        }
        public Set<CFNode> get_pred(){
            return pred;
        }
        public Set<CFNode> get_succ(){
            return succ;
        }
    }

    // a node in the interference graph (a temporary)
    class TempNode {
        private int register; //Color...
        private Variable var;
        private Set<TempNode> interf;
        private boolean likely_spill;
        private boolean pinned;
        private boolean ingraph;

        public TempNode(Variable var){
            this.var = var;
            this.interf = new HashSet<TempNode>();
            this.register = -1;

            this.likely_spill = false;
            this.pinned = false;
            this.ingraph = false;
            
            for(SSAStatement stmt : var.v){
            	if(stmt.registerPinned()){
            		this.register = stmt.getRegister();
            		this.pinned = true;
            		break;
            	}
            }
        }
        public void set_ingraph(boolean bol){
            this.ingraph = bol;
        }
        public void set_likely_spill(boolean bol){
            this.likely_spill = bol;
        }
        public void set_reg(int newreg){
            this.register = newreg;
        }

        public int get_reg(){
            return register;
        }
        public Variable get_var(){
            return var;
        }
        public Set<TempNode> get_interf(){
            return interf;
        }
        public boolean is_likely_spill(){
            return likely_spill;
        }
        public boolean is_pinned(){
            return pinned;
        }
        public boolean is_ingraph(){
            return ingraph;
        }
    }


    private RegisterAllocator() {}

    // perform all register allocations for this program
    public static void alloc(SSAProgram prog, int freeRegisters) {
        // first main
        SSAMethod main = prog.getMain();
        main.setBody(alloc(main.getBody(), freeRegisters));

        // then each class
        for (SSAClass cl : prog.getClassesOrdered())
            alloc(cl, freeRegisters);
    }

    // perform all register allocations for this class
    public static void alloc(SSAClass cl, int freeRegisters) {
        for (SSAMethod m : cl.getMethodsOrdered())
            alloc(m, freeRegisters);
    }

    // perform register allocation for this method
    public static void alloc(SSAMethod m, int freeRegisters) {
        m.setBody(alloc(m.getBody(), freeRegisters));
    }

    // the register allocator itself
    public static List<SSAStatement> alloc(List<SSAStatement> block, int freeRegisters) {
        Set<TempNode> actualSpills;

        RegisterAllocator ra = new RegisterAllocator();
        ra.block = block;

        while (true) {
            // prefill the variables with single statements
            ra.initVariables();

            // unify
            ra.unifyVariables();

            // now build the CF nodes
            ra.initCFNodes();

            // build the use[n] relationship from them
            ra.addUses();

            // build their successor/predecessor relationships
            ra.cfPredSucc();

            // liveness analysis
            ra.liveness();

            // build the temporaries
            ra.initTempNodes();

            // and figure out their interference
            ra.buildInterference();

            Stack<TempNode> stack = ra.simplify(freeRegisters);

            // do we need to spill?
            actualSpills = ra.select(freeRegisters, stack);
            if (actualSpills.size() == 0) break;

            // OK, rewrite to perform the spills
            ra.performSpills(actualSpills);
        }

        // FILLIN: now, using the information from the interference graph, assign the register for each SSA statement
        for(TempNode tempN : ra.interfList){
            if (tempN.get_reg() >= 0)
                for(SSAStatement ssa : tempN.get_var().v){
                    ssa.setRegister(tempN.get_reg());
                }
        }
        //System.out.println("Done...");

        /*for(SSAStatement ssa : ra.block){
            if(ssa.registerPinned())
                        System.out.print("--------");
            System.out.println(ssa.toString());
        }*/
        return ra.block;
    }
    //Assume every Variable belongs to one SSAStatement. Initiallize A variable for every SSAStatement
    private void initVariables(){
        this.variables = new HashSet<Variable>();
        this.var_binding = new HashMap<SSAStatement, Variable>();
        this.var_use = new HashMap<Variable, Set<CFNode>>();

        for(SSAStatement cur : this.block){
            Variable var = new Variable(cur);
            this.variables.add(var);
            this.var_binding.put(cur, var);
            this.var_use.put(var, new HashSet<CFNode>());
        }
    }
    //Unify Variable, One Variable may correspond to one or more SSAStatement
    private void unifyVariables(){
        for(SSAStatement cur: this.block){
            if(cur.getOp() == SSAStatement.Op.Unify){
                SSAStatement left = cur.getLeft();
                SSAStatement right = cur.getRight();
                Variable var = var_binding.get(cur);
                Variable varleft = var_binding.get(left);
                Variable varright = var_binding.get(right);
                if(varleft != var){
                    for(SSAStatement st : varleft.v){
                        var_binding.put(st, var);
                        var.v.add(st);
                    }
                    this.variables.remove(varleft);
                }
                if(varright != var){
                    for(SSAStatement st : varright.v){
                        var_binding.put(st, var);
                        var.v.add(st);
                    }
                    this.variables.remove(varright);
                }
            }
            else if(cur.getOp() == SSAStatement.Op.Alias){
                SSAStatement left = cur.getLeft();
                Variable var = var_binding.get(cur);
                Variable varleft = var_binding.get(left);
                if(varleft != var){
                    for(SSAStatement st : varleft.v){
                        var_binding.put(st, var);
                        var.v.add(st);
                    }
                    this.variables.remove(varleft);
                }
            }
        }
    }
    //Create CFNode for every SSAStatement, as above, each variable can correspond to more than one CFNode
    private void initCFNodes(){
        this.cfgList = new ArrayList<CFNode>();
        this.cfgN_binding = new HashMap<SSAStatement, CFNode>();
        this.cfgN_label = new HashMap<String, CFNode>();

        for(SSAStatement st : this.block){
            CFNode cfn = new CFNode(st);
            this.cfgList.add(cfn);
            this.cfgN_binding.put(st, cfn);

            if(st.getOp() == SSAStatement.Op.Label)
                this.cfgN_label.put((String)st.getSpecial(), cfn);
        }
    }
    //Specify the arguments(SSAStatements) used in this SSAStatement
    private void addUses(){
        for(CFNode cfn : this.cfgList){
            SSAStatement st = cfn.get_stmt();
            SSAStatement stleft = st.getLeft();
            SSAStatement stright = st.getRight();

            if(stleft != null){
                Variable var = this.var_binding.get(stleft);
                cfn.get_use().add(var);
                this.var_use.get(var).add(cfn);
            }
            if(stright != null){
                Variable var = this.var_binding.get(stright);
                cfn.get_use().add(var);
                this.var_use.get(var).add(cfn);
            }
            //For parameter SSAStatement and index SSAStatement stored in special() in Op.call and Op.IndexAssg respectively
            if(st.getOp() == SSAStatement.Op.Call){
                SSACall ssacall = (SSACall)(st.getSpecial());
                for(SSAStatement arg : ssacall.getArgs()){
                    Variable var = this.var_binding.get(arg);
                    cfn.get_use().add(var);
                    this.var_use.get(var).add(cfn);
                }
            }
            else if(st.getOp() == SSAStatement.Op.IndexAssg){
                Variable var = this.var_binding.get((SSAStatement)(st.getSpecial()));
                cfn.get_use().add(var);
                this.var_use.get(var).add(cfn);
            }
        }
    }
    //Building the Cfn Graph ..
    private void cfPredSucc(){
        CFNode pre = null;
        SSAStatement preStm = null;
        for(SSAStatement st : this.block){
            CFNode cur = this.cfgN_binding.get(st);
            if(pre != null){
                if(st.getOp() == SSAStatement.Op.NBranch || st.getOp() == SSAStatement.Op.Branch || st.getOp() == SSAStatement.Op.Goto){
                    CFNode label_cfn = this.cfgN_label.get((String)(st.getSpecial()));
                    if(label_cfn != null){
                    	cur.get_pred().add(pre);
                        cur.get_succ().add(label_cfn);
                        pre.get_succ().add(cur);
                        label_cfn.get_pred().add(cur);
                    }
                }
                else{
                	if(preStm.getOp() == SSAStatement.Op.Goto){
                		preStm = st;
                		pre = cur;
                		continue;
                	}
                    cur.get_pred().add(pre);
                    pre.get_succ().add(cur);
                }
            }
            preStm = st;
            pre = cur;
        }
    }    
    //Fill in the Input and output field.
    private void liveness(){
    	boolean nonstop = true;
    	while(nonstop){
    		nonstop = false;
    		for(CFNode cfn : this.cfgList){
                //For out.
                HashSet<Variable> new_out = new HashSet<Variable>();

                new_out.add(cfn.get_def());
                for(CFNode suc_cfn : cfn.get_succ()){
                    for(Variable var : suc_cfn.get_in())
                        new_out.add(var);
                }

                //For in.
    			HashSet<Variable> new_in = new HashSet<Variable>();

    			for(Variable var : new_out)
    				new_in.add(var);

    			new_in.remove(cfn.get_def());

    			for(Variable var : cfn.get_use())
    				new_in.add(var);
    				
    			if(!new_in.equals(cfn.get_in()) || !new_out.equals(cfn.get_out()))
    				nonstop = true;
    				
    			cfn.set_in(new_in);
    			cfn.set_out(new_out);
    		}
    	}
    }
    //For each Variable, there is a specific tempNode in the inference graph correspond to it
    private void initTempNodes(){
    	this.interfList = new HashSet<TempNode>();
    	this.tempN_binding = new HashMap<Variable, TempNode>();
    	for (Variable var : this.variables) {
    		TempNode tn = new TempNode(var);
    		this.interfList.add(tn);
      		this.tempN_binding.put(var, tn);
    	}
    }
    //Build the interference graph according to the CFNode in and out set
    private void buildInterference(){
    	for(CFNode cfn : this.cfgList){
            for(Variable var : cfn.get_in()){
                TempNode curTempNode = this.tempN_binding.get(var);
                for(Variable interf_var : cfn.get_in()){
                    TempNode interf_tempN = this.tempN_binding.get(interf_var);
                    if(interf_var != var){
                        curTempNode.get_interf().add(interf_tempN);
                    }
                }
            }
            for(Variable var : cfn.get_out()){
                TempNode curTempNode = this.tempN_binding.get(var);
                for(Variable interf_var : cfn.get_out()){
                    TempNode interf_tempN = this.tempN_binding.get(interf_var);
                    if(interf_var != var){
                        curTempNode.get_interf().add(interf_tempN);
                    }
                }   
            }
        }
    }
    //Find the likely_spill TempNode and mark them in the Object
    private Stack<TempNode> simplify(int freeRegisters){

        boolean is_changed = false;

        Set<TempNode> graph = new HashSet<TempNode>();

        Stack<TempNode> stack = new Stack<TempNode>();

        int pinned_num = 0;
        //Add the tempNode on the graph.
        for(TempNode tempN : this.interfList){
            tempN.set_ingraph(true);
            graph.add(tempN);
            if(tempN.is_pinned())
                pinned_num++;
        }

        while(graph.size() != pinned_num){
            is_changed = false;
            for(TempNode tempN : graph){
                if(tempN.is_pinned())
                    continue;
                int cur_interf_num = 0;
                for(TempNode intf_tempN : tempN.get_interf()){
                    if(intf_tempN.is_ingraph())
                        cur_interf_num ++;
                }

                if(cur_interf_num < (freeRegisters-1)){
                    graph.remove(tempN);
                    stack.push(tempN);
                    tempN.set_ingraph(false);
                    is_changed = true;
                    break;
                }
            }
            if(!is_changed && graph.size() != pinned_num){
                //The remainning graph is the nodes that with its degree more than the number of free registers
                //I will pick the one with less use(var)
                int max = Integer.MIN_VALUE;
                TempNode spill_one = null;
                for(TempNode t : graph){
                    if(t.is_pinned())
                        continue;
                    int num_of_infer = t.get_interf().size();
                    if(num_of_infer > max){
                        max = num_of_infer;
                        spill_one = t;
                    }
                }
                if(spill_one != null){
                    spill_one.set_likely_spill(true);
                    graph.remove(spill_one);
                    spill_one.set_ingraph(false);
                }
            }
        }

        for(TempNode tempN : graph)
            stack.push(tempN);

        return stack;
    }
    //Give the register number to non-spinned TempNode(Variable) and return the "real" TempNode(Variable) which need to be spilled
    private Set<TempNode> select(int freeRegisters, Stack<TempNode> stack){
        boolean[] reg_table = new boolean[freeRegisters];
        Set<TempNode> actualSpills = new HashSet<TempNode>();
        int i;

        while(!stack.empty()){
            TempNode tempN = stack.pop(); 
            if(!tempN.is_pinned() && !tempN.is_likely_spill()){
                for(i = 0; i < reg_table.length; i++){
                    reg_table[i] = false;
                }
                for(TempNode t : tempN.get_interf()){
                    if (t.get_reg() >= 0) 
                        reg_table[t.get_reg()] = true;
                }
                for(i = 0; i < reg_table.length; i++){
                    if(reg_table[i] == false){
                        tempN.set_reg(i);
                        break;
                    }
                }
                if(i == reg_table.length){
                    actualSpills.add(tempN);
                    tempN.set_reg(-1);
                    //throw new Error("Register is incorrectly allocated(Wrong Spill choice)..");
                }
            }
        }
        for(TempNode tempN : this.interfList){
            if(tempN.is_likely_spill())
                actualSpills.add(tempN);
        }

        ArrayList<TempNode> nonspill_nodes = new ArrayList<TempNode>();
        //After all the non-likely-spilled variable are assigned register, try to assign the likely-spilled variable register.
        for(TempNode tempN : actualSpills){
            for(i = 0; i < reg_table.length; i++){
                reg_table[i] = false;
            }
            for(TempNode t : tempN.get_interf()){
                if (t.get_reg() >= 0) 
                        reg_table[t.get_reg()] = true;
            }
            for(i = 0; i < reg_table.length; i++){
                if(reg_table[i] == false){
                    tempN.set_reg(i);
                    nonspill_nodes.add(tempN);
                    break;
                }
            }
        }
        for(TempNode tempN : nonspill_nodes)
            actualSpills.remove(tempN);
        //Fill the spill numbers field.
        for(TempNode tempN : actualSpills){
            this.spill_binding.put(tempN, this.spill);
            this.spill++;
        }

        return actualSpills;
    }
    //Map<Variable, TempNode> tempN_binding;
    //Map<SSAStatement, Variable> var_binding;
    private void performSpills(Set<TempNode> actualSpills){
        ArrayList<SSAStatement> dummyblock = new ArrayList<SSAStatement>();
        for(SSAStatement cur : this.block){
            //check whether it need to load.
            add_Load_if_necessary(cur, actualSpills, dummyblock);

            //Add the original SSAStatement.
            dummyblock.add(cur);

            //check whether it need to store.
            add_Store_if_necessary(cur, actualSpills, dummyblock);
        }
        this.block = dummyblock;
    }

    private void add_Load_if_necessary(SSAStatement cur, Set<TempNode> actualSpills, ArrayList<SSAStatement> dummyblock){
        SSAStatement left = cur.getLeft();
        SSAStatement right = cur.getRight();

        if(left != null){
            TempNode tempN = tempN_binding.get(this.var_binding.get(left));
            if(tempN == null)
                throw new Error("left tempN in add_Load_if_necessary is null.");
            if(actualSpills.contains(tempN)){
                SSAStatement load_ssa = new SSAStatement(null, SSAStatement.Op.Load, this.spill_binding.get(tempN));
                dummyblock.add(load_ssa);
                cur.setLeft(load_ssa);
            }
        }
        if(right != null){
            TempNode tempN = tempN_binding.get(this.var_binding.get(right));
            if(tempN == null)
                throw new Error("right tempN in add_Load_if_necessary is null.");
            if(actualSpills.contains(tempN)){
                SSAStatement load_ssa = new SSAStatement(null, SSAStatement.Op.Load, this.spill_binding.get(tempN));
                dummyblock.add(load_ssa);
                cur.setRight(load_ssa);
            }
        }
        if(cur.getOp() == SSAStatement.Op.Call){
            SSACall ssacall = (SSACall)cur.getSpecial();
            for(SSAStatement arg : ssacall.getArgs()){
                TempNode tempN = tempN_binding.get(this.var_binding.get(arg));
                if(tempN == null)
                    throw new Error("argument tempN in add_Load_if_necessary is null.");
                if(actualSpills.contains(tempN)){
                    SSAStatement load_ssa = new SSAStatement(null, SSAStatement.Op.Load, this.spill_binding.get(tempN));
                    dummyblock.add(load_ssa);
                    ssacall.getArgs().set(ssacall.getArgs().indexOf(arg) ,load_ssa);
                }
            }
            
        }
        if(cur.getOp() == SSAStatement.Op.IndexAssg){
            SSAStatement special = (SSAStatement)(cur.getSpecial());
            TempNode tempN = tempN_binding.get(this.var_binding.get(special));
            if(tempN == null)
                throw new Error("Index tempN in add_Load_if_necessary is null.");
            if(actualSpills.contains(tempN)){
                SSAStatement load_ssa = new SSAStatement(null, SSAStatement.Op.Load, this.spill_binding.get(tempN));
                dummyblock.add(load_ssa);
                cur.setSpecial(load_ssa);
            }
        }
    }

    private void add_Store_if_necessary(SSAStatement cur, Set<TempNode> actualSpills, ArrayList<SSAStatement> dummyblock){
        TempNode tempN = tempN_binding.get(this.var_binding.get(cur));
        if(tempN == null)
            throw new Error("cur tempN in add_Store_if_necessary is null.");
        if(actualSpills.contains(tempN)){
            SSAStatement store_ssa = new SSAStatement(null, SSAStatement.Op.Store, cur, null, this.spill_binding.get(tempN));
            dummyblock.add(store_ssa);
        }
    }
}








