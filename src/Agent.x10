/*
 * Agent
 */
import x10.util.HashMap;
import x10.util.ArrayList;
import x10.util.concurrent.AtomicBoolean;
import x10.util.concurrent.Lock;
public class Agent {
	var handlers : HashMap[String, ArrayList[Handler]];
	var _task_queue : ArrayList[Event];
	var _tqLock : Lock;
	var _batch_count : Int;
	var channel : String;
	var defaultHandler : Handler;
	
	var _running : AtomicBoolean;
	
	public def this(chn:String) {
		this.handlers = new HashMap[String, ArrayList[Handler]]();
		this._batch_count = 20n;
		this.channel = chn;
		
		this.defaultHandler = new Handler("default");
		
		this.handlers.put("*", new ArrayList[Handler]());
		this.handlers("*")().add(defaultHandler);
		
		this._task_queue = new ArrayList[Event]();
		this._tqLock = new Lock();
		this._running = new AtomicBoolean(false);
	}
	
	public def registerHandler(h : (e : Event) => Value) {
		val handler = new Handler(h);
		this.handlers("*")().add(handler);
	}
	
	public def registerHandler(event : Event, h : (e : Event) => Value) {
		val handler = new Handler(h);
		if (event.channel == null) {
			log("No channel");
			this.registerHandler(h);
		} else if (this.handlers.containsKey(event.channel)) {
			log("Register another handler on channel " + event.channel);
			this.handlers(event.channel)().add(handler);
		} else {
			log("Register new channel " + event.channel);
			this.handlers.put(event.channel, new ArrayList[Handler]());
			this.handlers(event.channel)().add(handler);
		}
	}
	
	
	public def start() {
		this._running.set(true);
	}
	
	public def stop() {
		val stop_handle =  (e : Event) => {
			this._running.set(false);
			new Value("Stop")
		};
		
		val stop_event = new Event("*");
		this.registerHandler(stop_event, stop_handle);
		this.fire(stop_event);
	}
	
	public def run() {
		if (!this._running.get()) {
			this.start();
		}
		async while (this._running.get() || (this._task_queue.size() > 0)) {
			this.tick();
		}
	}
	
	public def tick() {
		this._tqLock.lock();
		
		if (this._task_queue.size() == 0) {
			this._tqLock.unlock();
			return;
		}
		
		val task = this._task_queue.removeLast();
		this._tqLock.unlock();
		log("Get task "+task.channel + " " + this._task_queue.size().toString() + " left");
		
		async this.processTask(task);

	}
	
	public def fire(event : Event) {
		// check channels
		
		if (event.channel == null) {
			event.channel = this.channel;
		}
		
		if (!this.handlers.containsKey(event.channel)){
			event.channel = this.channel;
		}
				
		// put it in task queue
		this._tqLock.lock();
		this._task_queue.addBefore(0l, event);
		this._tqLock.unlock();

	}
	
	public def processTask(task : Event) {
		for (handler in this.handlers(task.channel)()) {
			val v = handler.handle(task);
			task.setValue(v);
			log(task.value.get());
		}
	}
	
	public def toString() : String{
		return "Channel: " + channel;
	}
	
	public final static def log(s : String) {
		Console.OUT.println(s);
	}
}