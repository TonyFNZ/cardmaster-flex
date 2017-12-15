package com.tonyfendall.cards.view
{
	import flash.display.Graphics;
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	public class ImageDisplay extends UIComponent
	{
		public function ImageDisplay()
		{
			super();
		}
		
		private var _image:BitmapAsset;
		public function set image(value:BitmapAsset):void
		{
			_image = value;
			this.width = _image.width;
			this.height = _image.height;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var g:Graphics = this.graphics;
			g.clear();
			g.beginBitmapFill(_image.bitmapData);
			g.drawRect(0,0,unscaledWidth,unscaledHeight);
			g.endFill();
		}
	}
}