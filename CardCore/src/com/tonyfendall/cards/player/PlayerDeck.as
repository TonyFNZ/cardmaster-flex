package com.tonyfendall.cards.player
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.core.CardGroup;
	import com.tonyfendall.cards.enum.CardType;
	import com.tonyfendall.cards.persistance.CardDAO;
	import com.tonyfendall.cards.persistance.HandDAO;
	import com.tonyfendall.cards.util.CollectorRankUtil;
	
	public class PlayerDeck
	{
		
		private var _owner:HumanPlayer;
		private var _cardsDAO:CardDAO;
		private var _handDAO:HandDAO;
		
		private var _cards:Array = [];
		private var _groups:Array = [];
		private var _hand:Array = [];
		
		
		private var _level:int = 0;
		private var _levelDirty:Boolean = true;
		
		
		public function PlayerDeck(cardDAO:CardDAO, handDAO:HandDAO)
		{
			this._cardsDAO = cardDAO;
			this._handDAO = handDAO;
			
			var numTypes:int = CardType.TYPES.length;
			for(var i:int=0; i<numTypes; i++) {
				_groups.push(new CardGroup(CardType.TYPES[i]));
			}
		}
		
		public function load(owner:HumanPlayer):void
		{
			this._owner = owner;
			_cardsDAO.getAll(_owner, _cards, _hand, _groups);
			_levelDirty = true;
		}

		
		public function getCards():Array
		{
			return _cards;
		}
		
		public function getCardGroups():Array
		{
			return _groups;
		}
		
		public function addCard(card:Card):void
		{
			var idx:int;
			for(idx=0; idx<_cards.length; idx++) {
				if(_cards[idx].cardType.id >= card.cardType.id)
					break;
			}

			_cards.splice(idx, 0, card); // addItemAt
			
			_cardsDAO.insert(card);
			_groups[card.cardType.id].children.push(card);
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
			removeFromArray(card, _groups[card.cardType.id].children);
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