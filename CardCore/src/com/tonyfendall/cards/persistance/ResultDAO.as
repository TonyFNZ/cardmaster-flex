package com.tonyfendall.cards.persistance
{

	public interface ResultDAO
	{
		
		function getResultSummary():ResultSummary;
		
		function recordWin(oponent:String):void;

		function recordLoss(oponent:String):void;

		function recordDraw(oponent:String):void;

	}
}