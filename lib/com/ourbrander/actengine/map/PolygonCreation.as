package com.ourbrander.actengine.map 
{
	import com.ourbrander.actengine.math.Polygon;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 */
	public class PolygonCreation extends Sprite
	{
		private var _polygon:Polygon
		private var _thick:Number
		private var _lineAlpha:Number
		private var _shapeAlpha:Number
		private var _nodeList:Array//所有NODE节点对象
		private var _isDrawing:Boolean
	
		public function PolygonCreation() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, clicked)
			addEventListener(MouseEvent.MOUSE_UP, up)
			init();
			
		}
		
		
		public function init(thick:Number = 1, lineAlpha:Number = 1, shapeAlpha:Number = 0.5) {
			
			_thick = thick
			_lineAlpha = lineAlpha
			_shapeAlpha = shapeAlpha
			_nodeList = []
			_polygon = new Polygon()
			createNode(0, 0)
			stopDraw()
		}
		
		public function hiddenNode(b:Boolean) {
			var len:uint = _nodeList.length;
			for (var i = 0; i < len;i++ ) {
				_nodeList[i].visible = b;
			}
		}
		public function createNode(x:Number, y:Number,after:PolygonNode=null):PolygonNode {
			
			var node:PolygonNode = new PolygonNode()
			node.x = x
			node.y=y
			this.addChild(node);
			addtoList(node, after)
			startDraw();
			
			return node
		}
		public function removeNode(target:PolygonNode) {
			
			var len:uint=_nodeList.length
			for (var i = 0; i < len;i++ ) {
				if (_nodeList[i] == target) {
					
					this.removeChild(target)
					_nodeList[i] = null
					_nodeList.splice(i, 1)
					
				}
			}
			
			if (_nodeList.length <= 0) {
				
				var mp:MapBarrierEdit = parent as MapBarrierEdit
				mp.removeBarrier(this)
			}
			
		}
		 
		
		private function clicked(e:MouseEvent) {
			if (e.target == this) {
				startDrag()
			}
			if(e.shiftKey==false) {
				var mp:MapBarrierEdit = parent as MapBarrierEdit
				mp.currentBarrier = this
				//trace("currentBarrier"+this )
			}
			startDraw();
		}
		protected function up(e:MouseEvent):void 
		{
			if (e.target == this) {
				stopDrag()
				//trace(">"+this.polygon)
			}
			stopDraw();
		}
		private function addtoList(node:PolygonNode, after:PolygonNode = null) {
			if(after==null){
				_nodeList.push(node);
			}else {
				var len:uint=_nodeList.length
				var tmpNodeList:Array = []
				for (var i = 0; i < len; i++ ) {
					tmpNodeList.push(_nodeList[i])
					if (after==_nodeList[i]) {
						tmpNodeList.push(node);
					}
				}//end for;
				_nodeList = tmpNodeList;
			}
		}
		
		private function draw(e:Event = null) {
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xcccccc, 0)
			this.graphics.beginFill(0x000000,1)
			var len:uint = _nodeList.length
			var moveto:Boolean=false
			for (var i = 0; i < len; i++ ) {
				var g:uint = (i + 1 >= len)?0:i + 1;
				if(moveto==false){
					this.graphics.moveTo(_nodeList[i].x, _nodeList[i].y);
					moveto=true
				}
			    this.graphics.lineTo(_nodeList[g].x,_nodeList[g].y);
				
			}
			
			this.graphics.endFill();
			
			
		}
		
		public function startDraw() {
			if (_isDrawing!=true) {
				 this.addEventListener(Event.ENTER_FRAME,draw)
			}
		  
		}
		public function stopDraw() {
			 this.removeEventListener(Event.ENTER_FRAME,draw)
		}
		
		public function get polygon():Polygon {
			//polygon=[[store polygon's params],[store all peak info]]
			//polygon[0]=params,params=[x,y,name]
			//polygon[1]=data,data=[node1,node2,node3,....],node=[x,y,parent's name]
			
			/*
			 * old
			 * /
			var len:uint = _nodeList.length
			 
			 var peak=[]
			for (var i = 0; i < len; i++ ) {
				 
				var g:Point =localToGlobal(new Point(Math.round(_nodeList[i].x),Math.round(_nodeList[i].y)))
				peak.push([g.x, g.y, this.name])//x,y,属于哪一个多边形;
				
			}
			 
			var params:Array = [this.x, this.y, this.name]//暂时放x,y,名字属性，以后根据游戏地形增加各种附加属性。
			_polygon[0] = params
			_polygon[1]=peak
			return _polygon
			/*old end*/
			
			var len:uint = _nodeList.length;
			var $points:Vector.<Point> = new Vector.<Point>();
			for (var i = 0; i < len; i++ ) {
				 
				//var g:Point = localToGlobal(new Point(Math.round(_nodeList[i].x), Math.round(_nodeList[i].y)));
				var g:Point =new Point(Math.round(_nodeList[i].x), Math.round(_nodeList[i].y))
				//peak.push([g.x, g.y, this.name])//x,y,属于哪一个多边形;
				$points.push(g);
				
			}
			_polygon.points = $points;
			_polygon.x = this.x;
			_polygon.y = this.y;
			_polygon.name = this.name;
			return _polygon;
		}
		
		//根据已有的数据生成多边形。
		public function set polygon($polygon:Polygon) {
		
			_polygon = $polygon;
			buildPolygon();
		}
		private function buildPolygon() {
			
			//old,use array
			/*this.x=_polygon[0][0]
			this.y = _polygon[0][1]
			this.name = _polygon[0][2]
			var len:uint = _polygon[1].length
		    removeNode(_nodeList[0])
			_nodeList=[]
			for (var i = 0; i < len; i++ ) {
				var nodeLocalPoint:Point = globalToLocal(new Point(_polygon[1][i][0], _polygon[1][i][1]))
				createNode(nodeLocalPoint.x, nodeLocalPoint.y)
				
			}
			draw()*/
			
			//new use obj
		 
			this.x = _polygon.x;
			this.y = _polygon.y;
			this.name = _polygon.name;
			var len:uint = _polygon.points.length;
			   removeNode(_nodeList[0])
			_nodeList = [];
			for (var i = 0; i < len; i++ ) {
				//var nodeLocalPoint:Point = globalToLocal(_polygon.points[i])
				//createNode(nodeLocalPoint.x, nodeLocalPoint.y)
				createNode(_polygon.points[i].x, _polygon.points[i].y)
			}
			draw();
			
		}
		
		
	}//end class

}