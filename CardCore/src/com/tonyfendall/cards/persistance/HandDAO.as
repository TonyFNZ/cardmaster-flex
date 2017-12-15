package com.tonyfendall.cards.persistance
{
	import com.tonyfendall.cards.core.Card;

	public interface HandDAO
	{
	
		function insert(card:Card):Boolean;
		
		function removeAll():Boolean;
		
	}
}