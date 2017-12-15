package views.opponent
{
	public class Opponent
	{
		
		public var name:String;
		public var cards:Array;
		public var minLevel:int;
		
		
		public function Opponent(name:String, cards:Array = null, minLevel:int = 0)
		{
			this.name = name;
			this.cards = cards;
			this.minLevel = minLevel;
		}
		
		public function toString():String
		{
			return name;
		}
	}
}