package com.tonyfendall.cards.screens
{
	
	import com.tonyfendall.cards.Main;
	import com.tonyfendall.cards.components.CardView;
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.enum.CardType;
	
	import flash.utils.getTimer;
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class MenuScreen extends Screen
	{
		
		private var cardView:CardView;
		
		private var buttonGroup:ButtonGroup;
		
		
		public function MenuScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			// create children		
			cardView = new CardView();
			cardView.card = getRandomCard();
			this.addChild(cardView);
			
			buttonGroup = new ButtonGroup();
			buttonGroup.dataProvider = new ListCollection(
				[
					{ label: "Quick Match", triggered: showOpponentSelect },
					{ label: "View Deck", triggered: showDeck },
					{ label: "Explosion Test", triggered: showExplosionTest }
				]);
			this.addChild(buttonGroup);
			
			
			
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function getRandomCard():Card
		{
			var main:Main = Starling.current.root as Main;

			var typeId:int = CardType.TYPES[ Math.floor(Math.random()*CardType.TYPES.length) ];
			var type:CardType = CardType.TYPES[typeId];
			return type.generateCard(main.human);
		}
		
		override protected function draw():void
		{
			cardView.scaleX = 2;
			cardView.scaleY = 2;
			cardView.x = 140;
			cardView.y = 140;
			
			this.buttonGroup.validate();
			this.buttonGroup.x = (this.actualWidth - this.buttonGroup.width) / 2;
			this.buttonGroup.y = 480 + (this.actualHeight - 480 - this.buttonGroup.height) / 2;
		}
		
		
		private function showDeck():void
		{
			this.owner.showScreen("deck");
		}

		private function showHandSelect():void
		{
			this.owner.showScreen("hand");
		}

		private function showOpponentSelect():void
		{
			this.owner.showScreen("opponent");
		}

		private function showExplosionTest():void
		{
			this.owner.showScreen("particle");
		}
		
		
		private function onEnterFrame(e:Event):void
		{
			cardView.y = 140 + (Math.cos(getTimer() * 0.002)) * 25;
		}
	}
}