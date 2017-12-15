package com.tonyfendall.cards.components
{
	import com.tonyfendall.cards.core.Card;
	import com.tonyfendall.cards.enum.Colour;
	import com.tonyfendall.cards.enum.Direction;
	import com.tonyfendall.cards.event.CardEvent;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class ActiveCardView extends CardView
	{
		
		protected static var explosionConfig:XML;
		protected static var explosionTexture:Texture;	
		
		
		// Child components
		protected var hpLabel:NumericTextField;
		
		protected var selectLabel:Image;
		
		protected var dimmer:Image;
		
		
		public function ActiveCardView()
		{
			super();
			
			if(explosionConfig == null)
				explosionConfig = XML(new AssetEmbeds.PoofConfig());
			
			if(explosionTexture == null)
				explosionTexture = Texture.fromBitmap(new AssetEmbeds.PoofParticle());	
		}
		
		
		override public function set card(value:Card):void
		{
			if(card != null)
				unbind(card);
			
			super.card = value;
			
			if(card != null)
				bind(card);
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			selectLabel = new Image(Assets.getAtlasTexture("select_target"));
			selectLabel.visible = false;
			this.addChild(selectLabel);
			
			dimmer = new Image(Assets.getAtlasTexture("dimmer"));
			dimmer.visible = false;
			this.addChild(dimmer);

			// TODO this needs a different font
			hpLabel = new NumericTextField(100, 100, "", "CardHP", 40, 0xFFFFFF);
			hpLabel.hAlign = HAlign.CENTER;
			hpLabel.vAlign = VAlign.CENTER;
			this.addChild(hpLabel);
			
		}
		
		private function bind(target:Card):void
		{
			target.addEventListener(CardEvent.FIGHT_START, onFightStart);
			target.addEventListener(CardEvent.FIGHT_EXECUTE, onFightExecute);
			target.addEventListener(CardEvent.FIGHT_COMPLETE, onFightComplete);
			target.addEventListener(CardEvent.SELECTABLE, onSelectable);
			target.addEventListener(CardEvent.UNSELECTABLE, onUnselectable);
			target.addEventListener(CardEvent.COLOUR_CHANGE, onColourChange);
			target.addEventListener(CardEvent.TYPE_CHANGE, onTypeChange);
			target.addEventListener(CardEvent.DIM, onDim);
			target.addEventListener(CardEvent.UNDIM, onUndim);
		}
		
		private function unbind(target:Card):void
		{
			target.removeEventListener(CardEvent.FIGHT_START, onFightStart);
			target.removeEventListener(CardEvent.FIGHT_EXECUTE, onFightExecute);
			target.removeEventListener(CardEvent.FIGHT_COMPLETE, onFightComplete);
			target.removeEventListener(CardEvent.SELECTABLE, onSelectable);
			target.removeEventListener(CardEvent.UNSELECTABLE, onUnselectable);
			target.removeEventListener(CardEvent.COLOUR_CHANGE, onColourChange);
			target.removeEventListener(CardEvent.TYPE_CHANGE, onTypeChange);
			target.removeEventListener(CardEvent.DIM, onDim);
			target.removeEventListener(CardEvent.UNDIM, onUndim);
		}
		
		
		
		private function onFightStart(event:CardEvent):void
		{
					trace("FIGHT START:"+card.hp);
					hpLabel.visible = true;
					hpLabel.value = card.hp;
		}
				
		private function onFightExecute(event:CardEvent):void
		{
			if(event.attack.origin == card)
			{
				// We are attacker
				this.parent.setChildIndex(this, this.parent.numChildren-1); // Bring to front

				// Begin animation
				attackPhase1(event.attack.direction, card.hp);
			}
			else
			{
				defendPhase1(card.hp);
			}
		}
				
		private function onFightComplete(event:CardEvent):void
		{
					hpLabel.value = 0;
					hpLabel.visible = false;
		}
				
		private function onSelectable(event:CardEvent):void
		{
					selectLabel.visible = true;
		}
				
		private function onUnselectable(event:CardEvent):void
		{
					selectLabel.visible = false;
		}
				
		private function onColourChange(event:CardEvent):void
		{
					// TODO restore flip animation
					if(card.currentOwner.colour == Colour.BLUE) {
						bg.texture = Assets.getAtlasTexture("bg_blue");
					} else {
						bg.texture = Assets.getAtlasTexture("bg_red");
					}
					
					//if(event.wasComboed) {
					//	getComboEffect(event.attack.direction).play();						
					//} else {
					//	getFlipEffect().play();
					//}
		}
				
		private function onTypeChange(event:CardEvent):void
		{
		}
				
		private function onDim(event:CardEvent):void
		{
					dimmer.visible = true;
		}
				
		private function onUndim(event:CardEvent):void
		{
					dimmer.visible = false;
		}
		
		
		private function attackPhase1(direction:uint, hp:int):void
		{
			var offset:Point = getAttackOffset(direction);
			
			// Slide towards defending card
			Starling.juggler.tween(this, 0.2, {
				onComplete: attackPhase2,
				onCompleteArgs: [direction, offset, hp],
				x: x+offset.x,
				y: y+offset.y
			});
		}
		
		private function attackPhase2(direction:uint, offset:Point, hp:int):void
		{
			// Slide back to original position
			Starling.juggler.tween(this, 0.3, {
				x: x-offset.x,
				y: y-offset.y
			});
			
			
			// Show explosion
			var point:Point = getAttackPoint(direction);
			var explosion:PDParticleSystem = new PDParticleSystem(explosionConfig, explosionTexture);
			explosion.emitterX = point.x;
			explosion.emitterY = point.y;
			explosion.addEventListener(Event.COMPLETE, onExplosionComplete);
			
			this.addChild(explosion);
			Starling.juggler.add(explosion);
			
			explosion.start(0.2);
			
			
			// Animate hp label
			Starling.juggler.tween(hpLabel, 0.8, {
				value: hp
			});
		}
		
		private function onExplosionComplete(event:Event):void
		{
			trace("Particle Effect Ended");
			var explosion:PDParticleSystem = event.target as PDParticleSystem;           
			explosion.stop();
			Starling.juggler.remove(explosion);
			this.removeChild(explosion, true);
		}

		private function defendPhase1(hp:int):void
		{
			// Animate hp label
			Starling.juggler.tween(hpLabel, 0.8, {
				delay: 0.2,
				value: hp
			});
			
		}
		
		
		private function getAttackPoint(direction:uint):Point
		{
			var p:Point = new Point();
			
			switch(direction) {
				case Direction.NW:
				case Direction.N:
				case Direction.NE:
					p.y = 0;
					break;
				
				case Direction.E:
				case Direction.W:
					p.y = 50;
					break;

				case Direction.S:
				case Direction.SW:
				case Direction.SE:
					p.y = 100;
					break;
			}
			
			switch(direction) {
				case Direction.NW:
				case Direction.W:
				case Direction.SW:
					p.x = 0;
					break;

				case Direction.N:
				case Direction.S:
					p.x = 50;
					break;
				
				case Direction.NE:
				case Direction.E:
				case Direction.SE:
					p.x = 100;
					break;
			}
			
			return p;
		}
		
		private function getAttackOffset(direction:uint):Point
		{
			var p:Point = new Point();
			
			switch(direction) {
				case Direction.NW:
				case Direction.N:
				case Direction.NE:
					p.y = -10;
					break;
				
				case Direction.SW:
				case Direction.S:
				case Direction.SE:
					p.y = 10;
					break;
			}
			
			switch(direction) {
				case Direction.NW:
				case Direction.W:
				case Direction.SW:
					p.x = -10;
					break;
				
				case Direction.NE:
				case Direction.E:
				case Direction.SE:
					p.x = 10;
					break;
			}
			
			return p;
		}

	}
}