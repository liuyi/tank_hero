package test 
{
	import com.ourbrander.data.DataManager;
	import com.ourbrander.loader.EasyLoader;
	import com.ourbrander.loader.EasyLoaderEvent;
	import com.ourbrander.utils.Utils;
	import com.ourbrander.xmlObject.xmlObj;
	import data.MapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import maps.Terrain;
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
		private var xmlData:xmlObj
		public function MapTest() 
		{
			
		}

		override protected function init():void 
		{
			xmlData= new xmlObj();
			
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
			trace("run");
		}
		
	}

}