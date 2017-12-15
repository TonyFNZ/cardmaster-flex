package views.components
{
	import flash.display.Graphics;
	import flash.filters.GlowFilter;
	
	import mx.core.UIComponent;
	
	import persistance.CardType;
	
	import spark.components.Label;
	
	
	public class TypeIcon extends UIComponent
	{
		
		private var labelField:Label;
		
		
		public var type:CardType;
		
		private var _count:int = 0; 
		private var _countChanged:Boolean = false;
		
		private var _selected:Boolean = false;
		
		
		public function TypeIcon()
		{
			super();
			this.width = 100;
			this.height = 100;
			this.mouseChildren = false;
		}
		
		
		
		public function set count(value:int):void
		{
			_count = value;
			_countChanged = true;
			invalidateProperties();
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			invalidateDisplayList();
		}
		
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_countChanged) {
				_countChanged = false;
				
				if(_count > 1 ) {
					if(labelField == null)
						createLabel();
					
					trace("Set text to: "+_count);
					labelField.text = _count.toString();
					
				} else {
					if(labelField != null)
						destroyLabel();
				}
			}
		}
		
		
		private function createLabel():void
		{
			labelField = new Label();
			labelField.setStyle("fontSize", 28);
			labelField.setStyle("color", 0xCCCCCC);
			labelField.setStyle("textAlign", "right");
					
			var glow:GlowFilter = new GlowFilter();
			glow.alpha = 0.65;
			glow.color = 0x000000;
			labelField.filters = [glow];
			
			labelField.width = 100;
			labelField.height = 30;
			
			this.addChild( labelField );
			trace("Created Label");
		}
		
		private function destroyLabel():void
		{
			this.removeChild(labelField);
			labelField = null;
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(labelField != null) {
				labelField.x = unscaledWidth - labelField.width - 6;
				labelField.y = unscaledHeight - labelField.height;
			}
			
			
			var g:Graphics = this.graphics;
			g.clear();
			
			if(_count == 0)
				g.beginFill(0x303141);
			else if(_count == 1)
				g.beginFill(0x988050);
			else
				g.beginFill(0x886030);
			
			if(_count == 0)
				g.drawRect(4,4,unscaledWidth-8,unscaledHeight-8);
			else
				g.drawRect(0,0,unscaledWidth,unscaledHeight);
				
			g.endFill();
			
			if(_selected) {
				g.lineStyle(4,0xFF0000);
				g.moveTo(2,2);
				g.lineTo(unscaledWidth-2, 2);
				g.lineTo(unscaledWidth-2, unscaledHeight-2);
				g.lineTo(2, unscaledHeight-2);
				g.lineTo(2, 2);
			}
		}
	}
}