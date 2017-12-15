package com.tonyfendall.cards.core
{
	import com.tonyfendall.cards.enum.Direction;
	import com.tonyfendall.cards.enum.Type;
	
	
	public class CardAttack
	{
		public var origin:Card;
		public var target:Card;
		public var direction:uint;
		
		public function CardAttack() { }

/*		public function CardAttack(origin:Card, target:Card, direction:uint) {
			this.origin = origin;
			this.target = target;
			this.direction = direction;
		}*/
		
		
		public function get isOpposed():Boolean
		{
			return ( target.arrows & Direction.opposite(direction) ) > 0;
		}
		
		public function get chanceToWin():Number
		{
			if(!isOpposed)
				return 1;
			
			var a:Number = origin.attack;
			var d:Number = 0;
			switch(origin.type) {
				case Type.P:
					d = target.physDef;
					break;
				case Type.M:
					d = target.magicDef;
					break;
				case Type.X:
					d = Math.min( target.physDef, target.magicDef );
					break;
				case Type.A:
					d = Math.min( target.attack, target.physDef, target.magicDef );
					break;
			}
			
			return calcChanceToWin(a, d);
		}
		
		
		private function calcChanceToWin(attackPower:Number, defensePower:Number):Number
		{
			var a:Number = (attackPower * 16) + 7.5; // middle of the possible hp range
			var d:Number = (defensePower * 16) + 7.5;
			
			var swap:Boolean = false;
			if(a < d) {
				swap = true;
				var b:Number = a;
				a = d;
				d = b;
			}
			
			// 			     1 + Power of Weak
			// 100 * (1 -  ----------------------)
			//             2*(1+ Power of Strong)
			
			var c:Number = 1 - ( (1 + d)/(2 + 2*a) );
			
			if(swap)
				return 1 - c;
			else
				return c;
		}
	}
}