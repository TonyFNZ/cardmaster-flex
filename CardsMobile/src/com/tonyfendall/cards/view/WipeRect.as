package com.tonyfendall.cards.view
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	
	public class WipeRect extends UIComponent
	{
		public function WipeRect()
		{
			super();
			this.width = 100;
			this.height = 100;
		}
		
		public var colour:uint = 0xFFFFFF;
		public var border:Number = 10;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var g:Graphics = this.graphics;
			
			g.clear();
			g.beginFill(colour);
			g.drawRect( 0, 0, unscaledWidth, border); // top
			g.drawRect( 0, border, border, unscaledHeight-border); // left
			g.drawRect( unscaledWidth-border, border, border, unscaledHeight-border); // right
			g.drawRect( border, unscaledHeight-border, unscaledWidth-2*border, border); // bottom
			g.endFill();
		}
	}
}