package views.shop
{
	import flash.events.Event;
	
	public class ShopEvent extends Event
	{
		
		public static const BUY:String = "buy";
		
		public var shopItem:ShopItem;
		
		public function ShopEvent(type:String, shopItem:ShopItem)
		{
			super(type, false, false);
			
			this.shopItem = shopItem;
		}
	}
}