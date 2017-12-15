package com.tonyfendall.cards.model.util
{
	public class VectorUtil.<T>
	{
		
		public static function contains(vector:Vector, item:T):void
		{
			
		}
		
		
		public static function union(vector1:Vector.<int>, vector2:Vector.<int>):Vector.<int>
		{
			var result:Vector.<int> = vector1.concat();
			
			for each (var item:Object in vector2)
			{
				if (vector1.indexOf(item) == -1)
				{
					result.push(item);
				}
			}
			
			return result;
		}
		
		public static  function complement(vector1:Vector.<int>, vector2:Vector.<int>):Vector.<int>
		{
			var result:Vector.<int> = new Vector.<int>();
			
			for each (var item:Object in vector1)
			{
				if (vector2.indexOf(item) == -1)
				{
					result.push(item);
				}
			}
			
			return result;
		}
		
		public static function intersect(vector1:Vector.<int>, vector2:Vector.<int>):Vector.<int>
		{
			var result:Vector.<int> = new Vector.<int>();
			
			for each (var item:Object in vector1)
			{
				if (vector2.indexOf(item) != -1)
				{
					result.push(item);
				}
			}
			
			return result;
		}
		
		public static function areEquals(vector1:Vector.<int>, vector2:Vector.<int>):Boolean
		{
			if (vector1.length != vector2.length)
			{
				return false;
			}
			
			for each (var item:Object in vector1)
			{
				if (vector2.indexOf(item) == -1)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function areEqualsVectorAndArray(vector1:Vector.<int>, array:Array):Boolean
		{
			if (vector1.length != array.length)
			{
				return false;
			}
			
			for each (var item:Object in vector1)
			{
				if (array.indexOf(item) == -1)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function copy(destination:Vector.<int>, source:Object):void
		{
			if (destination == source)
			{
				return;
			}
			destination.splice(0, destination.length);
			for each (var item:Object in source)
			{
				destination.push(item);
			}
		}
		
		public static function arrayToVector(array:Array):Vector.<int>
		{
			if (array == null)
			{
				return null;
			}
			
			var v:Vector.<int> = new Vector.<int>();
			
			for each (var item:int in array)
			{
				v.push(item);
			}
			
			return v;
		}
		
		public static function toArray(vector:Object):Array
		{
			var array:Array = new Array(vector.length);
			for (var i:uint=0; i < vector.length; i++) 
			{
				array[i] = vector[i];
			}
			return array;
		}
	}
}