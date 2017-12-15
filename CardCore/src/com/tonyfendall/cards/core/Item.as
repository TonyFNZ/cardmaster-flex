package com.tonyfendall.cards.core
{
	import flash.events.EventDispatcher;
	import com.tonyfendall.cards.enum.Position;

	public class Item extends EventDispatcher
	{
		
		// TODO I'm not sure whether the card should know it's own position
		// I feel like maybe the board should store this instead
		public var position:Position;  
		
		
		public function Item()
		{
		}
	}
}