package com.tonyfendall.cards 
{
    import com.tonyfendall.cards.controller.GameController;
    import com.tonyfendall.cards.core.Game;
    import com.tonyfendall.cards.enum.CardType;
    import com.tonyfendall.cards.persistance.CardDAOImpl;
    import com.tonyfendall.cards.persistance.Database;
    import com.tonyfendall.cards.persistance.HandDAOImpl;
    import com.tonyfendall.cards.player.AIPlayer;
    import com.tonyfendall.cards.player.HumanPlayer;
    import com.tonyfendall.cards.player.PlayerDeck;
    import com.tonyfendall.cards.screens.DeckScreen;
    import com.tonyfendall.cards.screens.GameScreen;
    import com.tonyfendall.cards.screens.HandSelectScreen;
    import com.tonyfendall.cards.screens.MenuScreen;
    import com.tonyfendall.cards.screens.OpponentSelectScreen;
    import com.tonyfendall.cards.screens.ParticleTestScreen;
    
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    
    import starling.display.Sprite;
    import starling.events.Event;
    

    public class Main extends Sprite
    {
		
		private var theme:MetalWorksMobileTheme;
		
		private var navigator:ScreenNavigator;
		
		
		public var human:HumanPlayer;
		public var ai:AIPlayer;

		
		
        public function Main()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            initialize();
        }
        
        private function initialize():void
        {
            // we create the game with a fixed stage size -- only the viewPort is variable.
            stage.stageWidth  = Constants.STAGE_WIDTH;
            stage.stageHeight = Constants.STAGE_HEIGHT;
            
            // the contentScaleFactor is calculated from stage size and viewport size
           // Assets.contentScaleFactor = Starling.current.contentScaleFactor;
            
            // prepare assets
            //Assets.prepareSounds();
            Assets.loadBitmapFonts();
            
			this.theme = new MetalWorksMobileTheme(this.stage);
			
			
			// Create players
			var db:Database = new Database();
				db.init();
			
			var deck:PlayerDeck = new PlayerDeck( new CardDAOImpl(db), new HandDAOImpl(db));
			human = new HumanPlayer(deck);
			
			var type:CardType;
			while(deck.getCards().length < 80) {
				type = CardType.TYPES[Math.floor(Math.random()*CardType.TYPES.length)];
				deck.addCard( type.generateCard(human) );				
			}
			
			ai = new AIPlayer("Tester", [1,2,3,4,5,6,7,8,9]);
			
			
			
			
			
			

			this.navigator = new ScreenNavigator();
			this.addChild(navigator);
			
			navigator.addScreen( "menu", new ScreenNavigatorItem(MenuScreen));
			
			navigator.addScreen( "deck", new ScreenNavigatorItem(DeckScreen, {complete: "menu"}));

			navigator.addScreen( "hand", new ScreenNavigatorItem(HandSelectScreen, {complete: "menu", play: onBeginGame}));

			navigator.addScreen( "game", new ScreenNavigatorItem(GameScreen, {complete: "menu"}));

			navigator.addScreen( "opponent", new ScreenNavigatorItem(OpponentSelectScreen, {complete: "menu", hand: "hand"}));

			navigator.addScreen( "particle", new ScreenNavigatorItem(ParticleTestScreen, {complete: "menu"}));

			// add other screens here
			

			// Show initial screen
			navigator.showScreen("menu");
		}
		
		
		protected function onBeginGame(event:Event):void
		{
			var game:Game = new Game(human, ai);
			var controller:GameController = new GameController(game);
			
			var gameScreen:GameScreen = GameScreen( navigator.showScreen("game") );
			gameScreen.setGame(controller);
		}

		
    }
}