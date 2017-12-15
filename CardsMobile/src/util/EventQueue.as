package util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class EventQueue
	{
		
		private var queue:Array;
		private var delays:Object;
		
		private var waiting:Boolean = false;
		
		private var callback:Function;
		
		
		public function EventQueue(callback:Function)
		{
			this.callback = callback;
			queue = [];
			delays = {};
		}
		
		public function bind(target:IEventDispatcher, type:String, delay:uint):void
		{
			//trace("BIND "+type);
			delays[type] = delay;
			target.addEventListener(type, onEvent);
		}

		public function unbind(target:IEventDispatcher, type:String):void
		{
			target.removeEventListener(type, onEvent);

			var i:int = 0;
			var event:Event;
			while( i<queue.length ) {
				event = queue[i] as Event;
				
				if(event.type == type) {
					queue.splice(i, 1);
				} else {
					i++;
				}
			}
		}
		
		
		private function onEvent(event:Event):void
		{
			queue.push(event);	
			
			trace("----- QUEUE: "+event.target.arrows+" "+event.type+" "+queue.length);

			if(!waiting) {
				dequeue();
			}
		}
		
		private function dequeue():void
		{
			this.waiting = true;

			if(queue.length < 1) {
				this.waiting = false;
				return;
			}
			
			var event:Event = queue.shift();
			var delay:uint = delays[event.type];
			
			trace("----- DEQUEUE: "+event.type+" "+queue.length);
			
			callback.call(this, event);
			setTimeout(dequeue, delay);
		}
	}
}
