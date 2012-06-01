package test 
{
	import com.ourbrander.components.BasicButton;
	import com.ourbrander.data.DataManager;
	import com.ourbrander.loader.EasyLoader;
	import com.ourbrander.loader.EasyLoaderEvent;
	import com.ourbrander.loader.XmlLoader;
	import com.ourbrander.utils.Utils;
 
	import components.SimpleBtn;
	import components.TileBox;
	import data.MapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import maps.Terrain;
	import maps.TerrainManager;
	import pages.BasicPage;
	
	/**
	 * ...
	 * @author liuyi
	 */
	
	public class MapTest extends BasicPage 
	{
	 
		private var configPath:String = "";
		private var loader:EasyLoader
		private var terrain:Terrain
		private var map:MapData;
		private var xmlData:XmlLoader
		
		private var _terrainManager:TerrainManager
		public function MapTest() 
		{
			
		}

		override protected function init():void 
		{
			xmlData= new XmlLoader();
			
			xmlData.addEventListener(Event.COMPLETE,onConfigLoaded)
			xmlData.loadXML("assets.xml");
		
		}
		
		private function onConfigLoaded(e:Event):void 
		{
		
			if (_dataManager == null) _dataManager = DataManager.getInstance();
			_dataManager.data = xmlData.xml;
			
			loadAssets();
		}
		
		private function loadAssets():void {
		
			loader = new EasyLoader();
			loader.autoGetSize = false;
			loader.addEventListener(EasyLoaderEvent.COMPLETED, onLoadCompeted);
			loader.addEventListener(EasyLoaderEvent.LOADING_ERROR, onLoadError);
			
			trace(_dataManager.data.assets.game);
			loader.init(_dataManager.data.assets.game[0] as XML);
		}
		
		private function onLoadError(e:EasyLoaderEvent):void 
		{
			var str:String;
			for (var i:* in e.data)  str += i + ":" + e.data[i] + "\n";
			trace("load error:"+str);
		}
		
		private function onLoadCompeted(e:EasyLoaderEvent):void 
		{
			 run()
		}
		
		private function run():void {
			
			
	
			//init game assets, so we can use it. do it before create a map
			_terrainManager = TerrainManager.getInstance();
			_terrainManager.addBgs(_dataManager.data.gameAssets.bgs.item);
			_terrainManager.addBuilds(_dataManager.data.gameAssets.builds.item);
			_terrainManager.addMaps(_dataManager.data.gameAssets.maps.map);
			
			trace("builds:" + _terrainManager.getBuilds());
			trace("bgs:" + _terrainManager.getBgs());
			trace("map:" + _terrainManager.getMaps());
			
			
			//create terrain
			terrain = new Terrain(600, 600);
			terrain.autoFit = true;
			terrain.tileSkin = "tileDefaultSkin";
			terrain.createMap(_terrainManager.getMapById(0));
			addChild(terrain);
			
			
			var btn:SimpleBtn =Utils.getObj("EditorToolBtn") as SimpleBtn
			btn.setText( { text:"建筑",embed:"false" } )
			addChild(btn);
			
			btn.x = 100
			btn.y = 100;
			
			
			var tileList:TileBox = new TileBox();
			tileList.displayArea(140, 100);
			for (var i:int; i < 10;i++ ) {
				var mc:Sprite = Utils.getObj("block02") as Sprite;
				tileList.addTile(mc);
				
			
			}
			
			tileList.x = 200;
			tileList.y=200
			addChild(tileList);
			
			
			
		}
		
	}

}