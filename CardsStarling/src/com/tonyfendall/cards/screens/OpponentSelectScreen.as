package com.tonyfendall.cards.screens
{
	import com.tonyfendall.cards.components.CardItemRenderer;
	import com.tonyfendall.cards.player.AIPlayer;
	import com.tonyfendall.cards.player.Opponent;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	import feathers.skins.StandardIcons;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	import com.tonyfendall.cards.Main;
	
	
	public class OpponentSelectScreen extends Screen
	{
		
		private static const OPPONENTS:Array = [
			new Opponent("Tramp", 					[0,1,2,3,4],							0),
			new Opponent("Passer-by", 				[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9],		0),
			new Opponent("Lad", 					[10,11,12,13,14,15,16,17,18,19],	  100),
			new Opponent("Moogle", 					[20,21,22,23,24,25,26,27,28,29],	  200),
			new Opponent("Theif", 					[30,31,32,33,34,35,36,37,38,39],	  300),
			new Opponent("Worker #9", 				[40,41,42,43,44,45,46,47,48,49],	  400),
			new Opponent("Gilbert Teacher", 		[50,51,52,53,54,55,56,57,58,59],	  500),
			new Opponent("Eidolon Master Liera", 	[60,61,62,63,64,65,66,67,68,69],	  600),
			new Opponent("Weapon Master Hant", 		[70,71,72,73,74,75,76,77,78,79],	  700)
		];
		
		protected var header:Header;
		protected var backButton:Button;
		
		protected var list:List;
		
		
		public function OpponentSelectScreen()
		{
			super();
			this.backButtonHandler = onBackButton;
		}
		
		
		override protected function initialize():void
		{
			// create children	
			backButton = new Button();
			backButton.label = "Back";
			backButton.addEventListener(Event.TRIGGERED, onBackButton);

			header = new Header();
			header.title = "Opponent";
			header.leftItems = new <DisplayObject>[ backButton ];
			this.addChild(header);
			
			
			const collection:ListCollection = new ListCollection(OPPONENTS);
			
			list = new List();
			list.dataProvider = collection;
			list.addEventListener(Event.CHANGE, onListChange);
			
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelField = "name";
				renderer.accessorySourceFunction = accessorySourceFunction;
				return renderer;
			}
				
			this.addChild(list);
		}
		
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		
		override protected function draw():void
		{
			super.draw();
			
			header.width = this.actualWidth;
			header.validate();
			
			list.y = header.height;
			list.width = this.actualWidth;
			list.height = this.actualHeight - header.height;
		}
		
		
		protected function onBackButton(e:Event = null):void
		{
			this.dispatchEventWith("complete");
		}
		
		protected function onListChange(e:Event):void
		{
			var opponent:Opponent = list.selectedItem as Opponent;
			
			if(!opponent)
				return;
			
			var main:Main = Starling.current.root as Main;
			main.ai = new AIPlayer(opponent.name, opponent.cards);

			this.dispatchEventWith("hand");
			
			list.selectedIndex = -1;
		}
	}
}