package com.tonyfendall.cards.model.util
{
	public class Colour
	{
		
		public static const BLUE:Colour = new Colour("Blue");
		public static const RED:Colour = new Colour("Red");
		
		private var name:String;
		
		public function Colour(name:String)
		{
			this.name = name;
		}
		
		public function toString():String
		{
			return name;
		}
	}
}