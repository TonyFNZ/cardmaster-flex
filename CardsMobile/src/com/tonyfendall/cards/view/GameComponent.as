package com.tonyfendall.cards.view
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.model.Board;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.CardGroup;
	import com.tonyfendall.cards.model.Game;
	import com.tonyfendall.cards.model.event.BlockEvent;
	import com.tonyfendall.cards.model.event.CardEvent;
	import com.tonyfendall.cards.model.event.GameEvent;
	import com.tonyfendall.cards.model.util.Colour;
	import com.tonyfendall.cards.model.util.Position;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.core.UIComponent;
	
	import org.osmf.layout.ScaleMode;
	
	import persistance.CardImages;
	
	import spark.components.Image;
	import spark.components.View;
	
	import views.components.Prompt;
	import views.hand.HandSelectView;
	
	public class GameComponent extends UIComponent
	{
		private var _boardLeft:Number = 0;
		private var _cellWidth:Number = 0;
		private var _cellHeight:Number = 0;

		private var _handCardWidth:Number = 0;
		private var _handCardHeight:Number = 0;
		
		private var _humanHandViews:Vector.<ActiveCardView> = new Vector.<ActiveCardView>(5,true);
		private var _aiHandViews:Vector.<ActiveCardView>    = new Vector.<ActiveCardView>(5,true);
		private var _blockViews:Vector.<BlockView>			= new Vector.<BlockView>();

		private var _board:Image;
		
		private var _model:Game;
		private var _modelChanged:Boolean = false;
		
		private var _controller:GameController;
		private var _controllerChanged:Boolean = false;
		
		public var parentView:View;
		
		
		public function GameComponent()
		{
			super();
			
			this.setFocus();
			
			this.addEventListener(MouseEvent.CLICK, onBoardClick);
		}
		
		
		public function set model(value:Game):void
		{
			if(_model != null) {
				_model.removeEventListener(GameEvent.GAME_START, onGameStart);

				_model.removeEventListener(CardEvent.PLACED, onCardPlaced);
				_model.removeEventListener(BlockEvent.PLACED, onBlockPlaced);
				
				_model.removeEventListener(GameEvent.PRIZE_SELECTABLE, onPrizeSelectable);
				_model.removeEventListener(GameEvent.PRIZE_SELECTED, onPrizeChosen);
				
				_model.removeEventListener(GameEvent.TURNS_COMPELTE, onTurnsCompelte);
				_model.removeEventListener(GameEvent.GAME_COMPLETE, onGameCompelete);
			}
				
			_model = value;
			_modelChanged = true;
			
			if(_model != null) {
				_model.addEventListener(GameEvent.GAME_START, onGameStart);

				_model.addEventListener(CardEvent.PLACED, onCardPlaced);
				_model.addEventListener(BlockEvent.PLACED, onBlockPlaced);
				
				_model.addEventListener(GameEvent.PRIZE_SELECTABLE, onPrizeSelectable);
				_model.addEventListener(GameEvent.PRIZE_SELECTED, onPrizeChosen);
				
				_model.addEventListener(GameEvent.TURNS_COMPELTE, onTurnsCompelte);
				_model.addEventListener(GameEvent.GAME_COMPLETE, onGameCompelete);
				
			}
			
			invalidateProperties();
		}
		
		public function set controller(value:GameController):void
		{
			_controller = value;
			_controllerChanged = true;
			
			invalidateProperties();
		}
		
		
		private function onGameStart(event:GameEvent):void
		{
			trace("Game Started");
			var indicator:BlankRect = new BlankRect();
			if(_model.activePlayer.colour == Colour.BLUE)
				indicator.colour = 0x0000FF;
			else
				indicator.colour = 0xFF0000;
			
			indicator.width = 200;
			indicator.height = 200;
			indicator.x = (this.width - indicator.width)/2;
			indicator.y = (this.height - indicator.height)/2;
			
			this.addChild(indicator);
			
			TweenLite.to(indicator, 0.6, {delay:0.2, alpha:0, onComplete: this.removeChild, onCompleteParams:[indicator]} );
		}
		
		private function onCardPlaced(event:CardEvent):void
		{
			var card:Card = event.card;
			trace("Card Placed: "+card.position);

			var cardView:ActiveCardView = getViewForCard(card);
			
			if(cardView == null)
				return;
			
			//cardView.faceup = true;
			
			var p:Point = new Point();
			getBoardTileXYFromPosition(event.card.position, p);
			
			// Bring to front
			this.removeChild(cardView);
			this.addChild(cardView);
			
			cardView.faceup = true;

			// Slide into position
			TweenLite.to(cardView, 0.6, {x:p.x, y:p.y, width:_cellWidth, height:_cellHeight, onComplete:onCardMoveComplete, onCompleteParams:[cardView]} );
		}
		

		private function onCardMoveComplete(cardView:ActiveCardView):void
		{
			trace("Card Move Complete");
		}
		
		
		private function onBlockPlaced(event:BlockEvent):void
		{
			var p:Point = new Point();
			getBoardTileXYFromPosition(event.block.position, p);

			var blockView:BlockView = new BlockView();
				blockView.x = p.x - _cellWidth*0.5;
				blockView.y = p.y - _cellHeight*1.5;
				blockView.width = _cellWidth*2;
				blockView.height = _cellHeight*2;
			
			this.addChild(blockView);
			_blockViews.push(blockView);
			
			// Slide into position
			TweenLite.to(blockView, 0.5, {x:p.x, y:p.y, width:_cellWidth, height:_cellHeight,  ease:Quad.easeIn} );
		}
		
		
		private var resultDisplay:ImageDisplay;
		
		private function onTurnsCompelte(event:GameEvent):void
		{
			trace("turns complete");
			var winner:PlayerBase = event.game.winningPlayer;

			resultDisplay = new ImageDisplay();
			if(winner == null)
				resultDisplay.image = CardImages.DRAW;
			else if(winner is HumanPlayer)
				resultDisplay.image = CardImages.WIN;
			else
				resultDisplay.image = CardImages.LOSE;

			resultDisplay.x = (width-resultDisplay.width)/2;
			resultDisplay.y = (height-resultDisplay.height)/2;
			resultDisplay.alpha = 0;
			
		
			this.addChildAt(resultDisplay, 0); // add this below sliding cards
			TweenLite.to(resultDisplay, 1, {alpha:1} );
			
			
			var i:int;
			
			// Remove blocks
			for(i=0; i<_blockViews.length; i++) {
				this.removeChild(_blockViews[i]);
			}
			// Remove board
			this.removeChild( _board );
			
			
			// Slide cards back
			var p:Point = new Point();
			for(i=0; i<5; i++) {
				getHumanHandXY(i, p);
				TweenLite.to(_humanHandViews[i], 2, {x:p.x, y:p.y, width:_handCardWidth, height:_handCardHeight} );
			}
			for(i=0; i<5; i++) {
				getAIHandXY(i, p);
				TweenLite.to(_aiHandViews[i], 2, {x:p.x, y:p.y, width:_handCardWidth, height:_handCardHeight} );
			}
		}
		
		
		private var _selectPrizePrompt:Prompt;
		private function onPrizeSelectable(event:GameEvent):void
		{
			if(_model.winningPlayer != _model.player1)
				return;
			
			_selectPrizePrompt = new Prompt();
			_selectPrizePrompt.x = (width - _selectPrizePrompt.width)/2;
			_selectPrizePrompt.y = height - _selectPrizePrompt.height;
			_selectPrizePrompt.text = "Select Prize";
			_selectPrizePrompt.alpha = 0;
			this.addChild(_selectPrizePrompt);
			
			TweenLite.to(_selectPrizePrompt, 0.5, {alpha:1});
		}
		
		
		
		private function onPrizeChosen(event:GameEvent):void
		{
			if(_selectPrizePrompt != null) {
				this.removeChild(_selectPrizePrompt);
				_selectPrizePrompt = null;
			}
			
			if(resultDisplay != null) {
				this.removeChild(resultDisplay);
				resultDisplay = null;
			}
			
			trace("prize chosen");
			var prize:Card = event.card;
			var prizeView:ActiveCardView = getViewForCard(prize);
			
			var middle:Point = new Point((width-_cellWidth)/2, (height-_cellHeight)/2);
			
			var destination:Point = new Point();
			if(prize.currentOwner == _model.player1)
				getHumanHandXY(2,destination);
			else
				getAIHandXY(2,destination);
			
			
			var prizeSlide:TimelineLite = new TimelineLite({onComplete: prizeSlideComplete, onCompleteParams:[prizeView]});
				prizeSlide.to(prizeView, 0.5, {x:middle.x, y:middle.y, width:_cellWidth, height:_cellHeight} );
				prizeSlide.to(prizeView, 0.5, {delay:1, x:destination.x, y:destination.y, width:_handCardWidth, height:_handCardHeight} );
				prizeSlide.play();
			
			
			var groups:Vector.<CardGroup> = Globals.globals.deck.getCardGroups();
			var noticeDisplay:ImageDisplay;
			var noticeSlide:TimelineLite;
			var off1:Number;
			var off2:Number;
			
			if(prize.currentOwner == _model.player1 && groups[prize.cardType.id].cards.length == 0) {
				// New Card
				noticeDisplay = new ImageDisplay();
				noticeDisplay.image = CardImages.NEWCARD;
				noticeDisplay.alpha = 0;

				off1 = (noticeDisplay.width - _handCardWidth)/2;
				off2 = (noticeDisplay.width - _cellWidth)/2;
				noticeDisplay.x = prizeView.x - off1;
				noticeDisplay.y = prizeView.y + prizeView.height;
				this.addChild(noticeDisplay);
				
				noticeSlide = new TimelineLite({onComplete: this.removeChild, onCompleteParams:[noticeDisplay]});
				noticeSlide.to(noticeDisplay, 0.5, {x:(middle.x - off2), y:(middle.y+_cellHeight), alpha:1} );
				noticeSlide.to(noticeDisplay, 0.5, {delay:1, x:(destination.x-off1), y:(destination.y+_handCardHeight), alpha:0} );
			}
			if(prize.currentOwner != _model.player1 && groups[prize.cardType.id].cards.length == 1) {
				// New Card
				noticeDisplay = new ImageDisplay();
				noticeDisplay.image = CardImages.LASTONE;
				noticeDisplay.alpha = 0;
				
				off1 = (noticeDisplay.width - _handCardWidth)/2;
				off2 = (noticeDisplay.width - _cellWidth)/2;
				noticeDisplay.x = prizeView.x - off1;
				noticeDisplay.y = prizeView.y + prizeView.height;
				this.addChild(noticeDisplay);
				
				noticeSlide = new TimelineLite({onComplete: this.removeChild, onCompleteParams:[noticeDisplay]});
				noticeSlide.to(noticeDisplay, 0.5, {x:(middle.x - off2), y:(middle.y+_cellHeight), alpha:1} );
				noticeSlide.to(noticeDisplay, 0.5, {delay:1, x:(destination.x-off1), y:(destination.y+_handCardHeight), alpha:0} );
			}
			
			if(noticeSlide != null)
				noticeSlide.play();
			
			
			var msg:String;
			if(prize.currentOwner == _model.player1) // human player
				msg = "Received "+prize.cardType.name;
			else
				msg = "Lost "+prize.cardType.name;
			
			var prompt:Prompt = new Prompt();
			prompt.x = (width - prompt.width)/2;
			prompt.y = height - prompt.height;
			prompt.text = msg;
			prompt.alpha = 0;
			this.addChild(prompt);
			
			var promptFade:TimelineLite = new TimelineLite({onComplete: this.removeChild, onCompleteParams:[prompt]});
			promptFade.to(prompt, 0.25, {alpha:1});
			promptFade.to(prompt, 0.25, {delay:1.5, alpha:0});
		}
		
		private function prizeSlideComplete(prizeView:ActiveCardView):void
		{
			trace("Complete");
			this.removeChild( prizeView );
			
			_controller.prizeReceived();
		}

		
		public function onBackKeyPressed():void
		{
			if(_playagainPopup != null)
				_playagainPopup.close();
			
			_playagainPopup = null;
			// About to navigate away from this view
		}
		
		
		private var _playagainPopup:PlayAgainPopup;
		
		private function onGameCompelete(event:GameEvent):void
		{
			if(resultDisplay != null) {
				this.removeChild(resultDisplay);
				resultDisplay = null;
			}
			
			_playagainPopup = new PlayAgainPopup();
			_playagainPopup.show(this, onPlayAgainSelected);
		}
		
		private function onPlayAgainSelected(again:Boolean):void
		{
			_playagainPopup = null;
			
			if(again == false) {
				parentView.navigator.popToFirstView();
			} else {
				parentView.navigator.replaceView(HandSelectView);
			}
		}
		
		
		private function onBoardClick(event:MouseEvent):void
		{
			if(_model.board.state != Board.STATE_PLAYABLE)
				return;
			
			// tell the game controller where we were clicked
			var local:Point = globalToLocal(new Point(event.stageX, event.stageY));
			
			var cx:int = Math.floor((local.x-_boardLeft)/(4*_cellWidth) * 4);
			var cy:int = Math.floor( local.y / (4*_cellHeight) * 4 );
			
			if(cx > 3 || cy > 3)
				return;
			
			var position:Position = new Position(cx, cy);
			
			if( _model.board.getItemAt(position) != null)
				return; // ignore clicks on existing items
			
			trace("ON BOARD CLICKED");
			
			_controller.boardClicked( position );
		}

		private function onCardClick(event:MouseEvent):void
		{
			var cardView:ActiveCardView = event.currentTarget as ActiveCardView;
			var card:Card = cardView.card;
			
			if(!card)
				return; // ignore views with no card (should never happen)
			
			trace("ON CARD CLICKED");
			
			if(_model.turnsComplete) 
			{
				if( card.currentOwner == _model.player1 ) {
					_controller.prizeChosen( card );
				}
			}
			else if(card.position) 
			{
				if(card.state == Card.STATE_SELECTABLE) {
					// Tell game controller we have been selected
					_controller.cardSelected( card );
				}
			} 
			else 
			{
				if(card.originalOwner is HumanPlayer) {
					_controller.handCardSelect(card);
				}
			}
			
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			//trace("GAME VIEW CREATE CHILDREN");

			
			_board = new Image();
			_board.source = "assets/gfx/board.png";
			_board.mouseEnabled = false;
			_board.scaleMode = ScaleMode.STRETCH;
			this.addChild(_board);

			
			var i:int;
			var cardView:ActiveCardView;
			
			for(i=0; i<5; i++) {
				cardView = new ActiveCardView();
				cardView.faceup = false;
				_aiHandViews[i] = cardView;
				cardView.addEventListener(MouseEvent.CLICK, onCardClick);
				this.addChild(cardView);
			}

			for(i=0; i<5; i++) {
				cardView = new ActiveCardView();
				_humanHandViews[i] = cardView;
				cardView.addEventListener(MouseEvent.CLICK, onCardClick);
				this.addChild(cardView);
			}

		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_modelChanged) {
				_modelChanged = false;
				
				var i:int;
				
				for(i=0; i<5; i++) {
					_humanHandViews[i].card = _model.player1.hand.getCard(i);
				}

				for(i=0; i<5; i++) {
					_aiHandViews[i].card = _model.player2.hand.getCard(i);
				}
			}
			
			
			if(_controller) {
				_controllerChanged = false;
				
				for(i=0; i<5; i++) {
					_humanHandViews[i].controller = _controller;
				}
				
				for(i=0; i<5; i++) {
					_aiHandViews[i].controller = _controller;
				}
			}
		}
		
		
		private var _prevW:Number;
		private var _prevH:Number;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			
			if(_prevW != unscaledWidth || _prevH != unscaledHeight) 
			{
				_prevW = unscaledWidth;
				_prevH = unscaledHeight;
				
				// Draw Background
				var m:Matrix = new Matrix();
				m.createGradientBox(unscaledWidth,unscaledHeight);
				
				var g:Graphics = this.graphics;
				g.clear();
				g.beginGradientFill(GradientType.RADIAL, [0xCCCCCC, 0xBBBBBB, 0x999999], [1,1,1], [0,127,255], m);
				g.drawRect(0,0,unscaledWidth,unscaledHeight);
				g.endFill();
			}
			
			if(!_model.gameStarted) {
				// Since we're on a mobile device the window should never resize (apart from a few blips in the first few ms)
				
				calculateSizes(unscaledWidth, unscaledHeight);
				
				
				var i:int;
				var cardView:ActiveCardView;
				var p:Point = new Point();
				
				for(i=0; i<5; i++) {
					cardView = _humanHandViews[i];
					
					if(cardView.card && cardView.card.position) {
						getBoardTileXYFromPosition(cardView.card.position, p);
						cardView.x = p.x;
						cardView.y = p.y;
						cardView.width = _cellWidth;
						cardView.height = _cellHeight;
					} else {
						getHumanHandXY(i, p);
						cardView.x = p.x;
						cardView.y = p.y;
						cardView.width = _handCardWidth;
						cardView.height = _handCardHeight;
					}
				}
				
				
				for(i=0; i<5; i++) {
					cardView = _aiHandViews[i];
					cardView.width = _cellWidth;
					cardView.height = _cellHeight;
					
					if(cardView.card && cardView.card.position) {
						getBoardTileXYFromPosition(cardView.card.position, p);
						cardView.x = p.x;
						cardView.y = p.y;
						cardView.width = _cellWidth;
						cardView.height = _cellHeight;
					} else {
						getAIHandXY(i, p);
						cardView.x = p.x;
						cardView.y = p.y;
						cardView.width = _handCardWidth;
						cardView.height = _handCardHeight;
					}
				}

			
				getBoardTileXY(0, p);
				_board.x = p.x;
				_board.y = p.y;
				_board.width = _cellWidth*4;
				_board.height = _cellHeight*4;
				
			}
		}
		
		
		private function calculateSizes(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var minHandSize:Number = unscaledWidth * 0.15;
			var targetHandSize:Number = unscaledHeight / 5;
			
			_handCardWidth = Math.min( targetHandSize, minHandSize);
			_handCardHeight = _handCardWidth;
			
			var maxCellSize:Number = unscaledWidth * 0.7;
			var targetCellSize:Number = unscaledHeight / 4;
			
			_cellWidth = Math.min( targetCellSize, maxCellSize);
			_cellHeight = _cellWidth;
			
			_boardLeft = (unscaledWidth - 4*_cellWidth) /2;
		}
		
		
		
		private function getHumanHandXY(index:int, returnPoint:Point):void
		{
			returnPoint.x = width - _handCardWidth;
			returnPoint.y = index * _handCardHeight;
		}

		private function getAIHandXY(index:int, returnPoint:Point):void
		{
			returnPoint.x = 0;
			
			if(!_model || !_model.turnsComplete)
				returnPoint.y = index * _handCardHeight * 0.5;
			else
				returnPoint.y = index * _handCardHeight;
		}
		
		private function getBoardTileXY(index:int, returnPoint:Point):void
		{
			var p:Position = new Position(index%4, index/4);
			getBoardTileXYFromPosition(new Position(index%4, index/4), returnPoint);
		}

		private function getBoardTileXYFromPosition(position:Position, returnPoint:Point):void
		{
			returnPoint.x = _boardLeft + position.x*_cellWidth;
			returnPoint.y = position.y * _cellHeight;
		}
		
		private function getCenterXY():Point
		{
			return new Point( (width-_cellWidth)/2, (height-_cellHeight)/2);
		}
		
		
		private function getViewForCard(card:Card):ActiveCardView
		{
			var i:int;
			
			for(i=0; i<5; i++) {
				if( _humanHandViews[i].card == card ) {
					return _humanHandViews[i];
				}
			}
			
			for(i=0; i<5; i++) {
				if( _aiHandViews[i].card == card ) {
					return _aiHandViews[i];
				}
			}
			
			return null;
		}
		
	}
}