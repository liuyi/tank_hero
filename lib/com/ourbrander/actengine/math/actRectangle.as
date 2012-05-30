package com.ourbrander.actengine.math 
{
	/**
	 * ...
	 * @author ...
	 */
	public class actRectangle extends Polygon 
	{
		private var _u:uint
		private var _v:uint;
		private var _w:Number;
		private var _h:Number;
		private var _startX:Number;
		private var _startY:Number;
		public function actRectangle(startX:Number, startY:Number, w:Number, h:Number, u:uint=3, v:uint=4) 
		{
			super();
			_u = u;
			_v = v;
			_startX = x;
			_startY = y;
			_w = w;
			_h = h;
			createRectangle();
		}
		
		public function get u():uint {
			return _u;
		}
		
		public function get v():uint {
			return _v;
		}
		
		public function get w():Number {
			return _w;
		}
		
		public function get h():Number {
			return _h;
		}
		
		
		protected function createRectangle() {
			if (w <0 || h <0) {
				throw new Error("createRectangle w and h shouldn't be negative number ")
			}
		 
		
			var i :int= 0;
			var k:int = 0;
			var dw:Number = (w / (u-1)) ;
			var dh:Number = (h / (v-1)) ;
			
			for ( k = 0; k < u; k++ ) {
				autoAddPoint()
			}
		
			k = u - 1;
			
			
			for (i = 1; i < v;i++ ) {
				autoAddPoint()
			}
		
			i = v - 1;
		
			
		 	for ( k = u - 2; k >= 0; k-- ) {
				autoAddPoint()
				
			}
			k = 0
		
			for ( i=v-2; i >0;i-- ) {
				autoAddPoint();
			}
		// this._collisionSkin.graphics.lineTo(x,y );
			//this._collisionSkin.graphics.endFill()
		
			trace("created polygon:" + _collision.polygon.points)
			
			function autoAddPoint() {
				addPoint(Math.round(_startX + dw * k), Math.round(_startY + dh * i));
				//_collisionSkin.graphics.lineTo(Math.round(x +dw * k), Math.round(y + dh * i));
			}
		}
		
	}

}