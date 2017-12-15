package views.components
{
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.view.CardViewLite;
	
	import spark.components.supportClasses.ItemRenderer;
	
	public class CardItemRenderer extends ItemRenderer
	{
		
		
		private var cardView:CardViewLite;
		
		
		public function CardItemRenderer()
		{
			super();
			this.autoDrawBackground = false;
			this.height = 220;
		}
		
		
		private var card:Card;
		
		override public function set data(value:Object):void
		{
			super.data = value;
			card = value as Card;
			
			if(cardView != null)
				cardView.card = card;
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			cardView = new CardViewLite();
			cardView.y = 10;
			cardView.width = 200;
			cardView.height = 200;
			this.addElement(cardView);
			
			cardView.card = card;
		}
		
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			cardView.x = (unscaledWidth-200)/2;
		}
		
		
	}
}