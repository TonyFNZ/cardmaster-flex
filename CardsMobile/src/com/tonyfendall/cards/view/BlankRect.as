package com.tonyfendall.cards.view
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	
	public class BlankRect extends UIComponent
	{
		public function BlankRect()
		{
			super();
			this.width = 100;
			this.height = 100;
		}
		
		public var colour:uint = 0xFFFFFF;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var g:Graphics = this.graphics;
			
			g.clear();
			g.beginFill(colour);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
		}
	}
}