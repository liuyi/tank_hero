package com.ourbrander.actengine.math 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ActVector 
	{
		private var _x:Number;
		private var _y:Number;
		public function ActVector(x:Number=0,y:Number=0) 
		{
			_x = x;
			_y = y;
		}
		
		public function set x(num:Number) {
			_x = num;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function set y(num:Number) {
			_y = num;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function add(target:ActVector) {
			x += target.x;
			y += target.y;
		}
		
		public function sub(target:ActVector) {
			x -= target.x;
			y -= target.y;
			
		}
		
		public function mult(target:ActVector) {
			
		}
		
	}

}