package views.shop
{
	import com.tonyfendall.cards.model.Card;
	
	import persistance.CardType;

	public class ShopItem
	{
		public var cardType:CardType;

		[Bindable]
		public var card:Card;
		[Bindable]
		public var price:uint;
		
		public function ShopItem(cardType:CardType, price:uint)
		{
			this.cardType = cardType;
			this.price = price;
			
			reset();
		}
		
		public function reset():void
		{
			this.card = cardType.generateCard( Globals.globals.player );
		}
	}
}