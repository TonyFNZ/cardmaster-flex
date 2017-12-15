package com.tonyfendall.cards.view
{
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.util.Colour;
	import com.tonyfendall.cards.model.util.Direction;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	import persistance.CardImages;
	
	import spark.components.Label;
	import spark.filters.GlowFilter;
	
	public class CardViewLite extends UIComponent
	{
		
		[Embed(source="assets/gfx/bg_blue.png")]
		public static const BG_BLUE:Class;
		
		[Embed(source="assets/gfx/bg_red.png")]
		public static const BG_RED:Class;
		
		
		
		protected var _label:Label;
		protected var _labelGlow:GlowFilter;
		
		
		public function CardViewLite()
		{
			super();
		}
		
		private var _card:Card = null;
		
		protected var _changed:Boolean = false;;
		
		public function set card(value:Card):void
		{
			_card = value;
			_changed = true;
			invalidateDisplayList();
		}
		public function get card():Card
		{
			return _card;
		}
		
		
		
		
		// Used when drawing
		private var cachedRender:BitmapData;
		private var matrix:Matrix;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if( _changed ) {
				_changed = false;
				// Redraw bitmap cache
				
				// Clear
				cachedRender = new BitmapData(100,100);
			
				if(card != null) {
					trace("Redraw");
					// Card Image
					var im:BitmapAsset = _card.cardType.image;
					cachedRender.copyPixels(im.bitmapData, new Rectangle(0,0,100,100), new Point(0,0));
					
					// Arrows
					if(_card.arrows & Direction.N)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(0,0,20,20), new Point(40,0), null, null, true);
					
					if(_card.arrows & Direction.NE)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(20,0,20,20), new Point(80,0), null, null, true);
					
					if(_card.arrows & Direction.E)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(40,0,20,20), new Point(80,40), null, null, true);
					
					if(_card.arrows & Direction.SE)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(60,0,20,20), new Point(80,80), null, null, true);
					
					if(_card.arrows & Direction.S)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(80,0,20,20), new Point(40,80), null, null, true);
					
					if(_card.arrows & Direction.SW)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(100,0,20,20), new Point(0,80), null, null, true);
					
					if(_card.arrows & Direction.W)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(120,0,20,20), new Point(0,40), null, null, true);
					
					if(_card.arrows & Direction.NW)
						cachedRender.copyPixels(CardImages.ARROWS.bitmapData, new Rectangle(140,0,20,20), new Point(0,0), null, null, true);
				
					// LABEL
					var tmp:String = _card.attack.toString(16) + _card.type + _card.physDef.toString(16) + _card.magicDef.toString(16);
					_label.text = tmp.toUpperCase();
				}
			}
			

			var g:Graphics = this.graphics;
			g.clear();
			
			if(_card == null) {
				_label.text = "";
				return;
			}
			
			var m:Matrix = new Matrix();
			m.scale(unscaledWidth/100, unscaledHeight/100);
			
			// BACKGROUND
			var bg:BitmapAsset = (_card.currentOwner.colour == Colour.BLUE) ? CardImages.BLUE_BG : CardImages.RED_BG;
			g.beginBitmapFill(bg.bitmapData, m, false, false);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
			
			// IMAGE AND ARROWS
			g.beginBitmapFill(cachedRender, m, false, true);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
			
			// LABEL
			var s:Number = unscaledWidth/100;
			_label.x = 0;
			_label.y = unscaledHeight*0.65;
			_label.scaleX = s;
			_label.scaleY = s;
			
			_labelGlow.strength = 5 * s;
			_labelGlow.blurX = 2 * s;
			_labelGlow.blurY = 2 * s;
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_label = new Label();
			_label.setStyle("fontSize", 18);
			_label.setStyle("color", 0xFFFF00);
			_label.setStyle("fontWeight", "bold");
			_label.setStyle("textAlign", "center");
			
			_labelGlow = new GlowFilter();
			_labelGlow.alpha = 0.7;
			_labelGlow.color = 0x000000;
			_labelGlow.blurX = 4;
			_labelGlow.blurY = 4;
			_labelGlow.strength = 10;

			_label.filters = [_labelGlow];
			_label.text = "0P00";
			
			_label.width = 100;
			_label.height = 40;
			
			this.addChild( _label );
		}
	}
}