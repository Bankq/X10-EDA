import x10.util.Set;

/*
 * Event class
 */

public class Event {
	var etype : String;
	var channel : String;
	var cancelled : boolean;
	var stopped : boolean;
	var success : boolean;
	var successCallBack : (e : Event) => Any;
	var value : Value;
	
	public def this() {
		this.cancelled = false;	
		this.stopped = false;
		this.value = new Value("OK");
	}
	
	public def this(chn : String) {
		this();
		this.channel = chn;
	}
	
	public def setValue(v : Value) {
		this.value.set(v.get());
	}
	
}