package views.game
{
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.controller.util.GameSetupUtil;
	import com.tonyfendall.cards.model.Game;
	import com.tonyfendall.cards.player.HumanPlayer;
	import com.tonyfendall.cards.player.supportClasses.AIPlayer;
	import com.tonyfendall.cards.player.supportClasses.PlayerBase;
	import com.tonyfendall.cards.view.GameComponent;
	
	import flash.utils.setTimeout;
	
	import mx.events.FlexEvent;
	
	import spark.components.View;
	
	public class GameView extends View
	{
		
		private var _model:Game;
		private var _view:GameComponent;
		private var _controller:GameController;
		
		public function GameView()
		{
			super();
			this.overlayControls = true;
			this.actionBarVisible = false;
			this.tabBarVisible = false;
			
			var p1:HumanPlayer = Globals.globals.player;
			var p2:AIPlayer = Globals.globals.oponent;
			
			_model = GameSetupUtil.buildGame(p1, p2);
			_controller = new GameController(_model);
			
			p1.controller = _controller;
			p2.controller = _controller;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			this.addEventListener(FlexEvent.BACK_KEY_PRESSED, onBackKeyPressed);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			setTimeout( _controller.beginGame, 1000 );
		}
		
		private function onBackKeyPressed(event:FlexEvent):void
		{
			_view.onBackKeyPressed();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_view = new GameComponent();
			_view.parentView = this;
			_view.model = _model;
			_view.controller = _controller;
			this.addElement( _view );
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			trace("Game View: "+unscaledWidth, unscaledHeight);
			_view.width = unscaledWidth;
			_view.height = unscaledHeight;
		}
	}
}