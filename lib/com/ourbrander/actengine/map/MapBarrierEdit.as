package  com.ourbrander.actengine.map
{
	import com.ourbrander.actengine.math.Polygon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent
	import flash.utils.ByteArray;
	import flash.utils.setTimeout
	
	import flash.net.FileReference
	import com.ourbrander.actengine.ActManager
	import flash.geom.Point
	import com.ourbrander.actengine.map.MapManager
	
	
	
	/**
	 * ...
	 * @author liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 */
	public class MapBarrierEdit extends Sprite
	{
		private var _barrierList:Array//存储障碍对象列表
		private var _currentBarrier:PolygonCreation
		//private var _mapData:Array
		private var _drawEnable:Boolean
		private var _mapManager:MapManager
		private var _self:MapBarrierEdit
		public function MapBarrierEdit($width:Number=0,$height:Number=0) 
		{   
			super();
			
			init($width,$height);
		}
		
		private function init($width:Number, $height:Number) {
			_self=this
			_barrierList = [];
			//_mapData = [];
			_drawEnable = true;
			setSize($width,$height)
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		protected function addedToStage(e:Event):void 
		{
			
		
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage)
			//stage.doubleClickEnabled = true;
			//stage.addEventListener(MouseEvent.CLICK, clicked)
		
			stage.addEventListener(KeyboardEvent.KEY_UP,keybordHdl)
		}
		
		protected function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			//stage.removeEventListener(MouseEvent.DOUBLE_CLICK, clicked)
			stage.removeEventListener(KeyboardEvent.KEY_UP,keybordHdl)
		}
		
		protected function keybordHdl(e:KeyboardEvent):void 
		{
			
			if (_drawEnable!=true) {
				return 
			}
			
			if (e.keyCode == 8) {
				//trace("keyCode:"+_currentBarrier)
				if (_currentBarrier != null) {
				//	trace("_currentBarrier:"+_currentBarrier.name)
					removeBarrier(_currentBarrier)
				}
				
			}
			if (e.keyCode == 88) {
					createBarrier(stage.mouseX, stage.mouseY)
			}
			
			if (e.keyCode == 69 && e.ctrlKey == true) {
				saveData();
			}
			
			if (e.keyCode ==85 && e.ctrlKey == true) {
				updateMapMananger();
			}
			
		
		}
		
		private function clicked(e:MouseEvent) {
			 
			if (_drawEnable!=true) {
				return 
			}
			
			//if (e.target==this) {
				//trace("Has no barrier  in current postion.")
				//setTimeout(createBarrier,100,e.stageX,e.stageY)
				//if(Ke){
					//createBarrier(e.stageX, e.stageY)
				//}
		//	}
		}
		
		public function setSize(w:Number, h:Number) {
			if(w<=0 || h<=0){return}
			createCycle(1, 1)
			createCycle(w-1, 1)
			createCycle(w-1, h-1)
			createCycle(1, h-1)
			
			function createCycle(a, b) {
			
				_self.graphics.beginFill(0x0000,1)
			
				_self.graphics.drawCircle(a, b, 1)
				_self.graphics.endFill();
			}
		}
		private function createBarrier(x:Number,y:Number):PolygonCreation {
			var barrier:PolygonCreation = new PolygonCreation()
			barrier.x = Math.round(x);
			barrier.y = Math.round(y);
			barrier.name="p_"+x+"_"+y
			addChild(barrier)
			_barrierList.push(barrier)
			return barrier
		}
		public function set currentBarrier(target:PolygonCreation) {
			
			_currentBarrier=target
		}
		public function get currentBarrier():PolygonCreation {
			return _currentBarrier
		}
		public function removeBarrier(target:PolygonCreation) {
			var len:uint=_barrierList.length
			for (var i = 0; i < len; i++ ) {
				if(target==_barrierList[i]){
					removeChild(_barrierList[i])
					_barrierList[i] = null
					_barrierList.splice(i, 1)
					//trace("removed polygon:"+_barrierList.length)
					
					return true;
				}
			}
			return false
		}
		
		//以数组的形式返回生成的地图数据，[0]返回地图的一些参数，[1]是地图内所有障碍物（多边形）的信息。
		public  function getMapData():Array {
			var len:uint = _barrierList.length
		
			var $data:Array = [];
			for (var i = 0; i < len; i++ ) {
				var p:PolygonCreation=_barrierList[i] as PolygonCreation
				$data.push(p.polygon)
			}

			return $data
		}
		
		public function saveData() {
			var ar:Array = getMapData()
			var bt:ByteArray = new ByteArray()
			bt.writeObject(ar)
			var fr:FileReference = new FileReference()
			fr.save(bt, "map.dat");
		}
		
		public function updateMapMananger() {
	 
			MapManager.getInstance().setMapData(getMapData(),ActManager.getInstance().roundCount - 1);
			trace('updateMapMananger!')
		}
		
		public function loadMapData(data:Array) {
		 
			var polygons:Array = data as Array;
			 
			
			var len:uint = polygons.length
			 
		
			//$data[0] 是整个地图的各种附加属性
			//$data[1] 存储整个地图的多边形障碍的节点返回的也是一个数组[params][polygon],具体查看PolygonCreation类的get polygon():Array方法
			removedAllBarriers();
			for (var i = 0; i < len; i++ ) {
				
				var p:PolygonCreation = createBarrier(polygons[i].x, polygons[i].y)
					//trace('len', polygons[i].y, polygons[i].points[0].x)
					var $polygon:Polygon = new Polygon();
					$polygon.name = polygons[i].name;
					$polygon.x = polygons[i].x;
					$polygon.y = polygons[i].y;
					
					//trace('length:',polygons[i].points.length)
					var plen:uint = polygons[i].points.length;
					var points:Vector.<Point> = new Vector.<Point>();
					for (var k = 0; k < plen;k++ ) {
						points.push(new Point(polygons[i].points[k].x,polygons[i].points[k].y));
						
					}
					$polygon.points = points;
					//$polygon.points =polygons[i].points as Vector.<Point>();
				
				p.polygon = $polygon;
				p.x=polygons[i].x
				p.y=polygons[i].y
				addChild(p);
				_barrierList.push(p);
			}
			
			if (_mapManager == null) {
				_mapManager = MapManager.getInstance();
			}
			
			
			
			updateMapData();
			
		}
		
		private function removedAllBarriers() {
			//trace("removedAllBarriers")
			while (_barrierList.length > 0) {
				removeChild(_barrierList[0])
				_barrierList[0] = null
				_barrierList.splice(0, 1)
			}

		}
		
		//将地图的数据保存到mapManager对象去。
		public function updateMapData() {
			var len:uint = _barrierList.length
			for (var i:uint = 0; i < len; i++ ) {
				_barrierList[i].hiddenNode(false)
			}
		
			trace("updateMapData:"+this.width,this.height)
			var bitmapData:BitmapData = new BitmapData(this.width, this.height, true, 0x00000000);
			bitmapData.draw(this,null,null,null,null,true);
			_mapManager.setMapBitmap(bitmapData)
			
			if(ActManager.devMode==true){
				for (i = 0; i < len; i++ ) {
					_barrierList[i].hiddenNode(true)
				}
			}
		
		//	var bitmap:Bitmap = new Bitmap(bitmapData);
			//addChild(bitmap);
		}
		
		public function  set drawEnable(b:Boolean) {
			_drawEnable = b;
		}
		
		public function get drawEnable():Boolean {
			return _drawEnable;
		}
		
		
	}

}