package com.tonyfendall.cards.core
{
	import com.tonyfendall.cards.enum.CardType;
	
	public class CardGroup
	{
		public var type:CardType;
		public var children:Array;
		public var known:Boolean;
		
		public function CardGroup( type:CardType, known:Boolean = false ):void
		{
			this.type = type;
			this.known = known;
			this.children = new Array();
		}
		
		public function clone():CardGroup
		{
			var clone:CardGroup = new CardGroup(this.type, this.known);
			
			for each(var card:Card in this.children) {
				clone.children.push(card);
			}
			
			return clone;
		}
	}
}