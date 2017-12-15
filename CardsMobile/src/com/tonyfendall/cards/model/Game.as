package com.tonyfendall.cards.model
{
	import com.tonyfendall.cards.model.util.Colour;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	import com.tonyfendall.cards.player.supportClasses.AIPlayer;
	
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