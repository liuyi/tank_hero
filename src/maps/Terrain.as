package maps 
{
	import com.ourbrander.utils.Utils;
	import data.BuildData;
	import data.MapData;
	import flash.display.DisplayObjectContainer;
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
		
		public var tileSkin:String;
		/**
		 * if set autoFit to true, then if the skin of tile and build small or bigger than tile width/height, scale it to the same size as tile width/height;
		 * tile with =_width/_data.u, tile height = _height/_data.v
		 */
		public var autoFit:Boolean = false;
		
		protected var _terrainManager:TerrainManager
		
		protected var _tileLayer:Sprite;
		protected var _buildLayer:Sprite;
		protected var _playerLayer:Sprite;
		protected var _overBuildLayer:Sprite;
		protected var _effectLayer:Sprite;
		
		public function Terrain(width:uint, height:uint) 
		{
			
			setSize(width, height);
			//create all layers for tile, build,player and effect such as smoke, fire, cloud etc.
			_terrainManager = TerrainManager.getInstance();
			_tileLayer = new Sprite();
			_buildLayer = new Sprite();
			_playerLayer = new Sprite();
			_overBuildLayer = new Sprite();
			_effectLayer = new Sprite();
			
			addChild(_tileLayer);
			addChild(_buildLayer);
			addChild(_playerLayer);
			addChild(_overBuildLayer);
			addChild(_effectLayer);
			
		}
		
		public function setSize(width:uint, height:uint):void {
			_width = width;
			_height = height;
		}
		
		public function find(x:Number, y:Number):Array {
			return null
		}
		
		public function updateData():void {
			
		}
		
		public function createMap(d:MapData):void {
			_data = d;
			var list:Array = d.list;
			var len:int = list.length;
			var u:int = _data.u;
			var v:int = _data.v;
			var tile:Tile;
			var build:Build;
			var bData:BuildData
			var tileWidth:int=_width/u;
			var tileHeight:int = _height / v;
			
			trace("map length:"+len);
			for (var i:int; i < len; i++ ) {
				
				//create tile from map data.
				tile = new Tile();
				tile.id = i;
				tile.buildType = list[i];
				tile.x = i % u * tileWidth;
				tile.y = int(i / u) * tileWidth;
				if(tileSkin!="" ){
				tile.skin = Utils.getObj(tileSkin) as Sprite;
				tile.skin.x = tile.x;
				tile.skin.y = tile.y;
					if(autoFit){
						tile.skin.width = tileWidth;
						tile.skin.height = tileHeight;
					}
				}
				else tile.skin = new Sprite();
				_tileLayer.addChild(tile.skin);
			
				
				//create build for every tile
				//if there is a build on the tile, create it and add to tile.
				build = _terrainManager.createBuild(tile.buildType)
				if (build != null) {
					build.parent = i;
					build.x = tile.x;
					build.y = tile.y;
					if (autoFit) {
						build.skin.width = tileWidth;
						build.skin.height = tileHeight;
					}
					if (build.data.depth > 0) _overBuildLayer.addChild(build.skin);
					else _buildLayer.addChild(build.skin);
					
				
				}
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