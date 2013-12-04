/*
 * Event Handler
 */
public class Handler {
	var handle : (e : Event) => Value ;
	
	public def this(s : String) {
		this.handle = (e : Event) => {
			new Value(s)
		};
	}
	public def this(h : (e : Event) => Value) {
		this.handle = h;
	}
	
	public def toString() : String{
		return "Handle: " + handle.toString();
	}
}