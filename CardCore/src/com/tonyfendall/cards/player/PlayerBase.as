package com.tonyfendall.cards.player
{
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.core.Game;
	import com.tonyfendall.cards.enum.Colour;

	public class PlayerBase
	{
		
		private var _controller:GameController;
		
		public function set controller(value:GameController):void {
			this._controller = value;	
		}
		public function get controller():GameController {
			return this._controller;
		}
		
		
		protected var _model:Game;
		
		public function set model(value:Game):void {
			this._model = value;	
		}
		public function get model():Game {
			return this._model;
		}
		
		public var colour:Colour;
		public var hand:Hand;
		
		
		public function PlayerBase()
		{
		}
		
		
		public function get chosenCards():Hand
		{
			throw new Error("get chosenHand() must be overridden");
		}
		
		public function get name():String
		{
			throw new Error("get name() must be overridden");
		}
		
		
		public function receiveCard(card:Card):void
		{
			throw new Error("get receiveCard(card:Card) must be overridden");
		}

		public function loseCard(card:Card):void
		{
			throw new Error("get receiveCard(card:Card) must be overridden");
		}
		
	}
}