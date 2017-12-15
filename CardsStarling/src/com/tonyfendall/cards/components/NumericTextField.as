package com.tonyfendall.cards.components
{
	import starling.text.TextField;
	
	public class NumericTextField extends TextField
	{
		public function NumericTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0, bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
		}
		
		
		protected var _value:int = 0;
		
		public function set value(input:int):void
		{
			_value = input;
			this.text = ""+input;			
		}
		
		public function get value():int
		{
			return _value;
		}
	}
}