package com.tonyfendall.cards.model
{
	import mx.collections.ArrayList;
	
	import persistance.CardType;

	public class CardGroup
	{
		public var type:CardType;
		public var cards:ArrayList;
		public var known:Boolean;
		
		public function CardGroup( toClone:CardGroup = null ):void
		{
			this.cards = new ArrayList();

			if(toClone != null) {
				this.type = toClone.type;
				this.known = toClone.known;
				
				for each(var card:Card in toClone.cards.source) {
					this.cards.addItem(card);
				}
				
				trace(this.cards.length, toClone.cards.length);
			}
		}
	}
}