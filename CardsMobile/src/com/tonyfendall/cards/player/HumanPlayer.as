package com.tonyfendall.cards.player
{
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.controller.util.GameSetupUtil;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.Game;
	import com.tonyfendall.cards.model.Hand;
	import com.tonyfendall.cards.model.PlayerDeck;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;

	public class HumanPlayer extends PlayerBase
	{
		
		public var deck:PlayerDeck;
		
		
		public function HumanPlayer(deck:PlayerDeck)
		{
			super();
			
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