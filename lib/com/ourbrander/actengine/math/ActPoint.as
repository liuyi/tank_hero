package com.ourbrander.actengine.math 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActPoint extends Point 
	{
		private var _name:String;
		private var _u:uint;
		private var _v:uint;
		public var id:uint;
		public function ActPoint() 
		{
			
		}
		
		protected function set name(str:String) {
			_name = str;
		}
		
		protected function get name():String {
			return _name;
		}
		public function get u():uint {
			return _u;
		}
		
		public function get v():uint {
			return _v;
		}
		
	}

}