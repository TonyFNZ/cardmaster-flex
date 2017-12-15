package views.components
{
	
	import mx.states.SetStyle;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	
	
	public class MenuPanel extends SkinnableContainer
	{
		
		
		[SkinPart(required="true")]
		public var titleLabel:Label;
		
		
		private var _title:String = "";
		public function set title(value:String):void
		{
			_title = value;
			if(titleLabel)
				titleLabel.text = _title;
		}
		
		
		public function MenuPanel()
		{
			super();
			setStyle("skinClass", MenuPanelSkin);
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			
			if(instance == titleLabel)
				titleLabel.text = _title;
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}