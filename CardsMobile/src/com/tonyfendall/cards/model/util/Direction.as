package com.tonyfendall.cards.model.util
{
	public class Direction
	{
		
		public static const N:uint  = 0x01; // 0000 0001
		public static const NE:uint = 0x02; // 0000 0010
		public static const E:uint  = 0x04; // 0000 0100
		public static const SE:uint = 0x08; // 0000 1000
		public static const S:uint  = 0x10; // 0001 0000
		public static const SW:uint = 0x20; // 0010 0000
		public static const W:uint  = 0x40; // 0100 0000
		public static const NW:uint = 0x80; // 1000 0000

		public static const LIST:Array = [N, NE, E, SE, S, SW, W, NW];

		public static function opposite(d:uint):uint
		{
			// Swap top 4 bits with lower 4 bits
			return ((d << 4) & 0xF0) + ((d >> 4) & 0x0F);
		}
		
		
		public static function toString(direction:uint):String
		{
			var output:String = direction.toString(2);
			while(output.length < 8) {
				output = "0" + output;
			}
			return output;
		}
		
	}
}