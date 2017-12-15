package com.tonyfendall.cards.model.util
{
	import com.tonyfendall.cards.model.Card;

	public class CardUtil
	{
		

		public static function index(vector:Vector.<Card>, card:Card ):int
		{
			var len:int = vector.length;
			for(var i:int=0; i<len; i++)
			{
				if(vector[i] == card)
					return i;
			}
			return -1;
		}
		
		
		public static function contains(vector:Vector.<Card>, card:Card ):Boolean
		{
			var len:int = vector.length;
			for(var i:int=0; i<len; i++)
			{
				if(vector[i] == card)
					return true;
			}
			return false;
		}

		
		public static function remove(vector:Vector.<Card>, card:Card ):Boolean
		{
			var index:int = index(vector, card);
			if(index < 0)
				return false;
			
			vector.splice(index, 1);
			return true;
		}
		
		
	}
}