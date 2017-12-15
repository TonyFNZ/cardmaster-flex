package com.tonyfendall.cards.model.event
{
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.Game;
	
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		
		public static const GAME_START:String = "gameStart";
		public static const TURN_START:String = "turnStart";

		public static const TARGET_SELECTABLE:String = "targetSelectable";

		public static const TURNS_COMPELTE:String = "turnsComplete";
		
		public static const PRIZE_SELECTABLE:String = "prizeSelectable";
		public static const PRIZE_SELECTED:String = "prizeReviewable";
		
		public static const GAME_COMPLETE:String = "gameComplete";
		
		
		public var game:Game;
		public var card:Card;
		
		public function GameEvent(type:String, game:Game, card:Card=null)
		{
			super(type, false, false);
			this.game = game;			
			this.card = card;			
		}
	}
}