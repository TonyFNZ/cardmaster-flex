package util
{
	import com.tonyfendall.cards.model.Card;
	
	import persistance.CardType;

	public class CollectorRankUtil
	{
		private static const TYPE_POINTS:int = 10;
		private static const ARROW_POINTS:int = 5;
		private static const X_POINTS:int = 1;
		private static const A_POINTS:int = 2;
		
		
		public static function getLevel(deck:Array):uint
		{
			var level:uint = 0;
			var typeTracker:Array = new Array(CardType.TYPES.length);
			var arrowTracker:Array = new Array(0x80);
			
			for each(var card:Card in deck)
			{
				if( !typeTracker[card.cardType.id] ) {
					typeTracker[card.cardType.id] = true;
					level += TYPE_POINTS;
				}
				
				if( !arrowTracker[card.arrows] ) {
					arrowTracker[card.arrows] = true;
					level += ARROW_POINTS;
				}
				
				if(card.type == "X")
					level += X_POINTS;
				
				if(card.type == "A")
					level += A_POINTS;
			}
			
			return level;
		}
		
		
		public static function getRank(level:uint):String
		{
			if(level < 300) return "Beginner";
			if(level < 400) return "Novice";
			if(level < 500) return "Player";
			if(level < 600) return "Senior";
			if(level < 700) return "Fan";
			if(level < 800) return "Leader";
			if(level < 900) return "Coach";
			if(level < 1000) return "Advisor";
			if(level < 1100) return "Director";
			if(level < 1200) return "Dealer";
			if(level < 1250) return "Trader";
			if(level < 1300) return "Commander";
			if(level < 1320) return "Doctor";
			if(level < 1330) return "Professor";
			if(level < 1340) return "Veteran";
			if(level < 1350) return "Freak";
			if(level < 1360) return "Champion";
			if(level < 1370) return "Analyst";
			if(level < 1380) return "General";
			if(level < 1390) return "Expert";
			if(level < 1400) return "Shark";
			if(level < 1450) return "Specialist";
			if(level < 1475) return "Elder";
			if(level < 1500) return "Dominator";
			if(level < 1550) return "Maestro";
			if(level < 1600) return "King";
			if(level < 1650) return "Wizard";
			if(level < 1680) return "Authority";
			if(level < 1690) return "Emperor";
			if(level < 1698) return "Pro";
			return "Master";
		}
			
	}
}