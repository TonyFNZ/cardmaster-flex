package com.tonyfendall.cards.core
{
	import com.tonyfendall.cards.enum.Direction;
	import com.tonyfendall.cards.enum.Position;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Board extends EventDispatcher
	{
		
		public static const STATE_NORMAL:String = "Normal";
		public static const STATE_PLAYABLE:String = "Playable";
		
		public var state:String = STATE_NORMAL;

		
		private static const WIDTH:Number = 4;
		private static const HEIGHT:Number = 4;

		// Cards and Blocks currently on the board
		public var items:Array = new Array(16);
		
		
		// Card references when user needs to select which card to attack
		public var currentlySelectableFights:Array = [];

		
		public var cardsPlayed:int = 0;
		
		
		public function Board()
		{
		}
		
		
		public function placeItem(p:Position, item:Item):void
		{
			var index:int = index(p);
			items[index] = item;

			item.position = p;
			
			if(item is Card) {
				trace("Placed a Card");
				cardsPlayed += 1;
			} else
				trace("Placed a Block");
				
			dispatchEvent(new Event("cardsChanged"));
		}
		
		public function canPlace(p:Position):Boolean
		{
			if( isOutOfBounds(p) )
				return false;
			
			var index:int = index(p);
			return ( items[index] == null );
		}

		public function getItemAt(p:Position):Item
		{
			var index:int = index(p);
			return items[index];
		}
		
		
		public function getItemFrom(p:Position, direction:uint):Item
		{
			var p2:Position = getPosisionFrom(p, direction);
			
			if( isOutOfBounds(p2) )
				return null;
			
			return getItemAt(p2);
		}

		
		
		public function isOutOfBounds(p:Position):Boolean
		{
			if(p.x < 0 || p.x > WIDTH-1)
				return true;
			if(p.y < 0 || p.y > HEIGHT-1)
				return true;
			
			return false;
		}

		private function index(p:Position):int
		{
			return p.y*WIDTH + p.x;
		}
		
		public function getPosisionFrom(start:Position, direction:uint):Position
		{
			var end:Position = new Position(start.x, start.y);
			
			switch(direction) {
				case Direction.NW:
				case Direction.W:
				case Direction.SW:
					end.x--;
					break;
				
				case Direction.NE:
				case Direction.E:
				case Direction.SE:
					end.x++;
					break;
			}
			
			switch(direction) {
				case Direction.NW:
				case Direction.N:
				case Direction.NE:
					end.y--;
					break;
				
				case Direction.SW:
				case Direction.S:
				case Direction.SE:
					end.y++;
					break;
			}
			
			return end;
		}
		
	}
}