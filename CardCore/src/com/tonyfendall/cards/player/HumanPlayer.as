package com.tonyfendall.cards.player
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.enum.Colour;

	public class HumanPlayer extends PlayerBase
	{
		
		public var deck:PlayerDeck;
		
		
		public function HumanPlayer(deck:PlayerDeck)
		{
			super();
			
			this.colour = Colour.BLUE;
			
			this.deck = deck;
			deck.load(this);
		}
		
		
		override public function get chosenCards():Hand
		{
			var hand:Hand = new Hand();
			var cards:Array = deck.getHand();
			
			for each(var card:Card in cards) {
				hand.addCard(card.clone());
			}
				
			return hand;
		}
		
		override public function get name():String
		{
			return "Human Player";
		}
		
		
		override public function receiveCard(card:Card):void
		{
			card.originalOwner = this;
			card.currentOwner = this;
			
			deck.addCard(card);
		}
		
		override public function loseCard(card:Card):void
		{
			deck.removeCard(card);
		}
	}
}