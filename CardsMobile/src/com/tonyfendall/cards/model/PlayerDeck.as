package com.tonyfendall.cards.model
{
	import com.tonyfendall.cards.player.HumanPlayer;
	
	import mx.collections.ArrayList;
	import mx.utils.ArrayUtil;
	
	import persistance.CardDAO;
	import persistance.CardType;
	import persistance.CollectorLevelDAO;
	import persistance.HandDAO;
	
	import util.CollectorRankUtil;
	
	public class PlayerDeck
	{
		
		private var _owner:HumanPlayer;
		private var _cardsDAO:CardDAO;
		private var _handDAO:HandDAO;
		
		private var _cards:Array = [];
		private var _groups:Vector.<CardGroup>;
		private var _hand:Array = [];
		
		
		private var _level:int = 0;
		private var _levelDirty:Boolean = true;
		
		
		public function PlayerDeck(cardDAO:CardDAO, handDAO:HandDAO)
		{
			this._cardsDAO = cardDAO;
			this._handDAO = handDAO;
			
			var numTypes:int = CardType.TYPES.length;
			_groups  = new Vector.<CardGroup>(numTypes, true);

			for(var i:int=0; i<numTypes; i++) {
				_groups[i] = new CardGroup();
				_groups[i].type = CardType.TYPES[i];
			}
		}
		
		public function load(owner:HumanPlayer):void
		{
			this._owner = owner;
			_cardsDAO.getCards(_owner, _cards, _hand, _groups);
			_levelDirty = true;
		}

		
		public function getCardGroups():Vector.<CardGroup>
		{
			return _groups;
		}
		
		public function addCard(card:Card):void
		{
			_cardsDAO.insert(card);
			_cards.push(card);
			_groups[card.cardType.id].cards.addItem(card);
			_groups[card.cardType.id].known = true;
			_levelDirty = true;
		}

		public function updateCard(card:Card):void
		{
			_cardsDAO.update(card);
			_levelDirty = true;
		}
		
		public function removeCard(card:Card):void
		{
			_cardsDAO.remove(card);
			removeFromArrayList(card, _groups[card.cardType.id].cards);
			removeFromArray(card, _cards);
			removeFromArray(card, _hand);
			_levelDirty = true;
		}
		
		
		private function removeFromArray(card:Card, array:Array):void
		{
			var len:int = array.length;
			var tmp:Card;
			for(var i:int=0; i<len; i++) {
				tmp = array[i] as Card;
				
				if(tmp.id == card.id) {
					array.splice(i, 1); // remove current item
					return;
				}
			}
		}

		private function removeFromArrayList(card:Card, array:ArrayList):void
		{
			var len:int = array.length;
			var tmp:Card;
			for(var i:int=0; i<len; i++) {
				tmp = array.getItemAt(i) as Card;
				
				if(tmp.id == card.id) {
					array.removeItemAt(i);
					return;
				}
			}
		}
		
		
		public function getHand():Array
		{
			return _hand;
		}
		
		public function setHand(cards:Array):void
		{
			_hand = cards;
			
			_handDAO.removeAll();
			
			for each(var card:Card in cards)
				_handDAO.insert(card);
		}
		
		
		public function getCollectorLevel():int
		{
			if(_levelDirty) {
				_levelDirty = false;
				_level = CollectorRankUtil.getLevel(_cards);
			}
			return _level;
		}
		
		public function getNumCards():int
		{
			return _cards.length;
		}
	}
}