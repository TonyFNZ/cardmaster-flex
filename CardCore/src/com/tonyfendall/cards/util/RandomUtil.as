package com.tonyfendall.cards.util
{
	public class RandomUtil
	{
		
		public static function getBellRandom(min:int, max:int):int
		{
			if(min == max)
				return min;
			
			return Math.round( bellRandom( min, max, min, max, 5 ) );	
		}
			
		
		private static function bellRandom(bmin:Number, bmax:Number, rmin:Number, rmax:Number, n:int):Number
		{
			// Generalized random number generator;
			// sum of n random variables (usually 3).
			// Bell curve spans bmin<=x<bmax; then,
			// values outside rmin<=x<rmax are rejected.
			var i:int = 0;
			var u:Number = rmin - 1;
			var sum:Number = 0;
			var range:Number = (bmax - bmin);
			
			while( !(rmin <= u && u < rmax) ) 
			{
				sum = 0;
				for ( i=0; i<n; i++) 
				{
					sum += bmin + (Math.random()*range);
				}
				
				if (sum < 0) 
					sum -= n-1; /* prevent pileup at 0 */
				
				u = sum / n;
			}
			
			return u;
		}

	}
}