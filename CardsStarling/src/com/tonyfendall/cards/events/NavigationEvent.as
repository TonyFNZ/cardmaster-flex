package com.tonyfendall.cards.events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		
		public var params:Object;
		
		public function NavigationEvent(type:String, _params:Object, bubbles:Boolean=false)
		{
			super(type, bubbles);
			params = _params;
		}
	}
}