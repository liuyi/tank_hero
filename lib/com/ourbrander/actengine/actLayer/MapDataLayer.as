package com.ourbrander.actengine.actLayer 
{
	import com.ourbrander.actengine.map.MapBarrierEdit;
	import flash.events.Event;
	import com.ourbrander.actengine.ActManager
	/**
	 * ...
	 * @author liuyi
	 */
	public class MapDataLayer extends ActLayer 
	{
		private var _mapEdit:MapBarrierEdit;
		public function MapDataLayer() 
		{
			super();
			init();
		}
		
		protected function init() {
			_mapEdit = new MapBarrierEdit();
			_mapEdit.drawEnable = ActManager.devMode 
			addChild(_mapEdit);
		}
		
		public function get map():MapBarrierEdit {
			return _mapEdit;
		}
		
		public function set map(target:MapBarrierEdit) {
		
			while (this.numChildren > 0) {
				removeChildAt(0);
			}
			_mapEdit = null;
			_mapEdit = target;
			
			addChild(_mapEdit)
		}
		
	}

}