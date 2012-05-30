package com.ourbrander.actengine.actObjs 
{
	/**
	 * ...
	 * @author liuyi
	 */
	import com.ourbrander.actengine.ActGamebox;
	import com.ourbrander.actengine.ActManager;
	import com.ourbrander.actengine.character.Character;
	import com.ourbrander.actengine.physics.ActWord
	import com.ourbrander.mathKit.MathKit
	import com.ourbrander.actengine.math.ActVector;
	import flash.geom.Point;
	import com.ourbrander.actengine.character.MoveStatus
	import com.ourbrander.actengine.physics.Collision;
	import flash.display.Sprite
	import com.ourbrander.actengine.physics.hitResult
	public class DynamicActObj  extends ActObj 
	{
		
		protected var _mass:Number;
		protected var _isGravity:Boolean;
		protected var _isCheckHitWithGameObj:Boolean
		protected var  _onHited:Function;
		protected var _hitType:Vector.<uint>
		protected var _actManager:ActManager
		
		
		protected var _isFloor:Boolean;// Is on the floor?
		protected var _isRoof:Boolean;// Is up to  the roof?
		protected var _isJumping:Boolean;
		protected var _moveStatus:String // horizon,uphill ,downhill,hitwall,jump
		
		protected var _speedY:Number;
		protected var _resilience:Number;
		protected var _currentSpeed:ActVector
		protected var _startedJump:Boolean
		protected var _prePosition:Point;
		
		
		
		
		private var _collisionSkin:Sprite;
		
		
		//temp
		private var result:hitResult;
		private var s:Number
		private var sx:Number
		private var ny:Number
		private var nx:Number
		private var k:int
		private var kx:int
		private var b:Boolean
		private var result_hit_arr:uint

		public function DynamicActObj() 
		{
			super();
			_isCheckHitWithGameObj = false;
			_hitType = new Vector.<uint>();
			_actManager = ActManager.getInstance();
			_currentSpeed = new ActVector();
			_resilience = 0.5;
			_moveStatus = MoveStatus.IDLE;
			_speedY =0;
			_prePosition = new Point();
			isGravity = false;
			_collision = new Collision();
			_collision.belong = this;
			getPolygonFromSkin(_collision);
			
		}
		
		
		public function set mass(m:Number) {
			
			_mass = (m <= 0)?0:m;
		}
		public function get mass():Number {
			return _mass;
		}
		
		public function get G():Number {
			return _mass * ActWord.gravity;
		}
		
		public function set isGravity(b:Boolean):void {
			_isGravity = b;
		}
		public function get isGravity():Boolean {
			return _isGravity;
		}
		
		//弹力，角色头碰到顶的时候会用到,默认为0.5
		public function set resilience(num:Number) {
			 
			_resilience =( num<0)?0:num;
		}
		
		public function get resilience():Number {
			return _resilience;
		}
		
		
		
		public function get  currentSpeed() :ActVector{
			if (_currentSpeed == null)
			_currentSpeed = new ActVector();
		
			return  new ActVector(_currentSpeed.x, _currentSpeed.y);
		}
		
		public function set isCheckHitWithGameObj(b:Boolean):void {
			_isCheckHitWithGameObj = b;
		}
		public function get isCheckHitWithGameObj():Boolean {
			return _isCheckHitWithGameObj;
		}
		
		protected function checkHitWithGameObj(type:uint=0):Boolean {
			return false;
		}
		
		
		public function addHitType(num:uint):void {
			_hitType.push(num);
		}
		
		public function removeHitType(num:uint):void {
			for (var i = 0; i < _hitType.length;i++ ) {
				if (_hitType[i] == num){
					_hitType.splice(i, 1);
					return;
				}
			}
		}
		
		public function set onHited(fun:Function):void {
			_onHited = fun;
		}
		
		public function get onHited():Function {
			return _onHited;
		}
		//计算与要进行碰撞检测的对象是否碰撞。
		protected function checkHit() :void{
			
			var olen:uint = _hitType.length;
			var target:*;
			var obj:Object
			for (var i :uint= 0; i < olen;i++ ) {
				obj = _actManager.objList[_hitType[i]];//返回的是一个对象
				for (var k in obj) {
					target = obj[k]
					if (target is ActObj ) {
						if (MathKit.polygon2Polygon(this.rectangle,target.rectangle)!=null) {
							target.onHited(this.uniqueId)
							this.onHited(k)
						}
					}else if (target is Character) {
					
						if (MathKit.polygon2Polygon(this.rectangle, target.body.rectangle) != null) {
							target.body.hitedBy(this.uniqueId);
							this.hitedBy(target.uniqueId);
						}
					}
					
				}
			}
			
		}//end function
		
		//当被碰撞后执行这个方法，index是对象的id.
		override internal function hitedBy(index:uint):void {
			
			//trace(this.name+"  "+"hited:"+index)
			if (_onHited != null) {
				_onHited(index);
			}
			
		}

		//********************************
		/*
		 * 从元件里获取碰撞检测的区域。
		 * */
		private function getCollisionContainer():Sprite {
			if (this.getChildByName("hitArea_mc") == null) {
				_collisionSkin = new Sprite();
				_collisionSkin.name = "hitArea_mc";
				this.addChild(_collisionSkin)
			}else {
				_collisionSkin = this.getChildByName("hitArea_mc") as Sprite;
			    _collisionSkin.visible = false;
			}
			
			return _collisionSkin;
		}
		/*
		 * 通过从元件里的获取的碰撞区域建立相对应的多边形
		 * */
		public function getPolygonFromSkin(target:Collision) {
			if (target == null) { return };
			
			_collisionSkin = getCollisionContainer();
			var len:uint = _collisionSkin.numChildren;
			//trace("getPolygonFromSkin len:",len)
		
			//这里原先是完全根据MC里的放置的点生成多边形。
			/*for (var i = 0; i < len; i++ ) {
				var p:DisplayObject = _collisionSkin.getChildAt(i) as DisplayObject;
			 
				if (p is CollisionPoint) {
				
					target.polygon.addPoint(p.x, p.y)
				}
				
			}*/
			//end
			//现在将其简化，那个可以适应为不规则多边形。但是在游戏中很少见，就不使用了。这里就简化成矩形。
			
			//createPolygon( -_collisionSkin.width / 2, -_collisionSkin.height, _collisionSkin.width, _collisionSkin.height);
			createPolygon( this.hitArea.x, this.hitArea.y, _collisionSkin.width, _collisionSkin.height);
		}
		
		/*
		 * 建立多边形.这里简化为空心的矩形。
		 * */
		public function createPolygon(x:Number, y:Number, w:Number, h:Number, u:uint=3, v:uint=4) {
			if (w <0 || h <0) {
				throw new Error("createPolygon w and h shouldn't be negative number ")
			}

			var i :int= 0;
			k=0
			var dw:Number = (w / (u-1)) ;
			var dh:Number = (h / (v-1)) ;
			for ( k = 0; k < u; k++ ) {
				_collision.polygon.addPoint(Math.round(x + dw * k), Math.round(y + dh * i));
			}
			k = u - 1;
			for (i = 1; i < v;i++ ) {
				_collision.polygon.addPoint(Math.round(x + dw * k), Math.round(y + dh * i));
			}
			i = v - 1;
		 	for ( k = u - 2; k >= 0; k-- ) {
				_collision.polygon.addPoint(Math.round(x + dw * k), Math.round(y + dh * i));
				
			}
			k = 0
			for ( i=v-2; i >0;i-- ) {
				_collision.polygon.addPoint(Math.round(x + dw * k), Math.round(y + dh * i));
			}
			
		}
		
		
		//*********************************
		
		
		//*********重力相关的方法*******************************
			//移动的相关方法完
		
		
		protected function checkIsFloor() :Boolean{
			result = _collision.hitTestByPix(0, 0, [2]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				result_hit_arr=result.hitPoints[2][0]
				if (result_hit_arr == _collision.directionList[2][0] || result_hit_arr== _collision.directionList[2][_collision.directionList[2].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
					return  (_collision.pointTest(result_hit_arr, 1, 2) &&  _collision.pointTest(result_hit_arr, -1, 2))//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}

		}
		
		
		
	protected function ApplyForce():void {
			if (!_isGravity)
			return 
			_isFloor = checkIsFloor();
			_isRoof = checkIsRoof();
			if(_isRoof && _isFloor)
			return
			if (_isJumping == true && _startedJump != true) { _startedJump = true; _currentSpeed.y += -_speedY }
			//如果在空中 或者处于跳起状态
			if (!_isFloor || _isJumping == true) {
				_moveStatus = MoveStatus.JUMP;
				_currentSpeed.y += ActWord.gravity * ActWord.timeRate
				if (_isRoof && _currentSpeed.y <0){
					_currentSpeed.y = Math.abs(_currentSpeed.y)*_resilience;//增加部分反弹力
				}
				
				
				s= _currentSpeed.y + 0.5 * ActWord.gravity * ActWord.gravity;
				s = (Math.abs(s) <= ActWord.maxSpeed)?s:ActWord.maxSpeed;
				if(_currentSpeed.x>0){
					sx = _currentSpeed.x - 0.5 * ActWord.airFriction * ActWord.airFriction;
				}else {
					sx = _currentSpeed.x + 0.5 * ActWord.airFriction * ActWord.airFriction;
				}
				sx = (Math.abs(sx) <= ActWord.maxSpeed)?sx:ActWord.maxSpeed;
				var a = checkForApplyForce(sx, s);
				s =a[1];
				sx = a[0];
				//trace(_currentSpeed.y ,s)
				this.y += s;
				this.x += sx;
				_isFloor = checkIsFloor();
				if (_isFloor == true  ) {
					if(_currentSpeed.y>0){
						this.y--;
					}
					resetSpeedY()
					
				}
			
				
			
			}else {
				//如果不是处于跳起状态，或者人在地板上。
				resetSpeedY();
			}
		}
		
		
		
		
		
		protected  function resetSpeedY() {
			_currentSpeed.y = 0;
			_currentSpeed.x = 0;
			_startedJump = false;
			 _isJumping = false;
			 _moveStatus = MoveStatus.IDLE;
		}
		
		
		protected function checkForApplyForce(numX:Number,numY:Number):Array {
			b=false
			ny = 0
			nx = 0
			var vk:Number = numX / numY;
			
			
			if (numY > 0) { k = 3 } else { k = -3; }
			if (numX > 0) { kx = 3 } else { kx = -3; }
			
			while (!b) {
				ny += k;
				nx += ny * vk;
				
				b = checkForGravity(nx, ny);
				if (b == true || Math.abs(ny) >= Math.abs(numY)) { break; }
				
			}
		
			return [nx,ny];
		};
		
		/*
		 * * 检查Y轴的碰撞情况，只针对静态地图，返回是否能通过。
		 * */
		protected function checkForGravity(ox:Number,oy:Number):Boolean {
			result = _collision.hitTestByPix(ox, oy, [2]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				result_hit_arr=result.hitPoints[2][0] 
				if (result_hit_arr== _collision.directionList[2][0] || result_hit_arr== _collision.directionList[2][_collision.directionList[2].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
					return (_collision.pointTest(result_hit_arr, 1+ox, 1+oy) &&  _collision.pointTest(result_hit_arr, -1+ox, 1+oy))
					//return checkIsOnEdge(result.hitPoints[2][0])//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}
			
			
		
		}//end function
		
		
		/*
		 * 检测是不是撞到顶了。
		 * 
		 * 
		 * */
		
		protected function checkIsRoof() :Boolean {
			//var d = 0;
			result = _collision.hitTestByPix(0, 0, [0]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				result_hit_arr = result.hitPoints[0][0];
				
				if (result_hit_arr== _collision.directionList[0][0] || result_hit_arr== _collision.directionList[0][_collision.directionList[0].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
					return  (_collision.pointTest(result_hit_arr, 1, 1) && _collision.pointTest(result_hit_arr, -1, 1));
					//return checkIsOnEdge(result.hitPoints[d][0])//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}
			
			
			
			
		}
		
		
	//************************************************************
	
	
		public function addForce(vector:ActVector) {
			_currentSpeed.add(vector)
		}

		public function onUpdate():void { 
			checkHit(); 
			if (_collision != null) {				
			    ApplyForce();
			}
			_prePosition.x = this.x;
			_prePosition.y = this.y;
		}
		
		public function afterUpdate():void{}
		public function beforeUpdate():void{}
		
	}

}