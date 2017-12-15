package com.tonyfendall.cards.screens
{
	import com.tonyfendall.cards.components.CardItemRenderer;
	import com.tonyfendall.cards.components.CardView;
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.core.CardGroup;
	import com.tonyfendall.cards.core.Game;
	import com.tonyfendall.cards.player.PlayerDeck;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import com.tonyfendall.cards.Main;
	
	public class DeckScreen extends Screen
	{
		
		protected var deck:PlayerDeck;
		
		protected var header:Header;
		protected var backButton:Button;

		protected var list:List;
		protected var pageIndicator:PageIndicator;
		
		
		public function DeckScreen()
		{
			super();
			this.backButtonHandler = onBackButton;
		}
		
		
		override protected function initialize():void
		{
			var main:Main = Starling.current.root as Main;
			this.deck = main.human.deck;
			
			// clone array so that we can add/remove items without changing the underlying deck
			const cards:Array = []; 
			for each(var obj:Object in deck.getCards()) {
				cards.push(obj);
			}
			
			
			// create children	
			this.backButton = new Button();
			this.backButton.label = "Back";
			this.backButton.addEventListener(Event.TRIGGERED, onBackButton);

			header = new Header();
			header.title = "Deck";
			this.addChild(header);
			this.header.leftItems = new <DisplayObject>[ this.backButton ];
			

			const collection:ListCollection = new ListCollection(cards);
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.manageVisibility = true;
			
			list = new List();
			list.dataProvider = collection;
			list.layout = listLayout;
			list.snapToPages = true;
			list.isSelectable = false;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			list.itemRendererType = CardItemRenderer;
			list.addEventListener(Event.SCROLL, onListScroll);
			this.addChild(list);
			
			pageIndicator = new PageIndicator();
			pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			pageIndicator.pageCount = 1;
			pageIndicator.addEventListener(Event.CHANGE, onPageIndicatorClick);
			this.addChild(pageIndicator);
		}
		
		
		override protected function draw():void
		{
			const sizeInvalid:Boolean = isInvalid(INVALIDATION_FLAG_SIZE);
			if(sizeInvalid) {
				updateLayout();
			}
			
			super.draw();
		}
		
		
		protected function updateLayout():void
		{
			header.width = this.actualWidth;
			header.validate();
			
			pageIndicator.width = this.actualWidth;
			pageIndicator.validate();
			pageIndicator.y = this.actualHeight - pageIndicator.height;

			list.y = header.height;
			list.width = this.actualWidth;
			list.height = this.actualHeight - header.height - pageIndicator.height;
			
			const layout:TiledRowsLayout = TiledRowsLayout(list.layout);
			layout.paddingTop = layout.paddingBottom = (list.height % 116)/2;
			layout.paddingRight = layout.paddingLeft = 0;
			layout.gap = 0;

			list.validate();
			
			pageIndicator.pageCount = list.horizontalPageCount;
		}
		
		
		protected function onListScroll(event:Event):void
		{
			pageIndicator.selectedIndex = list.horizontalPageIndex;
			pageIndicator.pageCount = list.horizontalPageCount;
		}		
		protected function onPageIndicatorClick(event:Event):void
		{
			list.scrollToPageIndex(pageIndicator.selectedIndex, 0, list.pageThrowDuration);
		}
		
		protected function onBackButton(e:Event = null):void
		{
			this.dispatchEventWith("complete");
		}
		
	}
}