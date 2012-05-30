package com.ourbrander.actengine.character 
{
	import com.ourbrander.actengine.actObjs.DynamicActObj;
	import com.ourbrander.actengine.editer.CollisionPoint;
	import com.ourbrander.actengine.math.ActVector;
	import com.ourbrander.actengine.math.Polygon;
	import com.ourbrander.actengine.physics.Collision;
	import com.ourbrander.actengine.physics.RigidBody;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import com.ourbrander.actengine.physics.ActWord
	/**
	 * ...
	 * @author liuyi
	 */
	public class CharacterBody extends DynamicActObj 
	{
		private var _animation:CharacterAnimation

		//private var _collision:Collision
		
		private var _rigidBody:RigidBody
		private var _isRigidBody:Boolean;
		
		private var _hitted
		
		//display
		private var _animationContainer:Sprite;
		private var _collisionSkin:Sprite;
		
		private var _belong:Character
		
		private var _tempPosition:Array;
		internal  var _prePositionX:Number
		internal var _prePositionY:Number
		
		private var _allowance:uint;
		private var _isFloor:Boolean;// Is on the floor?
		private var _isRoof:Boolean;// Is up to  the roof?
		private var _isJumping:Boolean;
		private var _isMove:Boolean;
		private var _hitWall:Boolean
		
		private var _jumpHeight:Number;
		private var _jumpedHeight:Number
		private var _jumpSpeed:Number;
		private var _t:Number;
		
		private var _g:Number;
		private var _mess:Number
		private var _currentSpeed:ActVector
		private var _startedJump:Boolean
		private var _time:Number;//对象运动的时间
		
		
		public function CharacterBody() 
		{
			super();
			init();
			
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
		
		protected function init() {
			getAnimation();
			_tempPosition=[]
			_collision = new Collision();
			_collision.belong = this;
			_allowance = 4;
			_currentSpeed = new ActVector();
			_jumpSpeed = 20
			_time = 0;
			getPolygonFromSkin(_collision);
			
		}
		internal function onUpdate() {
			
			//checkCollsion()
			//trace("body update",this.x,this.y)
			_prePositionX = this.x;
			_prePositionY = this.y;
		}
		internal function afterUpdate() {
		
			//checkAfterTransform();
		}
		
		/*override public function set x(num:Number):void {
			if (_belong != null) { 
			
				if (_belong.checkCollision() !=null) {
					return 
				}
			}
			super.x = num;
			//_tempPosition[0] = num;
		}
		
		override public function set y(num:Number):void {
			if (_belong != null) { 
			
				if (_belong.checkCollision() !=null) {
					return 
				}
			}
			//_tempPosition[1] = num;
			super.y = num;
		}*/
		
		
		public function set isMove(b:Boolean) {
			_isMove = b;
		}
		public function get isMove():Boolean {
			return _isMove;
		}
		
		public function get  currentSpeed() :ActVector{
			if (_currentSpeed == null);
			_currentSpeed = new ActVector();
		
			return  new ActVector(_currentSpeed.x, _currentSpeed.y);
		}
		
		public function set belong(target:Character) {
			_belong = target;
		}
		
		public function get belong():Character {
			return _belong;
		}
		
		public function set jumpHeight(num:Number) {
			_jumpHeight = num;
		}
		
		public function get jumpHeight():Number {
			return _jumpHeight;
		}
		
		public function jump() {
			if (_isJumping = false) {
				_jumpedHeight = 0;
			}
			
			if (_jumpedHeight>=_jumpHeight) {
				return
			}
			
			_isJumping = true;
		
			trace("jumping")
		}
		
		public function move(offsetX:Number) {
			
			var ox:Number = this.x;
			var oy:Number = this.y;
			var tx:Number;
			var ty:Number;
			var temp_offset_x:Number = 0
			var temp_offset_y:Number = 0
			var temp_hit:Boolean
			var moveHit:Boolean = false;
			var k:int = (offsetX < 0) ? -1:1;
			
			//移动之前先计算一下中间的碰撞，避免穿过。
			while (moveHit==false) {
				
				var pass_down:int = checkUpPoints(temp_offset_x);
				var pass_up:int = checkDownPoints(temp_offset_x);
				if (pass_down >=_allowance && pass_up>=_allowance) {
					moveHit=true
				}else {
					
					if (pass_down<_allowance &&pass_up >=_allowance) {
						temp_offset_y+=pass_down
					}else if(pass_up<_allowance &&pass_down >=_allowance) {
						temp_offset_y-=pass_up
					}else {
						if (pass_down > pass_up) {
							temp_offset_y-=pass_up
						}else {
							temp_offset_y+=pass_down
						}
					}
					
					temp_offset_x += k;
				}
				
				if (Math.abs(temp_offset_x)>=Math.abs(offsetX)) {
					moveHit = true;
				}
			}
			
			this.x += temp_offset_x;
			this.y += temp_offset_y;
			//doCollsion();
			
		}
		
		private function checkUpPoints(ox:Number):Number {
			for (var i = 0; i < _allowance;i++ ) {
				if (_collision.hitTestByPix(ox, i) == false) {
					return i
				}
			}
			return _allowance+1;
		}
		
		private function checkDownPoints(ox:Number) :Number{
			for (var i = 0; i < _allowance;i++ ) {
				if (_collision.hitTestByPix(ox, -i) == false) {
					return i
				}
			}
			return _allowance+1;
		}
		
		public function addAnimation(animation:CharacterAnimation) {
			getAnimation()
			if (_animation != null) {
				removeChild(_animation)
			}
			_animation = animation;
			_animation.name = "animation_mc";
			addChild(_animation);
			/*
			while (getAnimationContainer().numChildren > 0) {
				getAnimationContainer().removeChildAt(0);
			}
			getAnimationContainer().addChild(_animation);
			*/
		}
		
		public function removeAnimation() {
			//getAnimationContainer().removeChild(_animation);
			if(_animation!=null){
				removeChild(_animation);
				_animation = null;
			}
			
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
		
			if (_collision != null) {
				doCollsion();
			
			}else {
				return false;
			}
		
		} 
		
		protected function doCollsion() {
			_isFloor = _collision.hitTestByPix();
		
			//如果没有在地板上
			var tmpY:Number
			if (_isFloor != true) {
				tmpY = preHitCheckY();//获取底部离脚的距离，如果在允许容差范围内的话就直接将角色放到该位置。
				if (tmpY<_allowance) {
					this.y += tmpY;
					_isFloor = true;
				}else {
					//检测到离地面还有很多距离，施加重力;
					applyGravity();
					
				}
			}else {
				
				if (!_isMove) { return };
				//trace("----------->",_isMove)
				//如果已经在地板上了
				//判断朝向的左边还是右边;
				var ox:Number = (direction < 0)? -1:1;
				//判断是在上坡还是在下坡;
				//trace("ox:"+ox)
				//如果往目标点平移一个像素的时候撞到了，那这个就是上坡或者坡度太高爬不上。相反是下坡,或者是平路
				if (_collision.hitTestByPix(ox) == true) {
				//	trace('up')
					tmpY = preHitUpCheck(ox);
				//	trace('tmpY:'+tmpY)
					//坡度不高，可以爬上
					if (tmpY < _allowance) {
						this.y -= tmpY;
						this.x += ox;
					 
					}else {
						//坡度太高，爬不上,重新设定X坐标
						
						//this.x -= ox;
						//_hitWall = true;
						var Hit:Boolean = true;
						var backX:Number = 0;
						var px:Number;
						while (Hit) {
							px =-(Math.abs(ox) + backX) * ox;
							Hit = checkHit(px);
							backX++
						}
						
						this.x += px;
					}
					
				}else {
					//下坡和平路 对了
					//trace("horizontal or down")
					tmpY = preHitDownCheck(ox);
					if (tmpY < _allowance) {
						this.y += tmpY;
						this.x += ox;
					}else {
							
							this.x-=ox;
					}
				}
				
				
			}//end if
			
			
			
			
		
		}//end function;
		
			//判断是否在底部
			private 	function preHitCheckY() :Number {
				for (var i = 0; i < _allowance;i++ ) {
					if (_collision.hitTestByPix(0,i)) {
						return i;
					}
				}
				return _allowance + 1;
			}
			
			//下坡时的检测
			private function preHitDownCheck(ox:Number,ky:int=1) :Number {
				for (var i = 0; i < _allowance;i++ ) {
					if (_collision.hitTestByPix(ox,i)) {
						return i;
					}
				}
				return _allowance + 1;
			};
			
			//上坡时的检测
			private function preHitUpCheck(ox:Number):Number {
				for (var i = 0; i < _allowance;i++ ) {
					if (_collision.hitTestByPix(ox,-i)==false) {
						return i;
					}
				}
				return _allowance + 1;
			}
			
			//判断是否还是碰到障碍物(这里的障碍物都是静态的地形,不包括怪物和其他角色)
			private function checkHit(ox:Number) :Boolean{
				return _collision.hitTestByPix(ox,-2);
			}
			
		
		private function applyGravity() {
			if (_isFloor == false) {
				
				if (_startedJump == false) {
					_time = 0;
					_currentSpeed.y = (_isJumping)?-_jumpSpeed:0;
					_startedJump = true;
				}
			 	//trace("applyGravity:",_isJumping,_currentSpeed.y,"time:"+_time)
				_currentSpeed.y += ActWord.gravity  * _time;
				var s:Number=_currentSpeed.y  +0.5 * ActWord.gravity * _time * _time;
				_time += ActWord.timeRate;
				s = (s > ActWord.maxSpeed)?ActWord.maxSpeed:s;
				this.y += checkForApplyForce(s)
				_isFloor = _collision.hitTestByPix();
			}
			
		}
		
		private function checkForApplyForce(num:Number):Number {
			var b:Boolean = false
			var ny:Number = 0;
			var k:int = (num > 0)?1: -1;
			while (!b) {
				ny += k;
				b = _collision.hitTestByPix(0, ny);
				if (b == true || Math.abs(ny) >= Math.abs(num)) { break; }
				
			}
		
			return ny;
		};
		
		private function checkAfterTransform() {
			var b:Boolean = true
			var ny:Number = 0;
			while (b==true) {
				b = _collision.hitTestByPix(0, ny);
				//trace("ny:",b)
				ny--
			}
		
			this.y += ny;
			//trace("check:",ny);
		}
		
		
		
		
		public function get direction():int {
			return this.scaleX;
		}
		
		private function getCollisionContainer():Sprite {
			if (this.getChildByName("collisionSkin_mc") == null) {
				_collisionSkin = new Sprite();
				_collisionSkin.name = "collisionSkin_mc";
				this.addChild(_collisionSkin)
			}else {
				_collisionSkin = this.getChildByName("collisionSkin_mc") as Sprite;
				//_collisionSkin.visible = false;
			}
			 
			return _collisionSkin;
		}
		
		public function getPolygonFromSkin(target:Collision) {
			if (target == null) { return };
			
			_collisionSkin = getCollisionContainer();
			var len:uint = _collisionSkin.numChildren;
			//trace("getPolygonFromSkin len:",len)
		
			for (var i = 0; i < len; i++ ) {
				var p:DisplayObject = _collisionSkin.getChildAt(i) as DisplayObject;
			 
				if (p is CollisionPoint) {
				
					target.polygon.addPoint(p.x, p.y)
				}
				 
			}
		}
		
		public function getAnimation():CharacterAnimation {
			if (_animation != null) {
				return _animation;
			}else {
				if (this.getChildByName("animation_mc") != null) {
					_animation = this.getChildByName("animation_mc") as CharacterAnimation;
					return _animation;
				}else {
					return null
				}
			}
			
			
		}
		
		
	 
		
		
		
		
		
		
		
		
	}

}