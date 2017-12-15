package com.tonyfendall.cards.view
{
	import com.tonyfendall.cards.model.util.Direction;
	
	import spark.components.Image;
	
	public class Arrow extends Image
	{
		
		[Embed(source="images/arrow.png")]
		public static const ARROW:Class;
		
		
		public function Arrow()
		{
			super();
			this.source = ARROW; 
			this.width = 20;
			this.height = 20;
		}
		
		
		private var _direction:uint = 0;
		private var _directionChanged:Boolean = false;
		
		public function set direction(value:uint):void
		{
			_direction = value;
			_directionChanged = true;
			invalidateProperties();
		}
		public function get direction():uint
			{ return _direction; }
		
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(_directionChanged)
			{
				_directionChanged = false;
				
/*				switch(_direction)
				{
					case Direction.N:
						this.setStyle("horizontalAlign", "center");
						break;
					case Direction.NE:
						this.setStyle("right", 0);
						this.rotation = 45;
						break;
					case Direction.E:
						this.setStyle("right", 0);
						this.setStyle("verticalAlign", "middle");
						this.rotation = 90;
						break;
					case Direction.SE:
						this.setStyle("right", 0);
						this.setStyle("bottom", 0);
						this.rotation = 135;
						break;
					case Direction.S:
						this.setStyle("bottom", 0);
						this.setStyle("horizontalAlign", "center");
						break;
					case Direction.SW:
						this.setStyle("bottom", 0);
						this.rotation = -135;
						break;
					case Direction.W:
						this.setStyle("verticalAlign", "middle");
						this.rotation = -90;
						break;
					case Direction.NW:
						this.rotation = -45;
						break;
				}*/
				
			}
		}
	}
}