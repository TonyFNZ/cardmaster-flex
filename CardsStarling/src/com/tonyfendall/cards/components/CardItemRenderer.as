package com.tonyfendall.cards.components
{
	import com.tonyfendall.cards.core.Card;
	
	import flash.geom.Point;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class CardItemRenderer extends Button implements IListItemRenderer
	{
		// Index of item
		private var _index:int;
		public function get index():int
			{ return _index; }
		public function set index(value:int):void
			{ _index = value; }

		
		// Owner list		
		private var _owner:List;
		public function get owner():List
			{ return _owner; }
		public function set owner(value:List):void
		{
			if(_owner == value)
				return;
			
			_owner = value; 
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		
		// Data to render
		private var _data:Object;
		public function get data():Object
			{ return _data; }
		public function set data(value:Object):void
		{
			if(_data == value)
				return;
			
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		
		
		private var _cardView:CardView;
		
		
		// --------------------------------------------------------------------
		// Constructor
		public function CardItemRenderer()
		{
			super();
			this.isFocusEnabled = false;
			this.isQuickHitAreaEnabled = true;
			this.isToggle = true;
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		
		// Called some time after control is invalidated		
		override protected function draw():void
		{
			const dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
				this.commitData();
			
			super.draw();
		}
		
		
		
		protected function commitData():void
		{
			if(_data && _owner && _data is Card) 
			{
				this.isToggle = _owner.isSelectable;
				
				if(!_cardView) {
					_cardView = new CardView();
					this.addChild(_cardView);
				}
				
				_cardView.card = _data as Card;
			}
			else
			{
				if(_cardView)
					_cardView.card = null;
			}
		}
		
		
		
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = 100 + this._paddingLeft + this._paddingRight; 
				if(!isNaN(this._originalSkinWidth))
					newWidth = Math.max(newWidth, this._originalSkinWidth);
			}
			
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = 100 + this._paddingTop + this._paddingBottom;
				if(!isNaN(this._originalSkinHeight))
					newHeight = Math.max(newHeight, this._originalSkinHeight);
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		
		override protected function layoutContent():void
		{
			if(_cardView)
			{
				_cardView.x = this._paddingLeft;
				_cardView.y = this._paddingTop;
			}
		}
		
		
		
		private var start:Point = new Point();
		
		protected function onTouch(event:TouchEvent):void
		{
			if(_owner == null)
				return;
			
			var touch:Touch = event.getTouch(this);
			if(touch == null)
				return;
			
			if(touch.phase == TouchPhase.BEGAN) {
				touch.getLocation(this, start);
				return;
			}
				
			if(touch.phase == TouchPhase.ENDED) {
				var end:Point = touch.getLocation(this);
				
				var dx:Number = Math.abs(end.x-start.x);
				var dy:Number = Math.abs(end.y-start.y);
				
				var len:Number = Math.sqrt(dx*dx + dy*dy);
				
				if(len <= 2) {
					_owner.dispatchEvent(new Event("itemClick", false, _index));
				}
				return;				
			}
		}
		
	}
}