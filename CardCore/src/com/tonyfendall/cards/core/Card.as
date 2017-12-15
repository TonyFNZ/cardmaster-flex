package com.tonyfendall.cards.core
{
	import com.tonyfendall.cards.enum.CardType;
	import com.tonyfendall.cards.enum.Direction;
	import com.tonyfendall.cards.enum.Position;
	import com.tonyfendall.cards.enum.Type;
	import com.tonyfendall.cards.player.PlayerBase;
	
	// Events
	[Event(name="placed", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="fightStart", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="fightExecute", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="fightComplete", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="selectable", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="unselectable", type="com.tonyfendall.cards.model.event.CardEvent")]
	[Event(name="colourChange", type="com.tonyfendall.cards.model.event.CardEvent")]
	
	public class Card extends Item
	{
		
		public static const STATE_NORMAL:String = "Normal";
		public static const STATE_FIGHTING:String = "Fighting";
		public static const STATE_SELECTABLE:String = "Selectable";
		
		public var id:int;
		public var cardType:CardType;
		
		public var state:String = STATE_NORMAL;
		
		public var selected:Boolean; // was in previous hand
		
		public var originalOwner:PlayerBase;

		public var currentOwner:PlayerBase;
		
		public var attack:uint;
		public var type:String;
		public var physDef:uint;
		public var magicDef:uint;

		public var arrows:uint;
		
		public var hp:int = 0;

		
		public function get name():String
		{
			return this.cardType.name;
		}
			
		
		public function getAttackValue():int
		{
			return getAttackOrDefenceValue(attack);
		}
		
		public function getDefenseValue(type:String):int
		{
			var def:int = 0;
			
			switch(type) {
				case Type.P:
					def = physDef;
					break;
				case Type.M:
					def = magicDef;
					break;
				case Type.X:
					def = Math.min( physDef, magicDef );
					break;
				case Type.A:
					def = Math.min( attack, physDef, magicDef );
					break;
			}

			return getAttackOrDefenceValue( def );
		}
		
		public static function getAttackOrDefenceValue(input:uint):int
		{
			var low:int = input * 16;
			var output:int = low + Math.floor(Math.random() * 15);
			return output;
		}
		
		public static function getRound2Value(round1Val:int):int
		{
			return Math.floor(Math.random() * round1Val);
		}
		
		
		public function getLinesOfAttack(board:Board, opposedOnly:Boolean, position:Position = null):Array
		{
			if(position == null)
				position = this.position;
			
			var lines:Array = new Array();
			
			for each(var arrow:uint in Direction.LIST) {
				if( (arrows & arrow) == 0 )
					continue;
				
				var item:Item = board.getItemFrom(position, arrow);
				if( item == null || !(item is Card) )
					continue;
				
				var other:Card = item as Card;
				if(other.currentOwner == this.currentOwner)
					continue;

				var line:CardAttack = new CardAttack();
				line.origin = this;
				line.target = other;
				line.direction = arrow;
				
				if(opposedOnly && !line.isOpposed)
					continue;
				
				lines.push(line);
			}
			
			return lines;
		}
		
		private function lpad(input:String, len:uint, char:String):String
		{
			var output:String = input;
			while(output.length < len) {
				output = char + output;
			}
			return output;
		}
		
		
		public function clone():Card
		{
			var output:Card = new Card();
			output.id = this.id;
			output.cardType = this.cardType;
			output.originalOwner = this.originalOwner;
			output.currentOwner = this.currentOwner;
			output.attack = this.attack;
			output.type = this.type;
			output.physDef = this.physDef;
			output.magicDef = this.magicDef;
			output.arrows = this.arrows;
			return output;
		}
		
	}
}