package com.tonyfendall.cards.persistance
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.player.PlayerBase;

	public interface CardDAO
	{
		
		function insert(card:Card):Boolean;
		
		function update(card:Card):Boolean;
		
		function remove(card:Card):Boolean;
		
		function getAll(owner:PlayerBase, cardsOutput:Array, handOutput:Array, groupsOutput:Array):void;
		
	}
}