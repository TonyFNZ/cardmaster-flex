package com.tonyfendall.cards.core
{
	import com.tonyfendall.cards.enum.Colour;
	import com.tonyfendall.cards.player.AIPlayer;
	import com.tonyfendall.cards.player.Hand;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.PlayerBase;
	
	import flash.events.EventDispatcher;

	
	
	[Event(name="turnStart", type="com.tonyfendall.cards.model.event.GameEvent")]
	[Event(name="targetSelectable", type="com.tonyfendall.cards.model.event.GameEvent")]

	[Event(name="prizeSelectable", type="com.tonyfendall.cards.model.event.GameEvent")]
	
	public class Game extends EventDispatcher
	{
		public var board:Board;
		
		public var player1:HumanPlayer;
		public var player2:AIPlayer;
		
		public var activePlayer:PlayerBase;
		
		public var gameStarted:Boolean = false;
		public var turnsComplete:Boolean = false;
		
		
		public function Game(human:HumanPlayer, ai:AIPlayer)
		{
			human.model = this;
			human.hand = human.chosenCards;
			this.player1 = human;
			
			ai.model = this;
			ai.hand = ai.chosenCards;
			this.player2 = ai;
			
			this.board = new Board();
		}
		
		
		public function get winningPlayer():PlayerBase
		{
			var p1:int = 0;
			var p2:int = 0;
			
			for each(var item:Item in board.items) {
				if( !(item is Card) )
					continue;
				
				var card:Card = item as Card;
				
				if(card.currentOwner == player1)
					p1++;
				if(card.currentOwner == player2)
					p2++;
			}
			
			if(p1 > p2)
				return player1;
			if(p2 > p1)
				return player2;
			
			return null;
		}
		
		public function get losingPlayer():PlayerBase
		{
			var p1:int = 0;
			var p2:int = 0;
			
			for each(var item:Item in board.items) {
				if( !(item is Card) )
					continue;
				
				var card:Card = item as Card;
				
				if(card.currentOwner == player1)
					p1++;
				if(card.currentOwner == player2)
					p2++;
			}
			
			if(p1 < p2)
				return player1;
			if(p2 < p1)
				return player2;
			
			return null;
		}
	}
}