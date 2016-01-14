class Factorial{
    public static void main(String[] a){
	System.out.println(new Fac().ComputeFac(10));
    }
}

class cool {
	public int shit(int num){
		System.out.println(37756);
		return 1;
	}
}

class Fac extends cool{

    public int ComputeFac(int num){
	int num_aux ;
	if (num < 1)
	    num_aux = 1 ;
	else 
	    num_aux = num * (this.ComputeFac(num-1)) ;
	this.shit(3);

	return num_aux ;
    }

}
