package maps 
{
	import data.MapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 猫
	 */
	
	public class Terrain extends Sprite 
	{
		
		protected var _data:MapData;
		protected var _tiles:Vector.<Tile>;
		protected var _builds:Vector.<Build>;
		protected var _width:Number;
		protected var _height:Number;
		
		public function Terrain(width:uint, height:uint) 
		{
			setSize(width, height)
		}
		
		public function setSize(width:uint, height:uint):void {
			_width = width;
			_height = _height;
		}
		
		public function find(x:Number, y:Number):Array {
			return null
		}
		
		public function updateData():void {
			
		}
		
		public function createMap(d:MapData):void {
			_data = d;
			
			var len:int = d.list.length;
			var tile:Tile;
			var build:Build;
			for (var i:int; i < len;i++ ) {
				
			}
			
		}
		
		public function addBuild(target:Build,x:Number,y:Number):void {
			
		}
		
		public function removeBuild(target:Build):void {
			
		}
		
		public function moveBuild(target:Build,x:Number,y:Number):void {
			
		}
		
		public function addTile(tile:Tile,x:Number,y:Number):void {
			
		}
		
		public function removeTile(title:Tile):void {
			
		}
		
		public function updateTileTo(title:Tile, x:Number, y:Number):void {
			
		}
		
		
		
		
		
	}

}