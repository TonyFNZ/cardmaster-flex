package com.tonyfendall.cards.components
{
	import com.tonyfendall.cards.core.Card;
	
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	
	public class CardItemRenderer extends Button implements IGroupedListItemRenderer
	{
		// Index of group
		private var _groupIndex:int;
		public function get groupIndex():int
			{ return _groupIndex; }
		public function set groupIndex(value:int):void
			{ _groupIndex = value; }

		// Index of item within group
		private var _itemIndex:int;
		public function get itemIndex():int
			{ return _itemIndex; }
		public function set itemIndex(value:int):void
			{ _itemIndex = value; } 

		// 
		private var _layoutIndex:int;		
		public function get layoutIndex():int
			{ return _layoutIndex; }
		public function set layoutIndex(value:int):void
			{ _layoutIndex = value; }

		// Owner list		
		private var _owner:GroupedList;
		public function get owner():GroupedList
			{ return _owner; }
		public function set owner(value:GroupedList):void
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
			this.isQuickHitAreaEnabled = false;
			this.isToggle = true;
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
		
	}
}