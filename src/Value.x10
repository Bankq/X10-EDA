public class Value {
	var value : String;
	public def this(s : String) {
		value = s; 
	}
	
	public def get() {
		return this.value;
	}
	
	public def set(vs : String) {
		this.value = vs;
	}
}