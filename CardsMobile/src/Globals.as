package
{
	import com.tonyfendall.cards.model.PlayerDeck;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.supportClasses.AIPlayer;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	
	import persistance.CardDAO;
	import persistance.Database;
	import persistance.ResultsDAO;

	public class Globals
	{
		
		
		
		public var player:HumanPlayer;
		public var deck:PlayerDeck;		
		
		public var oponent:AIPlayer;

		public var resultsDAO:ResultsDAO;
		
		
		// Singleton
		private static var _instance:Globals;
		
		public static function get globals():Globals
		{
			if(_instance == null)
				_instance = new Globals();
			
			return _instance;
		}

		
		public function Globals()
		{
		}
	}
}