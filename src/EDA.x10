public class EDA {
	public static def main(args : Rail[String]) {
		val agent = new Agent("*");
		val test = (e : Event) => {
			new Value("Channel " + e.channel + " Success")
		};

		
		finish for (i in 1..50){
			async {
				val e = new Event(i.toString());
				agent.registerHandler(e, test);
				agent.fire(e);
			}
		}
		
		agent.run();		
		
		finish for (i in 51..100) {
			async {
				val e = new Event(i.toString());
				agent.registerHandler(e, test);
				agent.fire(e);
			}
		}

		agent.stop();
	}
	
	public final static def log(s : String) {
		Console.OUT.println(s);
	}
}
