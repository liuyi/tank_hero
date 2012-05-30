package com.ourbrander.actengine.map 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author liuyi
	 */
	public class MapManager 
	{
		private static var mapManager:MapManager;
		private var _mapDataList:Array;
		private var _mapBitmapData:BitmapData
		private var _mapBitmapList:Array;
		public function MapManager() 
		{
			if (mapManager != null) {
				return;
			}
			_mapDataList = [];
			
		}
		
		public static function getInstance():MapManager {
			if (mapManager!=null) {
				return mapManager;
			}else {
				mapManager = new MapManager();
				return mapManager;
			}
		}
		public function getMapData(round:uint = 0):Array {
			if (_mapDataList == null) { _mapDataList = []; }
			return _mapDataList[round];
		}
		
		public function setMapData(d:Array, round:uint = 0) {
			if (_mapDataList == null) { _mapDataList = []; }
			_mapDataList[round] = d;
		}
		
		public function setMapBitmap(bitmap:BitmapData) {
			_mapBitmapData = bitmap;
		}
		
		public function getMapBitmap():BitmapData {
			return _mapBitmapData
		}
		
		
	}

}