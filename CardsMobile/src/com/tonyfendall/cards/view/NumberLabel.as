package com.tonyfendall.cards.view
{
	import spark.components.Label;
	
	public class NumberLabel extends Label
	{
		public function NumberLabel()
		{
			super();
		}
		
		
		private var _value:int = 0;
		
		public function set value(v:int):void
		{
			_value = v;
			this.text = v.toString();
		}
		
		public function get value():int
		{
			return _value;
		}
	}
}