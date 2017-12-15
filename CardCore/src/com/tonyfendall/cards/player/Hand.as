package com.tonyfendall.cards.player
{
	import com.tonyfendall.cards.core.Card;

	public class Hand
	{
		private var cards:Array;
		
		public var selectedCard:Card;
		

		public function Hand() {
			super();
			this.cards = [];
		}
		
		
		public function get size():int {
			return cards.length;
		}
		
		
		public function addCard(card:Card):void
		{
			cards.push(card);
		}
		
		public function getCard(index:int):Card
		{
			return cards[index];
		}
		
		public function removeCard(card:Card):void
		{
			if(selectedCard == card)
				selectedCard = null;

			for(var i:int = 0; i<cards.length; i++) {
				if( cards[i] == card)
				{
					cards.splice(i, 1);
					trace("Removed card from hand");
					return;
				}
			}
			
			
			trace("Could not find card in hand");
		}
		
	}
}