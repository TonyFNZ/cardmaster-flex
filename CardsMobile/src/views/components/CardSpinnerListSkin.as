package views.components
{
	import spark.skins.mobile.SpinnerListSkin;
	
	public class CardSpinnerListSkin extends SpinnerListSkin
	{
		public function CardSpinnerListSkin()
		{
			super();
			borderThickness = 0; // fix stray lines
		}
		
	}
}