package components 
{
	import com.ourbrander.components.scrollBar.ScrollBar;
	import com.ourbrander.utils.Utils;


	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author liu yi
	 */
	public class TileBox extends Sprite 
	{
		private var _list:Vector.<TileItem>;
		private var _container:Sprite;
		private var _scrollbar:ScrollBar;
		private var _mask:Sprite;
		private var _padding:Number = 5;
		private var _scrollBarSkin:String;
		public function TileBox(w:Number = 100, h:Number = 100 ) 
		{
			_list = new Vector.<TileItem>();
			
			_container = new Sprite();
			addChild(_container);
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 100, 100);
			_mask.graphics.endFill();
			
			addChild(_mask);
			
			_container.mask = _mask;
			
			displayArea(w,h);
		}
		
		public function addTile(target:DisplayObject,data:Object=null):void {
			
			if (target == null) return;
			
			var item:TileItem = new TileItem(target, data);
			if (_list.length == 0) {
				_container.addChild(item);
				_list.push(item);
				return;
			}
			
		
			var prevItem:TileItem = _list[_list.length - 1];
		
			
			var posX:Number = prevItem.x+prevItem.width   + _padding;
			if (posX +item.width> _mask.width) {
				item.x = 0;
				item.y = _padding + prevItem.height+prevItem.y;
			}else {
				item.x = posX;
				item.y = prevItem.y;
			}
	 
			_list.push(item);
			_container.addChild(item);
			
		}
		
		
		protected function update():void {
			if (_container.height > _mask.height) {
				if (_scrollbar == null && _scrollBarSkin!="") {
					_scrollbar = new ScrollBar(_container);
					_scrollbar.setInterface(Utils.getObj(_scrollBarSkin) as Sprite);
				}
			}
		}
		
	
		
		public function displayArea(w:Number,h:Number):void 
		{
			if (_mask != null) {
				_mask.width = w
				_mask.height = h
			}
			
			
		}
		
		
		
	}

}