package com.ourbrander.actengine.character 
{
	import com.ourbrander.actengine.ActGamebox;
	import com.ourbrander.actengine.ActGameRound;
	import com.ourbrander.actengine.actObjs.DynamicActObj;
	import com.ourbrander.actengine.editer.CollisionPoint;
	import com.ourbrander.actengine.math.ActVector;
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
	import flash.geom.Point;
	import com.ourbrander.actengine.character.MoveStatus
	import com.ourbrander.actengine.physics.ActWord
	import com.ourbrander.actengine.map.MapManager
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
		//display
		private var _animationContainer:Sprite;
		private var _collisionSkin:Sprite;
		private var _belong:Character
	 
		


		
		private var _allowance:uint;
		
			protected var _isFloor:Boolean;// Is on the floor?
		protected var _isRoof:Boolean;// Is up to  the roof?
		protected var _isJumping:Boolean;
		protected var _moveStatus:String // horizon,uphill ,downhill,hitwall,jump
		protected var _jumpHeight:Number;
		protected var _jumpedHeight:Number
		protected var _jumpSpeed:Number;
		protected var _resilience:Number;
		protected var _currentSpeed:ActVector
		protected var _startedJump:Boolean
		protected var _prePosition:Point;
		
		
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

			_collision = new Collision();
			_collision.belong = this;
			_allowance = 4;
			_currentSpeed = new ActVector();
			_resilience = 0.5;
			_moveStatus = MoveStatus.IDLE;
			_jumpSpeed =0;
			_prePosition = new Point();
			this.isGravity = true;
			getPolygonFromSkin(_collision);
			
		}
		override public function onUpdate() :void{
		
			
			
			_prePosition.x = this.x;
			_prePosition.y = this.y;
		
		
		}
		override public function afterUpdate() :void{
		
			//checkAfterTransform();
		}
		
		
		public function addAnimation(animation:CharacterAnimation) {
			getAnimation()
			if (_animation != null) {
				removeChild(_animation)
			}
			_animation = animation;
			_animation.name = "animation_mc";
			addChild(_animation);
		 
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
	 
		
	
		public function get  currentSpeed() :ActVector{
			if (_currentSpeed == null)
			_currentSpeed = new ActVector();
		
			return  new ActVector(_currentSpeed.x, _currentSpeed.y);
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
			_jumpSpeed =( num<0)?0:num;
		}
		
		public function get jumpSpeed():Number {
			return _jumpSpeed;
		}
		
		//弹力，角色头碰到顶的时候会用到,默认为0.5
		public function set resilience(num:Number) {
			 
			_resilience =( num<0)?0:num;
		}
		
		public function get resilience():Number {
			return _resilience;
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
		
			if (_collision != null) {				
			    ApplyForce();
			}else {
				return false;
				
			}
		
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
		
		
		
		//移动的相关方法完
		
		
		protected function checkIsFloor() :Boolean{
			var result:hitResult = _collision.hitTestByPix(0, 0, [2]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				if (result.hitPoints[2][0] == _collision.directionList[2][0] || result.hitPoints[2][0] == _collision.directionList[2][_collision.directionList[2].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					
					return checkIsOnEdge(result.hitPoints[2][0])//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}
			
			//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
			
			function checkIsOnEdge(pid:uint):Boolean {
				
				var a = _collision.pointTest(pid, 1, 2);
				var b = _collision.pointTest(pid, -1, 2);
				
				if (a == true && b == true) {
					//trace("1 point on the floor pid:"+pid+" a:"+a+" b:"+b)
					return true;
				}else {
					//trace("1 point on the edge pid:"+pid+" a:"+a+" b:"+b)
					return false;
				}
			}
			
		}
		
		/*
		 * 施加力(简化为对角色施加速度)
		 * */
		protected function ApplyForce() {
			//力是一个向量
			//var currentForce:ActVector=
			//f=ma,v1=v1+a*t,s=v1+0.5*a*t*t
			_isFloor = checkIsFloor();
			_isRoof = checkIsRoof();
			if(_isRoof && _isFloor)
			return
			//如果是刚开始起跳，则给当前速度加上一个起跳的速度。
			if (_isJumping == true && _startedJump != true) { _startedJump = true; _currentSpeed.y += -_jumpSpeed }
			
			//如果在空中 或者处于跳起状态
			if (!_isFloor || _isJumping == true) {
				_moveStatus = MoveStatus.JUMP;
				_currentSpeed.y += ActWord.gravity * ActWord.timeRate
				if (_isRoof && _currentSpeed.y <0){
					_currentSpeed.y = Math.abs(_currentSpeed.y)*_resilience;//增加部分反弹力
				}
				
				
				var s:Number = _currentSpeed.y + 0.5 * ActWord.gravity * ActWord.gravity;
				s = (Math.abs(s) <= ActWord.maxSpeed)?s:ActWord.maxSpeed;
				s = checkForApplyForce(s);
				//trace(_currentSpeed.y ,s)
				this.y += s;
				_isFloor = checkIsFloor();
				if (_isFloor == true  ) {
					if(_currentSpeed.y>0){
						this.y--;
						
					}
					resetSpeedY()
					
				}
			
				//scrollMapY(s);
				//上下晃动好像不太舒服,暂时不要。
				/* if (_isJumping == true) {
						 
					scrollMapY(this.y - _prePosition.y);
				} */
			
			}else {
				//如果不是处于跳起状态，或者人在地板上。
				resetSpeedY();
			}
			
			
		}
		
		
		
		protected  function resetSpeedY() {
			_currentSpeed.y = 0;
			_startedJump = false;
			 _isJumping = false;
			 _moveStatus = MoveStatus.IDLE;
		}
		
		/*
		 * 检查Y轴的碰撞情况，只针对静态地图，返回实际能走到的位移。
		 */
		protected function checkForApplyForce(num:Number):Number {
			var b:Boolean = false
			var ny:Number = 0;
			var k:int = (num > 0)?1: -1;
			while (!b) {
				ny += k;
				b = checkForGravity(0, ny);
				if (b == true || Math.abs(ny) >= Math.abs(num)) { break; }
				
			}
		
			return ny;
		};
		/*
		 * * 检查Y轴的碰撞情况，只针对静态地图，返回是否能通过。
		 * */
		protected function checkForGravity(ox:Number,oy:Number):Boolean {
			var result:hitResult = _collision.hitTestByPix(ox, oy, [2]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				if (result.hitPoints[2][0] == _collision.directionList[2][0] || result.hitPoints[2][0] == _collision.directionList[2][_collision.directionList[2].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					
					return checkIsOnEdge(result.hitPoints[2][0])//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}
			
			//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
			
			function checkIsOnEdge(pid:uint):Boolean {
				
				var a = _collision.pointTest(pid, 1+ox, 1+oy);
				var b = _collision.pointTest(pid, -1+ox, 1+oy);
				
				if (a == true && b == true) {
					//trace("1 point on the floor pid:"+pid+" a:"+a+" b:"+b)
					return true;
				}else {
					//trace("1 point on the edge pid:"+pid+" a:"+a+" b:"+b)
					return false;
				}
			}
		}//end function
		
		
		/*
		 * 检测是不是撞到顶了。
		 * 
		 * 
		 * */
		
		protected function checkIsRoof() :Boolean {
			var d = 0;
			var result:hitResult = _collision.hitTestByPix(0, 0, [d]);
			
			if (result.hitCount<1) {
				return false;
			}else if (result.hitCount == 1) {
				//如果碰撞到的点正好是处于矩形的两个顶点
				if (result.hitPoints[d][0] == _collision.directionList[d][0] || result.hitPoints[d][0] == _collision.directionList[d][_collision.directionList[d].length - 1] ) {
					//_collision.singleHitTest(collision.directionList[2][0])
					
					return checkIsOnEdge(result.hitPoints[d][0])//只是在polygon里的索引号
				}else {
					return true;
				}
				
			}else {
				return true;
			}
			
			//判断在一个点碰撞的时候是处于墙壁的边缘还是在地面上。
			
			function checkIsOnEdge(pid:uint):Boolean {
				
				var a = _collision.pointTest(pid, 1, 1);
				var b = _collision.pointTest(pid, -1, 1);
				
				if (a == true && b == true) {
					//trace("1 point on the floor pid:"+pid+" a:"+a+" b:"+b)
					return true;
				}else {
					//trace("1 point on the edge pid:"+pid+" a:"+a+" b:"+b)
					return false;
				}
			}
		}
	
		

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
			
			createPolygon( -_collisionSkin.width / 2, -_collisionSkin.height, _collisionSkin.width, _collisionSkin.height);
		}
		
		/*
		 * 建立多边形.这里简化为空心的矩形。
		 * */
		public function createPolygon(x:Number, y:Number, w:Number, h:Number, u:uint=3, v:uint=4) {
			if (w <0 || h <0) {
				throw new Error("createPolygon w and h shouldn't be negative number ")
			}

			var i :int= 0;
			var k:int = 0;
			var dw:Number = (w / (u-1)) ;
			var dh:Number = (h / (v-1)) ;
			for ( k = 0; k < u; k++ ) {
				addPointToCollision()
			}
			k = u - 1;
			for (i = 1; i < v;i++ ) {
				addPointToCollision()
			}
			i = v - 1;
		 	for ( k = u - 2; k >= 0; k-- ) {
				addPointToCollision()
				
			}
			k = 0
			for ( i=v-2; i >0;i-- ) {
				addPointToCollision()
			}
			//trace("created polygon:" + _collision.polygon.points)
			function addPointToCollision() {
				_collision.polygon.addPoint(Math.round(x + dw * k), Math.round(y + dh * i));
				var mc:Sprite = new collsion_point();
				mc.x=Math.round(x + dw * k)
				mc.y= Math.round(y + dh * i)
				_collisionSkin.addChild(mc);
			}
		}
		
		
	}

}