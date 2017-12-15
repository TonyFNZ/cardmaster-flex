package com.tonyfendall.cards.screens
{
	import com.tonyfendall.cards.components.ActiveCardView;
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.core.Board;
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.core.Game;
	import com.tonyfendall.cards.enum.Position;
	import com.tonyfendall.cards.event.BlockEvent;
	import com.tonyfendall.cards.event.CardEvent;
	import com.tonyfendall.cards.event.GameEvent;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.PlayerBase;
	
	import flash.geom.Point;
	
	import feathers.controls.Screen;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class GameScreen extends Screen
	{
		
		private static const BOARD_X:int = 40;
		private static const BOARD_Y:int = 150;
		
		protected var boardImg:Image;
		
		protected var humanCardViews:Array = [];
		protected var aiCardViews:Array = [];
		protected var blocks:Array = [];
		
		
		private var controller:GameController;
		private var game:Game;
		
		
		public function GameScreen()
		{
			super();
			this.backButtonHandler = onBackButton;
		}
		
		
		public function setGame(controller:GameController):void
		{
			this.controller = controller;
			if(this.game != null)
				unbind(this.game);
			
			this.game = controller.game;
			
			if(this.game != null)
				bind(this.game);
			
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		
		override protected function initialize():void
		{
			boardImg = new Image(Assets.getAtlasTexture("board"));
			boardImg.x = BOARD_X;
			boardImg.y = BOARD_Y;
			boardImg.addEventListener(TouchEvent.TOUCH, onBoardTouch);
			this.addChild(boardImg);
			
			
			var i:int;
			var cardView:ActiveCardView;
			
			for(i=0; i<5; i++) {
				cardView = new ActiveCardView();
				aiCardViews.push(cardView);
				cardView.addEventListener(TouchEvent.TOUCH, onCardTouch);
				this.addChild(cardView);
			}
			
			for(i=0; i<5; i++) {
				cardView = new ActiveCardView();
				humanCardViews.push(cardView);
				cardView.addEventListener(TouchEvent.TOUCH, onCardTouch);
				this.addChild(cardView);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			
			var dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(!dataInvalid)
				return;

			if(game == null)
				return;
			
			boardImg.alpha = 1;
			
			
			var i:int;
			var card:Card;
			var cardView:ActiveCardView;
			var p:Point = new Point();
			
			for(i=0; i<5; i++) {
				card = game.player1.hand.getCard(i);
				cardView = humanCardViews[i]; 
				cardView.card = card;
				
				getHumanHandXY(i, p);
				cardView.x = p.x;
				cardView.y = p.y;
				cardView.visible = true;
			}
			for(i=0; i<5; i++) {
				card = game.player2.hand.getCard(i);
				cardView = aiCardViews[i]; 
				cardView.card = card;
				
				getAIHandXY(i, p);
				cardView.x = p.x;
				cardView.y = p.y;
				cardView.visible = true;
			}
			
			controller.beginGame();
		}
		
		
		
		private function bind(target:Game):void
		{
			target.addEventListener(GameEvent.GAME_START, onGameStart);
			
			target.addEventListener(CardEvent.PLACED, onCardPlaced);
			target.addEventListener(BlockEvent.PLACED, onBlockPlaced);
			
			target.addEventListener(GameEvent.PRIZE_SELECTABLE, onPrizeSelectable);
			target.addEventListener(GameEvent.PRIZE_SELECTED, onPrizeChosen);
			
			target.addEventListener(GameEvent.TURNS_COMPELTE, onTurnsCompelte);
			target.addEventListener(GameEvent.GAME_COMPLETE, onGameCompelete);
			
		}
		
		private function unbind(target:Game):void
		{
			target.removeEventListener(GameEvent.GAME_START, onGameStart);
			
			target.removeEventListener(CardEvent.PLACED, onCardPlaced);
			target.removeEventListener(BlockEvent.PLACED, onBlockPlaced);
			
			target.removeEventListener(GameEvent.PRIZE_SELECTABLE, onPrizeSelectable);
			target.removeEventListener(GameEvent.PRIZE_SELECTED, onPrizeChosen);
			
			target.removeEventListener(GameEvent.TURNS_COMPELTE, onTurnsCompelte);
			target.removeEventListener(GameEvent.GAME_COMPLETE, onGameCompelete);
			
		}
		
		// ----------------------------------------------------------
		// Event Handlers
		// ----------------------------------------------------------
		
		private function onCardTouch(event:TouchEvent):void
		{
			var cardView:ActiveCardView = event.currentTarget as ActiveCardView;
			var card:Card = cardView.card;
			
			if(!card)
				return; // ignore views with no card (should never happen)
			
			trace("ON CARD CLICKED");
			
			if(awaitingPrizeSelection) 
			{
				if( card.currentOwner == game.player1 && card.originalOwner != game.player1 ) {
					controller.prizeChosen( card );
					awaitingPrizeSelection = false;
				}
			}
			else if(card.position) 
			{
				if(card.state == Card.STATE_SELECTABLE) {
					// Tell game controller we have been selected
					controller.cardSelected( card );
				}
			} 
			else 
			{
				if(card.originalOwner is HumanPlayer) {
					controller.handCardSelect(card);
				}
			}
		}
		
		
		private function onBoardTouch(event:TouchEvent):void
		{
			if(game.board.state != Board.STATE_PLAYABLE)
				return;
			
			var touch:Touch = event.getTouch(boardImg);
			if(touch == null) {
				trace("board touch was null");
				return;
			}
			
			// tell the game controller where we were clicked
			var local:Point = touch.getLocation(boardImg);
			
			var cx:int = Math.floor(local.x/400 * 4);
			var cy:int = Math.floor(local.y/400 * 4 );
			var position:Position = new Position(cx, cy);
			
			if( game.board.canPlace(position) ) {
				trace("ON BOARD CLICKED");
				controller.boardClicked( position );
			}
		}
		
		
		private function onBlockPlaced(event:BlockEvent):void
		{
			var block:Image = new Image(Assets.getAtlasTexture("block"));
			block.alignPivot();
			block.x = 240;
			block.y = -100;
			block.scaleX = 1.5;
			block.scaleY = 1.5;
			
			var targetX:Number = BOARD_X + event.block.position.x*100 + 50;
			var targetY:Number = BOARD_Y + event.block.position.y*100 + 50;
			
			var slide:Tween = new Tween(block, 0.5);
			slide.scaleTo(1);
			slide.moveTo(targetX, targetY);
			
			blocks.push(block);
			this.addChild(block);
			Starling.juggler.add(slide);
		}
		
		private function onGameStart(event:GameEvent):void
		{
			trace("Game Started");
			// TODO show starting player
		}
		
		
		private function onCardPlaced(event:CardEvent):void
		{
			var card:Card = event.card;
			trace("Card Placed: "+card.position);
			
			var cardView:ActiveCardView = getViewForCard(card);
			
			if(cardView == null)
				return;
			
			var p:Point = new Point();
			getBoardTileXY(event.card.position, p);
			
			this.setChildIndex(cardView, this.numChildren-1); // Bring to front
			
			// Slide into position
			var slide:Tween = new Tween(cardView, 0.6);
			slide.moveTo(p.x, p.y);
			Starling.juggler.add(slide);
		}
		
		
		private function onTurnsCompelte(event:GameEvent):void
		{
			trace("turns complete");
			var winner:PlayerBase = event.game.winningPlayer;
			
			// TODO show result (win, lose, draw)
			
			
			// Fade board
			var fade:Tween = new Tween(boardImg, 1.5);
			fade.fadeTo(0);
			Starling.juggler.add(fade);
			
			// Remove blocks
			var block:Image;
			while(blocks.length > 0)
			{
				block = blocks.splice(0,1)[0];
				this.removeChild(block);
				block.dispose();
			}
			
			// Slide cards back
			var i:int;
			var p:Point = new Point();
			var slide:Tween;
			for(i=0; i<5; i++) {
				getHumanHandXY(i, p);
				
				slide = new Tween(humanCardViews[i], 2);
				slide.moveTo(p.x, p.y);
				Starling.juggler.add(slide);
			}
			for(i=0; i<5; i++) {
				getAIHandXYPostGame(i, p);
				
				slide = new Tween(aiCardViews[i], 2);
				slide.moveTo(p.x, p.y);
				Starling.juggler.add(slide);
			}
		}
		
		
		
		private var awaitingPrizeSelection:Boolean = false;
		
		private function onPrizeSelectable(event:GameEvent):void
		{
			if(game.winningPlayer != game.player1) // ai player won
				return;
			
			awaitingPrizeSelection = true;
			
			// TODO prompt user to select prize
		}
		
		
		private function onPrizeChosen(event:GameEvent):void
		{
			trace("prize chosen");
			var prize:Card = event.card;
			var prizeView:ActiveCardView = getViewForCard(prize);
			
			var destination:Point = new Point();
			if(prize.currentOwner == game.player1)
				getHumanHandXY(1,destination);
			else
				getAIHandXY(2,destination);
			
			this.setChildIndex(prizeView, this.numChildren-1);
			
			var slide2:Tween = new Tween(prizeView, 0.5);
			slide2.delay = 1;
			slide2.moveTo(destination.x, destination.y);
			slide2.fadeTo(0);
			slide2.onComplete = prizeSlideComplete;
			slide2.onCompleteArgs = [prizeView];
			
			var slide1:Tween = new Tween(prizeView, 0.5);
			slide1.moveTo(190, 350); // slide to middle of screen
			slide1.nextTween = slide2;
			
			Starling.juggler.add(slide1);
			
			// TODO show "card name"
			// TODO show "new card"/"last one"
		}
		
		private function prizeSlideComplete(prizeView:ActiveCardView):void
		{
			trace("Prize Slide Complete");
			prizeView.visible = false;
			
			controller.prizeReceived();
		}
		
		
		private function onGameCompelete(event:GameEvent):void
		{
			// TODO prompt user to play again
			
			this.dispatchEventWith("complete"); // return to menu screen
		}
		
		
		
		
		
		// ----------------------------------------------------------
		// Utility Functions
		// ----------------------------------------------------------
		
		private function getBoardTileXY(position:Position, returnPoint:Point):void
		{
			returnPoint.x = BOARD_X + position.x*100;
			returnPoint.y = BOARD_Y + position.y * 100;
		}
		
		private function getViewForCard(card:Card):ActiveCardView
		{
			var i:int;
			for(i=0; i<5; i++) {
				if( humanCardViews[i].card == card )
					return humanCardViews[i];
			}
			for(i=0; i<5; i++) {
				if( aiCardViews[i].card == card )
					return aiCardViews[i];
			}
			
			return null;
		}
		
		
		private function getHumanHandXY(index:int, returnPoint:Point):void
		{
			switch(index) {
				case 0:
					returnPoint.x = 70;
					returnPoint.y = this.actualHeight - 220;
					break;
				case 1:
					returnPoint.x = 190;
					returnPoint.y = this.actualHeight - 220;
					break;
				case 2:
					returnPoint.x = 310;
					returnPoint.y = this.actualHeight - 220;
					break;
				case 3:
					returnPoint.x = 130;
					returnPoint.y = this.actualHeight - 110;
					break;
				case 4:
					returnPoint.x = 250;
					returnPoint.y = this.actualHeight - 110;
					break;
			}
		}
		
		private function getAIHandXY(index:int, returnPoint:Point):void
		{
			returnPoint.x = BOARD_X + index*75;
			returnPoint.y = 20;
		}
		
		private function getAIHandXYPostGame(index:int, returnPoint:Point):void
		{
			switch(index) {

				case 0:
					returnPoint.x = 70;
					returnPoint.y = 120;
					break;
				case 1:
					returnPoint.x = 190;
					returnPoint.y = 120;
					break;
				case 2:
					returnPoint.x = 310;
					returnPoint.y = 120;
					break;
				case 3:
					returnPoint.x = 130;
					returnPoint.y = 10;
					break;
				case 4:
					returnPoint.x = 250;
					returnPoint.y = 10;
					break;
			}
		}
		
		
		protected function onBackButton(e:Event = null):void
		{
			// TODO: prompt are you sure
			this.dispatchEventWith("complete");
		}
	}
}