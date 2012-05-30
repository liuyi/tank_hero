package com.ourbrander.actengine.physics 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActWord extends Sprite 
	{
		private static var  _gravity:Number = 9;//虽然意思是重力，但在这里用来表示重力加速度吧。
		private static var _airFriction:Number = 0.1;//空气的阻力,这里不用力，而用速度来表示，空气带给物体的反作用力；
		private static var _timeRate:Number = 1;//每帧时间的增加速率。
		private static var _maxSpeed:Number = 30;//设定一个速度的最大值，避免过大的速度值影响检测效率。（因为告诉移动的时候会先检测是否能够移动到该位置，中间是否会有碰撞。）
		
		protected var _x:Number;
		protected var _y:Number;
		
		
		
		public function ActWord() 
		{
			_x = 0;
			_y = 0;
		}
		
		public function onUpdate():void {}
		public function beforeUpdate():void {}
		public function afterUpdate():void {}
		
		
		public static function set gravity(g:Number):void {
			_gravity = g;
		}
		public static function get gravity():Number {
			return _gravity;
		}
		
		public static function set timeRate(t:Number):void {
			_timeRate = t;
		}
		public static function get timeRate():Number {
			return _timeRate;
		}
		
		public static function set maxSpeed(v:Number):void {
			_maxSpeed = v;
		}
		public static function get maxSpeed():Number {
			return _maxSpeed;
		}
		
		public static function set airFriction(v:Number):void {
			_airFriction = v;
		}
		public static function get airFriction():Number {
			return _airFriction;
		}

		
	}

}