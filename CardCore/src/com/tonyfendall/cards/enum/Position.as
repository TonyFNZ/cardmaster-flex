package com.tonyfendall.cards.enum
{
	public class Position
	{
		
		public var x:int;
		public var y:int;
		
		public function Position(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		public function toString():String
		{
			return "["+x+","+y+"]";
		}
	}
}