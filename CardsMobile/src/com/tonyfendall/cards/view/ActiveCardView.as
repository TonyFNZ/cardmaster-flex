package com.tonyfendall.cards.view
{
	import com.greensock.TimelineLite;
	import com.tonyfendall.cards.controller.GameController;
	import com.tonyfendall.cards.model.Card;
	import com.tonyfendall.cards.model.event.CardEvent;
	import com.tonyfendall.cards.model.util.Direction;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import spark.components.Label;
	
	import persistance.CardImages;

	public class ActiveCardView extends CardViewLite
	{
		
		// Reference to the controller
		public var controller:GameController;

		
		// Child Components
		private var hpLabel:NumberLabel;
		private var selectLabel:Label;
		private var flipMask:BlankRect;
		private var dimMask:BlankRect;
		
		private var wipe:WipeRect;
		private var wipeMask:BlankRect;
		
		
		private var _faceup:Boolean = true;
		public function set faceup(value:Boolean):void
		{
			if(_faceup == value)
				return;
			
			_faceup = value;
			invalidateDisplayList();
		}
		
		
		public function ActiveCardView()
		{
			super();
		}
		
		
		
		
		override public function set card(value:Card):void
		{
			if(card != null)
				unBind(card);
			
			super.card = value;
			
			if(card != null)
				bind(card);
		}
		
		
		
		
		private function bind(target:Card):void
		{
			target.addEventListener(CardEvent.FIGHT_START, onCardEvent);
			target.addEventListener(CardEvent.FIGHT_EXECUTE, onCardEvent);
			target.addEventListener(CardEvent.FIGHT_COMPLETE, onCardEvent);
			target.addEventListener(CardEvent.SELECTABLE, onCardEvent);
			target.addEventListener(CardEvent.UNSELECTABLE, onCardEvent);
			target.addEventListener(CardEvent.COLOUR_CHANGE, onCardEvent);
			target.addEventListener(CardEvent.TYPE_CHANGE, onCardEvent);
			target.addEventListener(CardEvent.DIM, onCardEvent);
			target.addEventListener(CardEvent.UNDIM, onCardEvent);
		}
		
		private function unBind(target:Card):void
		{
			target.removeEventListener(CardEvent.FIGHT_START, onCardEvent);
			target.removeEventListener(CardEvent.FIGHT_EXECUTE, onCardEvent);
			target.removeEventListener(CardEvent.FIGHT_COMPLETE, onCardEvent);
			target.removeEventListener(CardEvent.SELECTABLE, onCardEvent);
			target.removeEventListener(CardEvent.UNSELECTABLE, onCardEvent);
			target.removeEventListener(CardEvent.COLOUR_CHANGE, onCardEvent);
			target.removeEventListener(CardEvent.TYPE_CHANGE, onCardEvent);
			target.removeEventListener(CardEvent.DIM, onCardEvent);
			target.removeEventListener(CardEvent.UNDIM, onCardEvent);
		}
		
		
		
		private function onCardEvent(event:CardEvent):void
		{
			switch(event.type) {
				case CardEvent.FIGHT_START:
					trace("FIGHT START:"+card.hp);
					hpLabel.value = card.hp;
					hpLabel.visible = true;
					break;
				
				case CardEvent.FIGHT_EXECUTE:
					
					if(event.attack.origin == card)
					{
						// Bring to front
						var gv:GameComponent = this.parent as GameComponent;
						if(gv != null) {
							gv.removeChild(this);
							gv.addChild(this);
						} else {
							trace(typeof this.parent);
						}
						
						getAttackEffect(event.attack.direction, card.hp).play();
					} else {
						getDefendEffect(card.hp).play();
					}
					break;
				
				case CardEvent.FIGHT_COMPLETE:
					hpLabel.value = 0;
					hpLabel.visible = false;
					break;
				
				case CardEvent.SELECTABLE:
					selectLabel.visible = true;
					break;
				case CardEvent.UNSELECTABLE:
					selectLabel.visible = false;
					break;
				
				case CardEvent.COLOUR_CHANGE:
					if(event.wasComboed) {
						getComboEffect(event.attack.direction).play();						
					} else {
						getFlipEffect().play();
					}
					break;
				
				case CardEvent.TYPE_CHANGE:
					this._changed = true;
					//invalidateDisplayList(); don't need to invalidate because colour change (reset at end of game) will do it for us
					break;
				
				case CardEvent.DIM:
					dimMask.visible = true;
					break;
				case CardEvent.UNDIM:
					dimMask.visible = false;
					break;
				
			}
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();

			// HP Label
			hpLabel = new NumberLabel();
			hpLabel.setStyle("fontSize", 32);
			hpLabel.setStyle("color", 0x00FF00);
			hpLabel.setStyle("fontWeight", "bold");
			hpLabel.setStyle("textAlign", "center");
			
			hpLabel.filters = [_labelGlow];
			hpLabel.visible = false;
			hpLabel.width = 100;
			hpLabel.height = 40;
			this.addChild( hpLabel );
			
			// Select Target Label
			selectLabel = new Label();
			selectLabel.setStyle("fontSize", 20);
			selectLabel.setStyle("color", 0xCCCCCC);
			selectLabel.setStyle("fontWeight", "bold");
			selectLabel.setStyle("textAlign", "center");
			
			selectLabel.filters = [_labelGlow];
			selectLabel.text = "Select\nTarget";
			selectLabel.visible = false;
			selectLabel.width = 100;
			selectLabel.height = 50;
			this.addChild( selectLabel );

			// Flip Mask
			flipMask = new BlankRect();
			flipMask.visible = false;
			this.addChild(flipMask);

			// Dim Mask
			dimMask = new BlankRect();
			dimMask.colour = 0x000000;
			dimMask.alpha = 0.4;
			dimMask.visible = false;
			this.addChild(dimMask);
			
			// Wipe
			wipeMask = new BlankRect();
			this.addChild(wipeMask);

			wipe = new WipeRect();
			wipe.mask = wipeMask;
			wipe.visible = false;
			this.addChild(wipe);
		}
		
		
		private var _prevW:Number;
		private var _prevH:Number;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			if(!_faceup) {
				var m:Matrix = new Matrix();
				m.scale(unscaledWidth/100,unscaledHeight/100);
				
				var g:Graphics = this.graphics;
				g.clear();
				
				g.beginBitmapFill(CardImages.CARD_BACK.bitmapData, m);
				g.drawRect(0,0,unscaledWidth, unscaledHeight);
				
				_label.visible = false;
				return;
			}

			_label.visible = true;
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			if(_prevW == unscaledWidth && _prevH == unscaledHeight)
				return;
			else {
				_prevW = unscaledWidth;
				_prevH = unscaledHeight;
			}
				
			var s:Number = unscaledWidth/100;

			hpLabel.x = 0;
			hpLabel.y = (50 - hpLabel.height/2)*s;
			hpLabel.scaleX = s;
			hpLabel.scaleY = s;
			
			selectLabel.x = 0;
			selectLabel.y = (100 - selectLabel.height)/2 *s;
			selectLabel.scaleX = s;
			selectLabel.scaleY = s;

			flipMask.width = unscaledWidth;
			flipMask.height = unscaledHeight;

			dimMask.width = unscaledWidth;
			dimMask.height = unscaledHeight;

			wipe.width = unscaledWidth*1.1;
			wipe.height = unscaledHeight*1.1;
			wipe.border = unscaledHeight*0.05;

			wipeMask.width = unscaledWidth;
			wipeMask.height = unscaledHeight;
		}
		
		
		
		private function getAttackEffect(direction:uint, hp:int):TimelineLite
		{
			var offset:Point = getOffsets(direction);

			var effect:TimelineLite = new TimelineLite();
				effect.to(this, 0.2, {x:(x+offset.x), y:(y+offset.y)});
				effect.to(this, 0.3, {x:x, y:y});
				effect.to(hpLabel, 0.8, {value:hp});
			return effect;
		}

		private function getDefendEffect(hp:int):TimelineLite
		{
			var effect:TimelineLite = new TimelineLite();
				effect.to(hpLabel, 0.8, {delay:0.5, value:hp});
			return effect;
		}

		private function getFlipEffect():TimelineLite
		{
			var effect:TimelineLite = new TimelineLite();
				effect.call( function():void { flipMask.visible = true; });
				effect.fromTo(flipMask, 0.05, {alpha:0}, {alpha:1});
				effect.fromTo(flipMask, 0.05, {alpha:1}, {alpha:0});
				effect.fromTo(flipMask, 0.05, {alpha:0}, {alpha:1});
				effect.call( changeColour );
				effect.fromTo(flipMask, 0.05, {alpha:1}, {alpha:0});
				effect.fromTo(flipMask, 0.05, {alpha:0}, {alpha:1});
				effect.fromTo(flipMask, 0.05, {alpha:1}, {alpha:0});
				effect.call( function():void { flipMask.visible = false; });
			return effect;
		}
		
		private function getComboEffect(direction:uint):TimelineLite
		{
			var p1:Point = new Point();
			var p2:Point = new Point();
			
			switch(direction) {
				case Direction.NW:
				case Direction.N:
				case Direction.NE:
					p1.y = height;
					p2.y = 0;
					break;
				case Direction.W:
				case Direction.E:
					p1.y = p2.y = (height - wipe.height)/2;
					break;
				case Direction.SW:
				case Direction.S:
				case Direction.SE:
					p1.y = -wipe.height;
					p2.y = height - wipe.height;
					break;
			}
			switch(direction) {
				case Direction.NW:
				case Direction.W:
				case Direction.SW:
					p1.x = width;
					p2.x = 0;
					break;
				case Direction.N:
				case Direction.S:
					p1.x = p2.x = (width - wipe.width)/2;
					break;
				case Direction.NE:
				case Direction.E:
				case Direction.SE:
					p1.x = -wipe.width;
					p2.x = width - wipe.width;
					break;
			}
			
			
			var effect:TimelineLite = new TimelineLite();
				effect.call( function():void { wipe.visible = true; });
				effect.fromTo(wipe, 0.5, {x:p1.x, y:p1.y}, {x:p2.x, y:p2.y});
				effect.call( function():void { wipe.visible = false; });
				effect.add( changeColour, 0.25 );
			return effect;
		}
		
		
		private function changeColour():void
		{
			invalidateDisplayList(); // Causes redraw
		}
		
		
		private function getOffsets(direction:uint):Point
		{
			var p:Point = new Point();
			
			switch(direction) {
				case Direction.NW:
				case Direction.N:
				case Direction.NE:
					p.y = -height*0.1;
					break;
				
				case Direction.SW:
				case Direction.S:
				case Direction.SE:
					p.y = height*0.1;
					break;
			}
			
			switch(direction) {
				case Direction.NW:
				case Direction.W:
				case Direction.SW:
					p.x = -width*0.1;
					break;
				
				case Direction.NE:
				case Direction.E:
				case Direction.SE:
					p.x = width*0.1;
					break;
			}
			
			return p;
		}
	}
}