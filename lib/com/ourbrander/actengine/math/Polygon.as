package com.ourbrander.actengine.math 
{
	import flash.geom.Point;
	import com.ourbrander.mathKit.MathKit 
	/**
	 * ...
	 * @author liuyi
	 */
	public class Polygon 
	{
		protected var _points:Vector.<Point>
		protected var _name:String;
		protected  var _x:Number;
		protected var _y:Number;
		public function Polygon() 
		{
			
		}
		
		public function  addPoint(x:Number, y:Number) {
			if(_points==null){_points=new Vector.<Point>()}
			_points.push(new Point(x, y));
		}
		public function removePoint(ord:uint = 0, end:uint = 0):void {
		if(_points==null){return}
			if (ord >=_points.length){return}
			_points.slice(ord, end);
		}
		
		public function get points():Vector.<Point> {
			return _points;
		}
		
		public function set points(t:Vector.<Point>) {
			_points = t;
		}
		
		public function set  name(n:String) {
			_name = n;
		}
		public function get name():String {
			return _name;
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
		
		
		
	}

}