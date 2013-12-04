public class EDA {
	public static def main(args : Rail[String]) {
		val agent = new Agent("*");
		val e1 = new Event("a");
		val e2 = new Event("b");
		
		val test = (e : Event) => {
			new Value("Channel " + e.channel + " Success")
		};
		
		agent.registerHandler(e1, test);
		agent.fire(e1);
		agent.run();
		agent.registerHandler(e2, test);
		agent.fire(e2);
		finish for (i in 1..10){
			async {
			val e = new Event(i.toString());
			agent.registerHandler(e, test);
			agent.fire(e);
			}
		}
		//log("Before Stop");
		agent.stop();
	}
	
	public final static def log(s : String) {
		Console.OUT.println(s);
	}
}
