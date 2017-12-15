package com.tonyfendall.cards.components
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.enum.Colour;
	import com.tonyfendall.cards.enum.Direction;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;

	public class CardView extends Sprite
	{
		
		// Child components
		protected var bg:Image;
		protected var face:Image;
		protected var arrows:Array = [];
		protected var label:TextField;
		
		
		// Card being displayed
		private var _card:Card;
		
		public function set card(value:Card):void
		{
			if(_card == value)
				return;
			
			_card = value;
			update();
		}
		
		public function get card():Card
			{ return _card; }
			
		
		
		public function CardView()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.width = 100;
			this.height = 100;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createChildren();
		}
		
		/**
		 * Create Children
		 */
		protected function createChildren():void
		{
			bg = new Image(Assets.getAtlasTexture("bg_blue"));
			this.addChild(bg);
			
			face = new Image(Assets.getAtlasTexture("01"));
			face.x = face.y = 10;
			face.width = face.height = 80;
			this.addChild(face);
			
			// Arrows
			var arrow:Image;
			for(var i:int=0; i<8; i++) {
				arrow = createArrow(Direction.LIST[i]);
				this.addChild(arrow);
				arrows.push(arrow);
			}
			
			// Label
			label = new TextField(100, 40, "", "CardLabel", 24, 0xFFFFFF);
			label.y = 60;
			label.hAlign = HAlign.CENTER;
			this.addChild(label);
			
			update();
		}
		
		
		/**
		 * Update
		 */
		protected function update():void
		{
			if(bg == null)
				return;
			
			if(_card == null) {
				bg.visible = false;
				face.visible = false;
				for(var i:int=0; i<8; i++) {
					arrows[i].visible = false;
				}
				label.visible = false;
				return;
			}
			
						
			if(_card.currentOwner.colour == Colour.RED) {
				bg.texture = Assets.getAtlasTexture("bg_red");
			} else {
				bg.texture = Assets.getAtlasTexture("bg_blue");
			}
			bg.visible = true;
			
			
			var img:String = ""+(_card.cardType.id+1);
			if(img.length < 2) img = "0"+img;
			face.texture = Assets.getAtlasTexture(img);
			face.visible = true;

			
			for(var j:int=0; j<8; j++) {
				arrows[j].visible = (_card.arrows & Direction.LIST[j]) > 0; 
			}
			
			
			var lbl:String = _card.attack.toString(16) + _card.type + _card.physDef.toString(16) + _card.magicDef.toString(16); 
			label.text = lbl.toUpperCase();
			label.visible = true;
		}
		
		
		
		private function createArrow(direction:uint):Image
		{
			var arrow:Image = new Image(Assets.getAtlasTexture("arrow"));
			arrow.alignPivot();
			
			if(direction == Direction.N) {
				arrow.x = 50;
				arrow.y = 10;
			} 
			else if(direction == Direction.NE) {
				arrow.x = 90;
				arrow.y = 10;
				arrow.rotation = Math.PI*0.25;
			}
			else if(direction == Direction.E) {
				arrow.x = 90;
				arrow.y = 50;
				arrow.rotation = Math.PI*0.5;
			}
			else if(direction == Direction.SE) {
				arrow.x = 90;
				arrow.y = 90;
				arrow.rotation = Math.PI*0.75;
			}
			else if(direction == Direction.S) {
				arrow.x = 50;
				arrow.y = 90;
				arrow.rotation = Math.PI;
			}
			else if(direction == Direction.SW) {
				arrow.x = 10;
				arrow.y = 90;
				arrow.rotation = -Math.PI*0.75;
			}
			else if(direction == Direction.W) {
				arrow.x = 10;
				arrow.y = 50;
				arrow.rotation = -Math.PI*0.5;
			}
			else if(direction == Direction.NW) {
				arrow.x = 10;
				arrow.y = 10;
				arrow.rotation = -Math.PI*0.25;
			}

			return arrow
		}
		
	}
}