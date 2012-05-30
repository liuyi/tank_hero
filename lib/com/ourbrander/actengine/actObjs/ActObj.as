package com.ourbrander.actengine.actObjs
{
	import com.ourbrander.actengine.math.Polygon;
	import com.ourbrander.actengine.physics.Collision;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActObj extends Sprite 
	{
		protected var  _collision:Collision
		protected var _rectangle:Array;//设置碰撞区域在对象内的位置，碰撞区域为矩形
		protected var _rectangle2:Array;//临时碰撞计算时返回即时
		protected var  _uniqueId:uint;
		public function ActObj() :void
		{
			_rectangle = [];
			_rectangle2 = [];
			setHitArea( this.getChildByName("hitArea_mc") as Sprite);
			this.cacheAsBitmap = true;
		}
		
		public function set collsision(c:Collision):void {
			_collision = c;
		}
		
		public function get collsition():Collision {
			return _collision;
		}
		
		//不要使用这个方法 ，这个是给ActManager使用的。
		public function set uniqueId(index:uint):void {
			_uniqueId = index;
		}
		
		public function get uniqueId():uint {
			return _uniqueId;
		}
		

		protected function setHitArea(target:Sprite):void {
		
			if (target == null){
				
				return 
			}
			this.hitArea=target
			/*_rectangle[0]=-this.hitArea.width * 0.5
			_rectangle[1]=-this.hitArea.height * 0.5
			_rectangle[2]=this.hitArea.width * 0.5
			_rectangle[3]= -this.hitArea.height * 0.5
			_rectangle[4]=this.hitArea.width * 0.5
			_rectangle[5]= this.hitArea.height * 0.5
			_rectangle[6]=-this.hitArea.width * 0.5
			_rectangle[7]=this.hitArea.height * 0.5*/
			
			_rectangle[0]=this.hitArea.x
			_rectangle[1]=this.hitArea.y
			_rectangle[2]=this.hitArea.width+this.hitArea.x
			_rectangle[3]=this.hitArea.y
			_rectangle[4]=this.hitArea.width+this.hitArea.x
			_rectangle[5]=this.hitArea.height+this.hitArea.y
			_rectangle[6]=this.hitArea.x
			_rectangle[7]=this.hitArea.height+this.hitArea.y
		}
		
		public function get rectangle():Array {
			_rectangle2[0]=_rectangle[0]+this.x
			_rectangle2[1]=_rectangle[1]+this.y
			_rectangle2[2]=_rectangle[2]+this.x
			_rectangle2[3]=_rectangle[3]+this.y
			_rectangle2[4]=_rectangle[4]+this.x
			_rectangle2[5]=_rectangle[5]+this.y
			_rectangle2[6]=_rectangle[6]+this.x
			_rectangle2[7]=_rectangle[7]+this.y

			return _rectangle2;
		}
		
		internal function hitedBy(index:uint) :void{
			
		}
		
	}

}