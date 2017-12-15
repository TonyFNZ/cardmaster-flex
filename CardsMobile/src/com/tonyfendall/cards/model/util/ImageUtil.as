package com.tonyfendall.cards.model.util
{
	import mx.collections.ArrayList;

	public class ImageUtil
	{
		
		public static const IMG01:String = "images/01.png";
		
		public static const IMG02:String = "images/02.png";
		
		public static const IMG03:String = "images/03.png";
		
		public static const IMG04:String = "images/04.png";
		
		
		public static function getList():ArrayList
		{
			return new ArrayList([IMG01, IMG02, IMG03, IMG04]);
		}
		
		public static function getRandom():String
		{
			var chance:Number = Math.random();
			
			if(chance < 0.25 )
				return IMG01;
			if(chance < 0.5)
				return IMG02;
			if(chance < 0.75)
				return IMG03;
			
			return IMG04;
		}
			
	}
}