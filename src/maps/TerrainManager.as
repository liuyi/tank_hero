package maps 
{
	import com.ourbrander.utils.Utils;
	import data.BgData;
	import data.BuildData;
	import data.MapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author liu yi
	 */
	public class TerrainManager 
	{
		private static var _instance:TerrainManager;
		
		protected var _builds:Vector.<BuildData>;
		protected var _bgs:Vector.<BgData>;
		protected var _maps:Vector.<MapData>
		public function TerrainManager() 
		{
			if (_instance != null) throw new Error("TerrainManager is a singleton class, please get it by getInstance() ");
		}
		
		public static function getInstance():TerrainManager {
			if (_instance == null) _instance = new TerrainManager();
			return _instance;
		}
		
			//add builds of maps to list, so player or map editor can use them.
			/**
			 * Now only accept XMLList
			 * @param	obj
			 */
		public function addBuilds(obj:Object):void {
			if (_builds == null) _builds = new Vector.<BuildData>();
		
			var list:XMLList
			if (obj is XMLList ) {
				list = obj as XMLList;
				var bData:BuildData
				var len:int= list.length();
				 //<item skinId="block01" across="false" depth="1" life="0" defence="0" friction="0"></item>
				for (var i:int = 0; i < len; i++ ) {
					bData = new BuildData();
					if (list[i].@skinId != null && list[i].@skinId != "") bData.skinId =Utils.trim(list[i].@skinId);
					if (list[i].@id != null && list[i].@id != "") bData.id =int(list[i].@id);
					if (list[i].@across != null && list[i].@across != "") bData.across =(Utils.trim(list[i].@across).toLowerCase()=="true")?true:false;
					if (list[i].@depth != null && list[i].@depth != "") bData.depth =Number(Utils.trim(list[i].@depth));
					if (list[i].@life != null && list[i].@life != "") bData.life =Number(Utils.trim(list[i].@life));
					if (list[i].@defence != null && list[i].@defence != "") bData.defence =Number(Utils.trim(list[i].@defence));
					if (list[i].@friction != null && list[i].@friction != "") bData.friction =Number(Utils.trim(list[i].@friction));
					_builds.push(bData)
				}
			}
		}
		
		//add background of maps to list, so player or map editor can use them.
		public function addBgs(obj:Object):void {
			if (_bgs == null) _bgs = new Vector.<BgData>();
		
			var list:XMLList
			var bData:BgData
			
		
			if (obj is XMLList ) {
	
				list = obj as XMLList;
				var len:int=list.length()
				 //<item skinId="block01" across="false" depth="1" life="0" defence="0" friction="0"></item>
				for (var i:int = 0; i < len; i++ ) {
					bData = new BgData()
					if (list[i].@skinId != null && list[i].@skinId != "") bData.skinId =Utils.trim(list[i].@skin);
					if (list[i].@id != null && list[i].@id != "") bData.id =int(list[i].@id);
					
					_bgs.push(bData)
				}
				
				 
			}
		}
		
		
		public function getBuildDataById(id:uint):BuildData {
			
			if (_builds == null || _builds.length == 0) return null;
			var len:uint=_builds.length
			for (var i:int; i <len;i++ ) {
				if (_builds[i].id == id) return _builds[i];
			}
			return null;
		}
		
		/**
		 * 
		 * @param	skin  ignore case
		 * @return
		 */
		public function getBuildDataBySkin(skin:String):BuildData {
			if (_builds == null || _builds.length == 0) return null;
			var len:uint=_builds.length
			for (var i:int; i <len;i++ ) {
				if (_builds[i].skinId == Utils.trim(skin).toLowerCase()) return _builds[i];
			}
			return null;
			
		}
		
		public function getBackgroundById(id:int):BgData {
			if (_bgs == null || _bgs.length == 0) return null;
			var len:uint=_bgs.length
			for (var i:int; i <len;i++ ) {
				if (_bgs[i].id == id) return _bgs[i];
			}
			return null;
		}
		
		public function getBackgroundBySkin(skin:String):BgData {
			if (_bgs == null || _bgs.length == 0) return null;
			var len:uint=_bgs.length
			for (var i:int; i <len;i++ ) {
				if (_bgs[i].skinId == skin) return _bgs[i];
			}
			return null;
		}
		
		
		public function getBuilds():Vector.<BuildData> {
			return _builds;
		}
		
		public function getBgs():Vector.<BgData> {
			return _bgs;
		}
		
		/**
		 * initialize maps from config xml file
		 * @param	obj
		 */
		public function addMaps(obj:Object):void {
			if (_maps == null) _maps = new Vector.<MapData>();
			var bData:MapData;
			var list:XMLList;
			if (obj is XMLList ) {
	
				list = obj as XMLList;
				var len:int = list.length();

				 //<item skinId="block01" across="false" depth="1" life="0" defence="0" friction="0"></item>
				for (var i:int = 0; i < len; i++ ) {
					bData = new MapData()
					
					 var ar:Array = list[i].toString().split(",");
					if (ar.length < 4) {
						throw new Error("Wrong map format!");
						return;
					}
					
					if (list[i].@id != null && list[i].@id != "") bData.id = int(list[i].@skin);
					bData.name = ar[0];
					bData.u = ar[1];
					bData.v = ar[2];
					var tiles:Array = ar.slice(ar[3]);
					for (var k:int = 0; k < tiles.length;k++ ) {
						tiles[k] = Number(tiles[k]);
					}
					
					bData.list = tiles;
					_maps.push(bData);
				}
				
			
			}
			
		}
		
		public function getMaps():Vector.<MapData> {
			return _maps;
		}
		public function getMapById(id:int) :MapData {
			if (_maps == null || _maps.length == 0) return null;
			var len:uint=_maps.length
			for (var i:int; i <len;i++ ) {
				if (_maps[i].id == id) return _maps[i];
			}
			return null;
		}
		
		public function getMapByName(name:String):MapData {
			if (_maps == null || _maps.length == 0) return null;
			var len:uint=_maps.length
			for (var i:int; i <len;i++ ) {
				if (_maps[i].name == name) return _maps[i];
			}
			return null;
		}
		
		
		public function createBuild(type:int):Build {
			var bData:BuildData;
			bData = getBuildDataById(type);
			if (bData == null) return null;
			var build:Build = new Build();
			build.data = bData.clone();
			build.skin = Utils.getObj(build.data.skinId) as Sprite;
			return build
		}
		
	}

}