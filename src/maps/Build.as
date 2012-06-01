package maps 
{
	import data.BuildData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 猫
	 */
	public class Build 
	{
		public var data:BuildData
		public var id:int;// the index of builds in current terrain
		public var parent:int// the index of tiles in current terrain
		protected var _skin:Sprite
		protected var _x:Number;
		protected var _y:Number;
		public function Build() 
		{
			
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			if (skin != null) skin.x = _x;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			if (skin != null) skin.y = _y;
		}
		
		public function get skin():Sprite 
		{
			return _skin;
		}
		
		public function set skin(target:Sprite):void 
		{
			_skin = target;
			_skin.x = _x;
			_skin.y = _y;
		}
		
	}

}