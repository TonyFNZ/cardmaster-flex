package com.tonyfendall.cards.screens
{
	import com.tonyfendall.cards.components.CardView;
	import com.tonyfendall.cards.core.Card;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.layout.TiledRowsLayout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class HandSelectScreen extends DeckScreen
	{
		
		protected var playButton:Button;

		protected var hand:Array = [null, null, null, null, null]; // length 5
		
		protected var hv0:CardView;
		protected var hv1:CardView;
		protected var hv2:CardView;
		protected var hv3:CardView;
		protected var hv4:CardView;
		
		
		public function HandSelectScreen()
		{
			super();
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			
			playButton = new Button();
			playButton.label = "Play";
			playButton.addEventListener(Event.TRIGGERED, onPlayButton);
			
			this.header.rightItems = new <DisplayObject>[ this.playButton ];
			
			list.addEventListener("itemClick", onItemClick);
			
			var tmp:Array = deck.getHand();
			for(var i:int=0; i<tmp.length; i++) {
				hand[i] = tmp[i];
				list.dataProvider.removeItem( tmp[i] ); // cards in hand shouldn't be in card list
			}
			
			hv0 = new CardView();
			hv0.addEventListener(TouchEvent.TOUCH, onHandCardTouch);
			this.addChild(hv0);
			hv1 = new CardView();
			hv1.addEventListener(TouchEvent.TOUCH, onHandCardTouch);
			this.addChild(hv1);
			hv2 = new CardView();
			hv2.addEventListener(TouchEvent.TOUCH, onHandCardTouch);
			this.addChild(hv2);
			hv3 = new CardView();
			hv3.addEventListener(TouchEvent.TOUCH, onHandCardTouch);
			this.addChild(hv3);
			hv4 = new CardView();
			hv4.addEventListener(TouchEvent.TOUCH, onHandCardTouch);
			this.addChild(hv4);
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid) {
				hv0.card = hand[0];
				hv1.card = hand[1];
				hv2.card = hand[2];
				hv3.card = hand[3];
				hv4.card = hand[4];
			}
			
			super.draw();
		}

		
		override protected function updateLayout():void
		{
			header.width = this.actualWidth;
			header.validate();
			
			pageIndicator.width = this.actualWidth;
			pageIndicator.validate();
			pageIndicator.y = this.actualHeight - pageIndicator.height - 230;
			
			list.y = header.height;
			list.width = this.actualWidth;
			list.height = this.actualHeight - header.height - pageIndicator.height - 230;
			
			const layout:TiledRowsLayout = TiledRowsLayout(list.layout);
			layout.paddingTop = layout.paddingBottom = (list.height % 116)/2;
			layout.paddingRight = layout.paddingLeft = 0;
			layout.gap = 0;
			
			list.validate();
			
			pageIndicator.pageCount = list.horizontalPageCount;
			
			
			hv0.x = 70;
			hv0.y = this.actualHeight - 220;
			hv1.x = 190;
			hv1.y = this.actualHeight - 220;
			hv2.x = 310;
			hv2.y = this.actualHeight - 220;

			hv3.x = 130;
			hv3.y = this.actualHeight - 110;
			hv4.x = 250;
			hv4.y = this.actualHeight - 110;
		}
		
		
		protected function onItemClick(event:Event):void
		{
			for(var i:int=0; i<5; i++) {
				if(hand[i] == null)
					break;
			}
			
			if(i >= 5)
				return; // hand is full
			
			var card:Card = list.dataProvider.removeItemAt(event.data as Number) as Card;
			
			pageIndicator.pageCount = list.horizontalPageCount;
			
			hand[i] = card;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		
		protected function onHandCardTouch(event:TouchEvent):void
		{
			var index:int = -1;
			var touch:Touch;
			
			touch = event.getTouch(hv0);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				index = 0;

			touch = event.getTouch(hv1);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				index = 1;

			touch = event.getTouch(hv2);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				index = 2;

			touch = event.getTouch(hv3);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				index = 3;

			touch = event.getTouch(hv4);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				index = 4;

			if(index == -1)
				return;
			
			var card:Card = hand[index];
			hand[index] = null;
			this.invalidate(INVALIDATION_FLAG_DATA);

			var cards:Array = list.dataProvider.data as Array;
			for(var i:int=0; i<cards.length; i++) {
				if(cards[i].cardType.id >= card.cardType.id)
					break;
			}
			
			list.dataProvider.addItemAt(card, i);
		}
		
		
		
		protected function onPlayButton(e:Event):void
		{
			for(var i:int=0; i<5; i++) {
				if(hand[i] == null)
					break;
			}
			
			if(i < 5) {
				// hand isn't full
				var label:Label = new Label();
				label.text = "Please select 5 cards first";
				Callout.show( label, playButton );
				return;
			}
			
			
			deck.setHand(hand);
			
			this.dispatchEventWith("play"); // show game screen
		}
		
	}
}