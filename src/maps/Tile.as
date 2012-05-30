package maps 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 猫
	 */
	public class Tile 
	{
		
		
		//use to search path
		public var g:int
		public var f:int
		public var h:int
		public var neighbours:Vector.<int>;
		public var toNbG:Vector.<int>;
		public var island:int;
		
		public var type:int;
		public var skinName:Sprite
		public var skin:Sprite;
		public var id:int;
		public var accross:Boolean
		public var build:Build
		public var acceptBuildType:int
		protected var _x:Number;
		protected var _y:Number;
		
		public function Tile() 
		{
			
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			if (skin != null) skin.x = x;
			_x = value;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			if (skin != null) skin.y = _y;
			_y = value;
		}
		
		public function destory():void {
			
		}
		
	}

}