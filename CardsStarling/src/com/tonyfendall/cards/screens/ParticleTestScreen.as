package com.tonyfendall.cards.screens
{
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class ParticleTestScreen extends Screen
	{
		
		private var psConfig:XML;
		private var psTexture:Texture;
		
		public function ParticleTestScreen()
		{
			super();
			this.backButtonHandler = onBackButton;
		}
		
		override protected function initialize():void
		{
			psConfig = XML(new AssetEmbeds.PoofConfig());
			psTexture = Texture.fromBitmap(new AssetEmbeds.PoofParticle());	
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		override protected function draw():void
		{
			
		}
		
		
		
		private function onTouch(event:TouchEvent):void
		{
			var t:Touch = event.getTouch(stage);
			
			if(t != null && t.phase == TouchPhase.ENDED)
			{
				// create particle system
				var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
				
				ps.addEventListener(Event.COMPLETE, removeParticle);
				
				ps.x = 0;
				ps.y = 0;
				
				// add it to the stage and the juggler
				addChild(ps);
				Starling.juggler.add(ps);
				
				// change position where particles are emitted
				ps.emitterX = t.globalX;
				ps.emitterY = t.globalY;
	
				Starling.juggler.add(ps);
				this.addChild(ps);
				
				trace("Particle Effect Began");
				ps.start(0.2);
			}
		}
		
		private function removeParticle(event:Event):void
		{
			trace("Particle Effect Ended");
			var ps:PDParticleSystem = event.target as PDParticleSystem;           
			ps.stop();
			Starling.juggler.remove(ps);
			this.removeChild(ps, true);
		}
		
		
		protected function onBackButton(e:Event = null):void
		{
			this.dispatchEventWith("complete");
		}
	}
}