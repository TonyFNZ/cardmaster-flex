package com.tonyfendall.cards.controller.util
{
	import com.tonyfendall.cards.model.Block;
	import com.tonyfendall.cards.model.Board;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.Game;
	import com.tonyfendall.cards.model.Hand;
	import com.tonyfendall.cards.model.util.Colour;
	import com.tonyfendall.cards.model.util.Direction;
	import com.tonyfendall.cards.model.util.ImageUtil;
	import com.tonyfendall.cards.model.util.Position;
	import com.tonyfendall.cards.model.util.Type;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.supportClasses.AIPlayer;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import persistance.CardType;

	public class GameSetupUtil
	{
		
		public static function buildGame(player1:HumanPlayer, player2:AIPlayer):Game
		{
			var board:Board = new Board();
			//addRamdomBlocks( board );
			
			var hand1:Hand = new Hand();
			hand1 = player1.chosenCards;
			player1.hand = hand1;

			var hand2:Hand = new Hand();
			hand2 = player2.chosenCards;
			player2.hand = hand2;
			
			var game:Game = new Game();
			game.board = board;
			game.player1 = player1;
			game.player2 = player2;
			
			player1.model = game;
			player1.colour = Colour.BLUE;
			player2.model = game;
			player2.colour = Colour.RED;
			
			return game;
		}
		
		
		private static function addRamdomBlocks(board:Board):void
		{
			var positions:ArrayList = new ArrayList();
			for(var i:int=0; i<16; i++) {
				positions.addItem( new Position( i%4, Math.floor(i/4) ) );
			}
			
			var num:int = Math.floor( Math.random()*7 );
			i = 0;
			while(i < num) {
				var position:Position = positions.removeItemAt( Math.floor( Math.random()*positions.length ) ) as Position;
				board.placeItem( position, new Block() );
				i++;
			}
		}
		
		public static function generateRandomHand(owner:PlayerBase):Array
		{
			var cards:Array = new Array();

			for(var i:int = 0; i<5; i++)
			{
				var idx:int = Math.floor(Math.random()*CardType.TYPES.length);
				var type:CardType = CardType.TYPES[idx] as CardType;
			
				cards.push( type.generateCard(owner) );
			}
			
			return cards;
		}
		
	}
}