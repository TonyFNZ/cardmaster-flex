package com.tonyfendall.cards.player.supportClasses
{
	import com.tonyfendall.cards.controller.util.GameSetupUtil;
	import com.tonyfendall.cards.model.Board;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.Game;
	import com.tonyfendall.cards.model.Hand;
	import com.tonyfendall.cards.model.Item;
	import com.tonyfendall.cards.model.event.GameEvent;
	import com.tonyfendall.cards.model.util.CardAttack;
	import com.tonyfendall.cards.model.util.Direction;
	import com.tonyfendall.cards.model.util.Position;
	
	import flash.net.getClassByAlias;
	import flash.utils.setTimeout;
	
	import persistance.CardType;
	
	public class AIPlayer extends PlayerBase
	{
		
		private var _name:String;
		private var _ownedCardTypes:Array;
		private var lastWonCard:Card = null;
		
		
		public function AIPlayer(name:String, ownedCardTypes:Array)
		{
			_name = name;
			_ownedCardTypes = ownedCardTypes;
		}
		
		override public function set model(value:Game):void {
			if(super.model != null) {
				super.model.removeEventListener(GameEvent.TURN_START, onTurnStart);
				super.model.removeEventListener(GameEvent.TARGET_SELECTABLE, onCardsSelectable);
			}
			
			super.model = value;
			
			if(value != null) {
				value.addEventListener(GameEvent.TURN_START, onTurnStart);
				value.addEventListener(GameEvent.TARGET_SELECTABLE, onCardsSelectable);
				value.addEventListener(GameEvent.PRIZE_SELECTABLE, onPrizeSelectable);
			}
		}
		
		
		override public function get chosenCards():Hand
		{
			var hand:Hand = new Hand();
			
			if(lastWonCard != null)
				hand.addCard(lastWonCard);
			
			while(hand.size < 5) {
				var type_id:int = _ownedCardTypes[ Math.floor(Math.random()*_ownedCardTypes.length) ];
				var type:CardType = CardType.TYPES[type_id];
				var card:Card = type.generateCard(this);
				hand.addCard( card );
			}
			
			return hand;
		}
		
		override public function get name():String
		{
			return _name;
		}
		
		
		override public function receiveCard(card:Card):void
		{
			lastWonCard = card;
			lastWonCard.originalOwner = this;
			lastWonCard.currentOwner = this;
		}
		
		override public function loseCard(card:Card):void
		{
			if(card == lastWonCard)
				lastWonCard = null;
		}
		

		private function onTurnStart(event:GameEvent):void
		{
			if(_model.activePlayer != this)
				return;
			
			trace("AI player is about to play a move");
			
			var board:Board = _model.board;
			var chosenMove:Move;
			
			if(board.cardsPlayed == 0) {
				chosenMove = getBestNonAttackingMove(board);
				
			} else {
				 var m:Move = getBestAttackingMove(board);
				 
				 if(m.card == null)
					chosenMove = getBestNonAttackingMove(board);
				 else
					chosenMove = m;
			}
				
			// Call back to controller
			setTimeout(	controller.playMove, 1000, hand, chosenMove.card, chosenMove.position);
			trace("AI player has played a move");
		}
		
		
		private function getBestAttackingMove(board:Board):Move
		{
			var chosenCard:Card;
			var chosenPosition:Position;
			var chanceOfSuccess:Number = 0.4;
			
			var p:Position;
			
			for(var i:int=0; i<hand.size; i++) {
				var card:Card = hand.getCard(i);
				
				for(var x:int = 0; x<4; x++) {
					for(var y:int = 0; y<4; y++) {
						// For every card in every position
						
						p = new Position(x, y);
						
						if( board.getItemAt(p) != null )
							continue;
						
						var lines:Array = card.getLinesOfAttack(board, false, p);
						
						if(lines.length == 0)
							continue;
						
						var chance:Number = 1;
						for each(var line:CardAttack in lines) {
							chance *=  line.chanceToWin;
						}
						
						if(chance > chanceOfSuccess) {
							chosenCard = card;
							chosenPosition = p;
							chanceOfSuccess = chance;
						}
					}
				}		
			}
			
			var m:Move = new Move();
				m.card = chosenCard;
				m.position = chosenPosition;
				m.weight = chanceOfSuccess;
			return m;
		}
		
		private function getBestNonAttackingMove(board:Board):Move
		{
			var chosenCard:Card;
			var chosenPosition:Position;
			var weight:Number = -100;
			
			var p:Position;
			
			for(var i:int=0; i<hand.size; i++) {
				var card:Card = hand.getCard(i);
				
				for(var x:int = 0; x<4; x++) {
					for(var y:int = 0; y<4; y++) {
						// For every card in every position
						
						p = new Position(x, y);
						var w:Number = 0;
						
						if( board.getItemAt(p) != null )
							continue;
						
						for(var j:int=0; j<8; j++) {
							var d:uint = Direction.LIST[j];
							var p2:Position = board.getPosisionFrom(p, d);
							
							var item:Item = board.getItemFrom(p, d);
							
							if( (card.arrows & d) > 0 ) {
								// Card has this arrow
								
								if( board.canPlace(p2) )
									w += 2;
								else
									w -= 1;
									
							} else {
								// Card does not have this arrow
								if( board.canPlace(p2) )
									w -= 2;
								else
									w += 1;
									
							}
						}
						
						if( w > weight ) {
							chosenCard = card;
							chosenPosition = p;
							weight = w;
						}
						
					}
				}
			}
			
			trace(chosenPosition, weight);
			var m:Move = new Move();
				m.card = chosenCard;
				m.position = chosenPosition;
				m.weight = weight;

			return m;
		}
		
		
		private function firstEmptyPosition(board:Board):Position
		{
			var position:Position;
			
			for(var x:int = 0; x<4; x++) {
				for(var y:int = 0; y<4; y++) {
					position = new Position(x, y);
					
					if( board.getItemAt(position) == null )
						return position;
				}
			}
			
			return null;
		}
		
		private function chanceToWin(attackPower:String, defensePower:String):Number
		{
			var a:Number = parseInt(attackPower, 16);
			var d:Number = parseInt(defensePower, 16);
			a = (a * 16) + 7.5; // middle of the possible hp range
			d = (d * 16) + 7.5;
			
			var swap:Boolean = false;
			if(a < d) {
				swap = true;
				var b:Number = a;
				a = d;
				d = b;
			}
			
			// 			     1 + Power of Weak
			// 100 * (1 -  ----------------------)
			//             2*(1+ Power of Strong)
			
			var c:Number = 1 - ( (1 + d)/(2 + 2*a) );
			
			if(swap)
				return 1 - c;
			else
				return c;
		}
		
		
		private function onCardsSelectable(event:GameEvent):void
		{
			if(_model.activePlayer != this)
				return;
			
			trace("AI player is about to select a card");
			
			var fights:Array = _model.board.currentlySelectableFights;
			var len:int = fights.length;
			
			var card:Card = fights[ Math.floor( len*Math.random() ) ].target;
			
			// Call back to controller
			setTimeout(controller.cardSelected, 1000, card);
			trace("AI player has selected a card");
		}
		
		
		private function onPrizeSelectable(event:GameEvent):void
		{
			if(_model.winningPlayer != this)
				return;
			
			var losingPlayer:PlayerBase = _model.losingPlayer;
			
			trace("AI player is about to select a prize");
			
			// Both players hands are empty now, so infer their hand from card.original owner
			
			var bestCard:Card = null;
			var bestWeight:int = -1;
			
			var items:Array = _model.board.items;
			
			for(var i:int=0; i<items.length; i++) {
				var card:Card = items[i] as Card;
				
				if(card == null || card.originalOwner == this || card.currentOwner != this)
					continue;
				
				var weight:int = (card.attack+1) * getNumArrows(card.arrows);
				
				if(weight > bestWeight) {
					bestCard = card;
					bestWeight = weight;
				}
			}
			
			controller.prizeChosen(bestCard);
		}
		
		
		private function getNumArrows(arrows:uint):int
		{
			var num:int = 0;
			while(arrows > 0) {
					
				if( (arrows & 1) == 1 ) {
					num++;
				}

				arrows >>= 1;
			}
			
			return num;
		}
			
	}
}