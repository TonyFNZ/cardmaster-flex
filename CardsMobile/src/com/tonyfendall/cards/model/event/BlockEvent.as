package com.tonyfendall.cards.model.event
{
	import com.tonyfendall.cards.model.Block;
	
	import flash.events.Event;
	
	public class BlockEvent extends Event
	{
		
		public static const PLACED:String = "blockPlaced";
		
		public var block:Block;
		
		public function BlockEvent(type:String, block:Block)
		{
			super(type, false, false);
			this.block = block;
		}
	}
}