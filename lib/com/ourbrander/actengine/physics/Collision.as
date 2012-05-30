package com.ourbrander.actengine.physics 
{
	import com.ourbrander.actengine.ActGameRound;
	import com.ourbrander.actengine.ActManager;
	import com.ourbrander.actengine.actObjs.ActObj;
	import com.ourbrander.actengine.character.Character;
	import com.ourbrander.actengine.map.MapManager;
	import com.ourbrander.actengine.math.actRectangle;
	import com.ourbrander.actengine.math.Polygon;
	import flash.geom.Point;
	/**
	 * ...
	 * @author liuyi
	 */
	public class Collision 
	{
		
		protected var _polygon:Polygon
		protected var _mapManager:MapManager
		protected var _actManager:ActManager
		protected var _direction:Array
		protected var _belong:ActObj
		
		
		protected var _polygonPoints:uint
		
		
		//temp
		protected var mapX:Number
		protected var  mapY:Number
		protected var $hitResult:hitResult
		protected var dlen:uint
		protected var len:uint
		protected var gp:Point
		protected var m:int
		protected var _alpha:int
		protected var directions:Array
		private var i:uint
		private var k:uint
		private var hit_id:uint
		
		
		
		
		public function Collision() 
		{
			init();
		};
		
		protected function init() {
			_mapManager = MapManager.getInstance();
			_actManager = ActManager.getInstance();
			directions = [0, 1, 2, 3]
			$hitResult = new hitResult();
		
		}
		public function set polygon(p:Polygon) {
			
			_polygon = p;
			_polygonPoints = _polygon.points.length;
			initDirection();
		}
		
		public function get polygon():Polygon {
			if (_polygon == null) {
				_polygon = new Polygon();
			}
			return _polygon;
		}
		
		public function set belong(target:ActObj) {
			_belong = target;
		}
		
		public function get belong():ActObj {
			return _belong;
		}
		
		public function get directionList():Array {
			return _direction;
		}
		
		 
		
		public function hitTestByPix(offsetX:Number = 0, offsetY:Number = 0, directionId:Array = null,debug:Boolean=true):hitResult {
		
			 
			 mapX = _actManager.gamebox.currentRound.mapX; 
			 mapY = _actManager.gamebox.currentRound.mapY; 
			
			
		
			//trace($hitResult.hitCount,$hitResult.hitPoints)
			if (directionId == null) {directionId =directions}
			dlen = directionId.length
			if (_direction==null) {	initDirection();}
			
			/*for (_mapManager.getMapData(_actManager.currentGameRound)) {
				
			}*/
			//use bitmapdata test first
			/*
			*     * * *
			*     * * *
			*     * * *
			* 
			*     5 1 6
			*     4    2
			*     8 3 7
			*  9 means all points
			* */
	
			$hitResult.hitCount = 0;
			$hitResult.hitPoints=[]
			if (_mapManager.getMapBitmap() == null) { return $hitResult; }
		 	if (_polygonPoints == 0) { _polygonPoints = _polygon.points.length }
			// _polygonPoints = _polygon.points.length ;
			
			 
			
				for (k = 0; k <dlen;k++ ) {
					len = _direction[directionId[k]].length;
					//trace("directionId:",directionId,_direction,">>>"+_direction[directionId])
					for (  i = 0; i < len;i++ ) {
							gp = _belong.localToGlobal( getPoint(_direction[directionId[k]][i]));
						    gp=_actManager.gamebox.getPositionFromGlobal(gp);
							/*gp =  _polygon.points[_direction[directionId[k]][i]];
							gp.x = _belong.x + gp.x;
							gp.y = _belong.y + gp.y;*/
							
						   //trace(gp.x,gp.y)
							
							m= _mapManager.getMapBitmap().getPixel32(gp.x + offsetX-mapX, gp.y + offsetY-mapY) ;
							//m= _mapManager.getMapBitmap().getPixel32(gp.x + offsetX, gp.y + offsetY) ;
						//	_alpha = m >> 24 & 0xFF  
							//透明度超过50%的才能算是障碍物。解决在向上的边缘移动时会轻微抖动的现象。
							if ((_mapManager.getMapBitmap().getPixel32(gp.x + offsetX - mapX, gp.y + offsetY - mapY) >> 24 & 0xFF  ) > 128) {
								
								if ($hitResult.hitPoints[directionId[k]]==null) {
									$hitResult.hitPoints[directionId[k]]=[]
								}
								$hitResult.hitPoints[directionId[k]].push(_direction[directionId[k]][i]);//将碰撞的点存入到碰撞点列表
								$hitResult.hitCount++;
								 
							}
					}
				
				}//end for
		 
				
			
			return $hitResult;
		}
		
		
		
		//测试单个点
		public function pointTest(pId:uint,offsetX:Number, offsetY:Number):Boolean
		{
			gp.x = getPoint(pId).x
			gp.y=getPoint(pId).y
			 gp = _belong.localToGlobal( gp );
			gp=_actManager.gamebox.getPositionFromGlobal(gp);
			mapX = _actManager.gamebox.currentRound.mapX; 
			mapY = _actManager.gamebox.currentRound.mapY; 
			
			/*if (_mapManager.getMapBitmap().getPixel32(gp.x + offsetX-mapX, gp.y + offsetY-mapY) > 0) {
				return true;
			}else {
				return false;
			}*/
			
			return _mapManager.getMapBitmap().getPixel32(gp.x + offsetX - mapX, gp.y + offsetY - mapY) > 0;
		}
		
	 
		
		public function destory() {
			_mapManager = null;
			_polygon = null;
			_actManager = null;
		}
		
		protected function initDirection() {
		
			if (_direction == null) {
				_direction = [];
				
				_direction['top'] = 0;
				_direction['right'] = 1;
				_direction['bottom'] = 2;
				_direction['left'] = 3;
			};
			setPoints();
	 
		}
		
 
		
		
		//set 4 corner point
		//检测碰撞的时候只需要根据移动的方向来做选择相应的几个点做碰撞测试（相对于静态的地图和障碍物）
		protected function setPoints() {
	
			/*var l:Vector.<uint> = new Vector.<uint>(); //left
			var t:Vector.<uint> = new Vector.<uint>();//top
			var r:Vector.<uint>= new Vector.<uint>();//right
			var b:Vector.<uint> = new Vector.<uint>();//bottom
			l.push(0);
			r.push(0);
			t.push(0);
			b.push(0);
			*/
			var l:Array=[]
			var t:Array=[]
			var r:Array=[]
			var b:Array=[]
			l[0] = 0;
			t[0] = 0;
			r[0] = 0;
			b[0] = 0;
			
			
			
			//today' work 2010.10.25
			var plen:uint=_polygon.points.length;
			for (var i :uint= 0; i < plen; i++ ) {
				//trace('--->',i,getPoint(i).x,getPoint(l[0]).x)
				if (getPoint(i).x<getPoint(l[0]).x) {
					l.splice(0,l.length);
					l.push(i);
					//trace('Left:',l)
				}else if(getPoint(i).x==getPoint(l[0]).x && i!=0){
					l.push(i);
					//trace('Left add:',l)
				}
				
				if (getPoint(i).y < getPoint(t[0]).y) {
				
					t.splice(0,t.length);
					t.push(i);
					//trace('Top:',t)
				}else if (getPoint(i).y == getPoint(t[0]).y && i!=0) {
					t.push(i);
				}
				
				if (getPoint(i).x>getPoint(r[0]).x) {
					r.splice(0,r.length);
					r.push(i);
					//trace('Right:',r)
				}else if (getPoint(i).x == getPoint(r[0]).x && i!=0) {
					r.push(i);
				}
				
				if (getPoint(i).y>getPoint(b[0]).y) {
					b.splice(0,b.length);
					b.push(i);
					//trace('Bottom:',b)
				}else if (getPoint(i).y == getPoint(b[0]).y && i != 0) {
					
					b.push(i);
				}
			}//end for
		 
			//trace("4 corner:", "left:" + l, "top:" + t, "right:" + r, "bottom" + b)
			
			_direction.push(t)
			_direction.push(r)
			_direction.push(b)
			_direction.push(l)

		}
		protected  function getPoint(num:uint):Point {
				return _polygon.points[num];
		}
		
		
		/*protected function hitTestWithGameObject():Boolean {
			
		}*/
		
		
		
		
		
	}

}