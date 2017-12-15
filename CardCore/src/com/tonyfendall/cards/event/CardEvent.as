package com.tonyfendall.cards.event
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.core.CardAttack;
	
	import flash.events.Event;
	
	public class CardEvent extends Event
	{
		
		public static const PLACED:String = "cardPlaced";

		public static const FIGHT_START:String = "fightStart";
		public static const FIGHT_EXECUTE:String = "fightExecute";
		public static const FIGHT_COMPLETE:String = "fightComplete";

		public static const SELECTABLE:String = "selectable";
		public static const UNSELECTABLE:String = "unselectable";

		public static const COLOUR_CHANGE:String = "colourChange";
		public static const TYPE_CHANGE:String = "typeChange";
		
		public static const DIM:String = "dim";
		public static const UNDIM:String = "undim";
		
		
		
		public var card:Card; // TODO could replace this with this.target?
		
		public var attack:CardAttack;
		
		public var wasComboed:Boolean = false;
		
		public function CardEvent(type:String, card:Card, attack:CardAttack = null)
		{
			super(type, false, false);
			this.card = card;
			this.attack = attack;
		}
	}
}