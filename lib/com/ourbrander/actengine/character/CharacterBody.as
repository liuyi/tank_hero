package com.ourbrander.actengine.character 
{
	import com.ourbrander.actengine.ActGamebox;
	import com.ourbrander.actengine.ActGameRound;
	import com.ourbrander.actengine.actObjs.DynamicActObj;
	import com.ourbrander.actengine.editer.CollisionPoint;
	
	import com.ourbrander.actengine.math.Polygon;
	import com.ourbrander.actengine.physics.Collision;
	import com.ourbrander.actengine.physics.hitResult;
	import com.ourbrander.actengine.physics.RigidBody;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point
	
	import com.ourbrander.actengine.character.MoveStatus
	import com.ourbrander.actengine.physics.ActWord
	import com.ourbrander.actengine.map.MapManager
	/**
	 * ...
	 * @author liuyi
	 */
	public class CharacterBody extends DynamicActObj 
	{
		private var _animation:MovieClip

		//private var _collision:Collision
		
		private var _rigidBody:RigidBody
		private var _isRigidBody:Boolean;
		//display
		private var _animationContainer:Sprite;
		
		private var _belong:Character
	 
		


		
		private var _allowance:uint;
		
		
		
		
		public function CharacterBody() 
		{
			super();
			getAnimation();
			_allowance = 4;
			this.isGravity=true
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
		}
		
		protected function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
		}
		
		protected function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
		}
	
		override public function onUpdate() :void{
		
			
			super.onUpdate();
		
			
		}
		override public function afterUpdate() :void{
		
			//checkAfterTransform();
		}
		
		
		public function addAnimation(animation:MovieClip) {
			getAnimation()
			if (_animation != null) {
				removeChild(_animation)
			}
			_animation = animation;
			_animation.name = "animation_mc";
			addChild(_animation);
		 
		}
		
		public function getAnimation():MovieClip {
			if (_animation != null) {
				return _animation;
			}else {
				if (this.getChildByName("animation_mc") != null) {
					_animation = this.getChildByName("animation_mc") as MovieClip;
					return _animation;
				}else {
					return null
				}
			}
		}
		
		public function removeAnimation() {
			//getAnimationContainer().removeChild(_animation);
			if(_animation!=null){
				removeChild(_animation);
				_animation = null;
			}
			
		}
		
		//设置角色的左右方向，默认是面朝右边的。
		public function set direction(num:int) {
			this.scaleX = (num >= 0)?1: -1;
		}
		public function get direction():int {
			return this.scaleX;
		}
		
		public function toggleDirection() {
			this.scaleX = -this.scaleX;
		}

		public function get moveStatus ():String {
			return _moveStatus;
		}
		
		public function set belong(target:Character) {
			_belong = target;
		}
		
		public function get belong():Character {
			return _belong;
		}
		
		public function set jumpSpeed(num:Number) {
			_speedY =( num<0)?0:num;
		}
		
		public function get jumpSpeed():Number {
			return _speedY;
		}

		public function get isJumping():Boolean {
			return _isJumping;
			
		}

		 public  function setCollision(polygon:Polygon) {
			if(_collision==null){
				_collision = new Collision();
			}
			_collision.polygon = polygon;
		}
		
		public function isRigidBody(b:Boolean) {
			_isRigidBody = b;
		}
		
		public function checkCollsion(){

		} 
		
		public function jump() {
		
			if(_startedJump==false){
				_isJumping = true;
			}
		}
		
		/*
		 * 移动的相关方法
		 * */
		
		//水平移动，左右移动的时候会自动转向。如果想要后退的时候不要切换方向，将changeDirection设置为false。
		
		
		 public  function move(offsetX:Number,changeDirection:Boolean=true):void {
			
			
			//原理：判断是否已经撞到墙。
			var moveHit:Boolean = false;
			if(changeDirection){direction = offsetX;}//根据位移的方向改变角色的方向
			var k:int = (offsetX < 0) ? -1:1;
			var d:uint = getCheckDirection(offsetX);
			var temp_ox:Number = 0;
			var temp_oy:Number = 0;
			
		
			var distance:Number = 0;//可以根据这个计算出在斜面上的移动距离。
			while (!moveHit) {
				
				 
				
				//判断下一点平移的坐标是否是有障碍还是空的，如果是障碍需要判断是否是可以攀爬的斜率。
				var hit:Boolean = checkPosition(temp_ox, temp_oy,offsetX);
				
				//平路或踏空的情况
				if (hit == false) {
					//判断是平路还是踏空,计算往下移动多少像素是地面。
					
						if (_collision.hitTestByPix(temp_ox, temp_oy + 2).hitCount>=1) {
						//	trace("horizon")
							_moveStatus = MoveStatus.HORIZON;
						}else {
							// trace("down")
							_moveStatus = MoveStatus.DOWNHILL;
							if(!_isJumping){
								temp_oy += 1;//这样直接减和加会抖动，毕竟没有真正检测。下面开始检测争取的Y轴位移
							}
						}
					temp_ox += k;
					//temp_oy= getYOnDown();
					
				}else {
				//上坡或者撞墙的情况
					
				//	trace("uphill or hit wall")
					//判断是撞墙了还是可以上坡
					if (_collision.hitTestByPix(temp_ox, temp_oy - _allowance,[d]).hitCount >= 1) {
						//trace("hit wall");
						_moveStatus = MoveStatus.HIT_WALL;
						moveHit = true;
					}else {
						//trace("up hill");
						_moveStatus=MoveStatus.UPHILL
							temp_ox += k;
						var pre_tmep_y:Number = preCheckOnUphill(temp_ox, temp_oy)
						//trace("pre_tmep_y",pre_tmep_y)
						
						temp_oy -= pre_tmep_y;
						//temp_oy-=0.5
					}
				}
				
				
				
				if (Math.abs(temp_ox) >= Math.abs(offsetX)) {moveHit = true};
			 
			}
			
			

			/*this.x += temp_ox;
			this.y += temp_oy;*/
			if(_belong.humanOperator==true){
				scrollMapX(temp_ox);
			}else {
				this.x += temp_ox
			}
			
			this.y += temp_oy;
			
			 function preCheckOnUphill(ox:Number,oy:Number):Number {
				for (var i = 0; i < _allowance; i++ ) {
					//如果没有有障碍物，则返回当前点的Y轴坐标
					
			 
					if (_collision.hitTestByPix(ox, -i + oy,[d]).hitCount <=0) {
					
						return i
					}
				}
				return _allowance+1;
			}
			
			
		}
		
		//这个是角色层不跟随地图移动的，现在改成另外一个角色层也跟随地图移动。
		protected function scrollMapX_unmove(ox:Number) {
		
			var gamebox:ActGamebox =this._actManager.gamebox;
			var gameRound:ActGameRound = gamebox.currentRound;
			var map:BitmapData = MapManager.getInstance().getMapBitmap();
			//var point:Point = gameRound.localToGlobal(new Point(this.x, this.y));
			var point:Point = new Point(this.x, this.y);
			
			//point = this.globalToLocal(point);
			var maxRight:Number = gamebox.width - gameRound.marginRight;
			var minLeft:Number = gameRound.marginLeft;
			//trace(point.x,ox,map.width,gameRound.mapX)
			//如果角色走到地图的滚动边界。
			if (point.x > maxRight) {
				
				//如果地图已经到了最左边或最右边，则移动角色，否则移动地图。
				
				
				//如果地图已经到最右边了。
				if (gameRound.mapX<gamebox.width-gameRound.mapWidth) {
					var preX:Number = this.x + ox + this.width * 0.5;
					if(ox>0){
						if (preX<map.width) {
							this.x += ox;
						}else {
							this.x = preX;
						}
					}else {
						this.x += ox;
					}
					
				}else {
					//地图还没到最右边，移动地图
					if(ox>0){
						gameRound.scrollMapX( - ox);
					
					}else {
						this.x += ox;
					}
				}
			}else if(point.x<minLeft) {
				//如果角色走到了靠近左边
				if (gameRound.mapX>=0) {
			
						this.x += ox;
					
				}else {
				
					if (ox > 0) {
							this.x += ox;
							
					}else {
						gameRound.scrollMapX(- ox);
					
					}
				}
			}else {
				this.x += ox;
			}

		}
		
		//这个是地图角色层同时移动的。
		protected function scrollMapX(ox:Number) {
		
			var gamebox:ActGamebox = _actManager.gamebox;
			var gameRound:ActGameRound = gamebox.currentRound;
			var map:BitmapData = MapManager.getInstance().getMapBitmap();
			//var point:Point = gameRound.localToGlobal(new Point(this.x, this.y));
			var point:Point = new Point(this.x, this.y);
			point = this.parent.localToGlobal(point);
			point=_actManager.gamebox.getPositionFromGlobal(point);
		
			//point = this.globalToLocal(point);
			var maxRight:Number = gamebox.width - gameRound.marginRight;
			var minLeft:Number = gameRound.marginLeft;
			//trace(point.x,ox,map.width,gameRound.mapX)
			//如果角色走到地图的滚动边界。
			if (point.x > maxRight) {
				
				//如果地图已经到了最左边或最右边，则移动角色，否则移动地图。
				
				
				//如果地图已经到最右边了。
				if (gameRound.mapX<gamebox.width-gameRound.mapWidth) {
					var preX:Number = this.x + ox + this.width * 0.5;
					if(ox>0){
						if (preX<map.width) {
							this.x += ox;
						}else {
							this.x = preX;
						}
					}else {
						this.x += ox;
					}
					
				}else {
					//地图还没到最右边，移动地图
					if(ox>0){
						gameRound.scrollMapX( - ox);
						this.x += ox;
					}else {
						this.x += ox;
					}
				}
			}else if(point.x<minLeft) {
				//如果角色走到了靠近左边
				if (gameRound.mapX>=0) {
			
					this.x += ox;
					
				}else {
				
					if (ox > 0) {
						this.x += ox;
							
					}else {
						gameRound.scrollMapX(- ox);
						this.x += ox;
					}
				}
			}else {
				this.x += ox;
			}
			
			
		
			
		}
		
		protected function scrollMapY(oy:Number):void {
			var gamebox:ActGamebox = _actManager.gamebox;
			var gameRound:ActGameRound = gamebox.currentRound;
			/*var map:BitmapData = MapManager.getInstance().getMapBitmap();
			//var point:Point = gameRound.localToGlobal(new Point(this.x, this.y));
			var point:Point = new Point(this.x, this.y);
			//point = this.globalToLocal(point);
			var maxRight:Number = gamebox.width - gameRound.marginRight;
			var minLeft:Number = gameRound.marginLeft;*/
		
			gameRound.scrollMapY(-oy);
		}
		
		protected function getCheckDirection(offsetX:Number):uint {
			var d:uint
			if (offsetX > 0) {
				d = (direction > 0)?1: 3;
			}else {
				d = (direction > 0)?3:1;
			}
			return d;
		}
		protected function checkPosition(ox:Number, oy:Number, offsetX:Number):Boolean {
		 
			var d:uint=getCheckDirection(offsetX)
			var result:hitResult = _collision.hitTestByPix(ox, oy, [d]);
			
			
		 // trace("result.hitCount:"+result.hitCount,"ox: "+ox,"oy: "+oy)
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				var a:Boolean =( result.hitPoints[d][0] == _collision.directionList[d][0]);
				var b:Boolean = (result.hitPoints[d][0] == _collision.directionList[d][_collision.directionList[d].length - 1]);
				if (a||b ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					return checkIsOnEdge(result.hitPoints[d][0])//只是在polygon里的索引号
				}else {
					return true;
				}
			}else {
					return true;
			}
			
			//判断在一个点碰撞的时候是处于墙壁的边缘还是撞在墙壁上了。
			
			function checkIsOnEdge(pid:uint):Boolean {
				
				var k = (offsetX > 0)?2 : -2;
				var a = _collision.pointTest(pid, k, 1);
				var b = _collision.pointTest(pid, k,- 1);
				
				if (a == true && b == true) {
				// trace("1 point on the floor pid:"+pid+" a:"+a+" b:"+b)
					return true;
				}else {
				//	 trace("1 point on the edge pid:"+pid+" a:"+a+" b:"+b)
					return false;
				}
			}
			
		}

	}

}