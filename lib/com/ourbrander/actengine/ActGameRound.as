package com.ourbrander.actengine 
{

	import com.ourbrander.actengine.actObjs.ActObj;
	import com.ourbrander.actengine.character.CharacterBody;
	import com.ourbrander.actengine.map.MapBarrierEdit;
	import com.ourbrander.actengine.physics.ActWord;
	import flash.display.Sprite;
	import com.ourbrander.actengine.actLayer.ActLayer;
	import com.ourbrander.actengine.character.Character;
	import flash.events.Event;
	import flash.display.DisplayObject
	import com.ourbrander.actengine.key.KeyManager;
	import flash.geom.Point;
	//import com.ourbrander.actengine.terrain.Terrain
	import com.ourbrander.actengine.actLayer.MapDataLayer
	
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActGameRound extends ActWord 
	{
		//data
		protected var _actManager:ActManager;
		protected var _keyManager:KeyManager
		//displayObject
		protected var _charactersLayer:ActLayer;
		protected var _terrainLayer:ActLayer;
		protected var _backgroundLayer:ActLayer;
		protected var _foregroundLayer:ActLayer;
		protected var _effectLayer:ActLayer;
		
		protected var _mapDataLayer:MapDataLayer;
		
		protected var _sleeping:Boolean;
		
		protected var _layerList:Vector.<ActLayer>
		
		protected var _id:uint
		
		protected var _marginLeft:Number
		protected var _marginRight:Number
		protected var _marginTop:Number
		protected var _marginBottom:Number
		
		protected var _character:Character
		protected var _gamebox:ActGamebox
		
		public function ActGameRound() 
		{
			
			init();
		}
		
		private function init() {
			
			_actManager = ActManager.getInstance();
			_sleeping = true;
			
			//init layer
			_charactersLayer = new ActLayer();
			_charactersLayer.depth = 1;
			_charactersLayer.name = "charactersLayer";
			_terrainLayer = new ActLayer();
			_terrainLayer.depth = 1;
			_terrainLayer.name = 'terrainLayer';
			_backgroundLayer = new ActLayer();
			_backgroundLayer.depth = 0.5;
			_backgroundLayer.name = "backgroundLayer";
			_foregroundLayer = new ActLayer();
			_foregroundLayer.depth=3
			_foregroundLayer.name = "foregroundLayer";
			_effectLayer = new ActLayer();
			_effectLayer.name = "effectLayer";
			_effectLayer.depth = 1;
			_effectLayer.isFix = true;
			
			_mapDataLayer = new MapDataLayer();
			_mapDataLayer.depth = 1;
			_mapDataLayer.name = "mapDataLayer"
			_mapDataLayer.alpha = 0.5;
			
			addChild(_backgroundLayer);
			addChild(_terrainLayer);
		
			addChild(_charactersLayer);
			addChild(_foregroundLayer);
			addChild(_effectLayer);
			
			
			addChild(_mapDataLayer);
		
			
			_layerList = new Vector.<ActLayer>();
			_layerList.push(_backgroundLayer);
			_layerList.push(_terrainLayer);
			_layerList.push(_charactersLayer);
			_layerList.push(_foregroundLayer);
			_layerList.push(_effectLayer);
			
			
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage)
			_gamebox = this.parent as ActGamebox
			trace("_gamebox",_gamebox)
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			_gamebox = null;
		}
		
		public function addGameObj(target:ActObj,x:Number,y:Number):void{
			_actManager.registerGameObj(target,0);
			target.x = x;
			target.y = y;
			_charactersLayer.addChild(target);
		}

		public function removeGameObj(target:ActObj):void {
			
			 _actManager.deRegisterGameObj(target);
			_charactersLayer.removeChild(target);
		}
		
		public function addCharacter(target:Character, x:Number, y:Number, isPlayer:Boolean = false) {
			if(isPlayer){
				_actManager.registerGameObj(target,2);
			}else {
				_actManager.registerGameObj(target,1);
			}
			target.body.x = x;
			target.body.y = y;
			_charactersLayer.addChild(target.body);
			if (isPlayer) {
				_character = target;
			}
		
		}
		public function removedCharacter(target:Character) {
			_actManager.deRegisterGameObj(target);
			_charactersLayer.removeChild(target.body);
		}
		
		public function addLayer(target:ActLayer) {//depth can low than 0
			this.addChild(target);
			autoSwapDepth();
		}
		
		public function removeLayerByOrd(ord:int) {
			
		}
		
		public function removeLayerByName(name:String) {
			
		}
		
		public function removeLayer(target:ActLayer) {
			
		}
		
		public function getLayerByName(n:String) :ActLayer{
			var layer:* = this.getChildByName(n);
			if (layer is ActLayer) {
				return layer;
			}else {
				return null;
			}
		};
 
		
		public function autoSwapDepth() {
			
		}
		
		
		internal  function setId(num:uint) {
			_id = num;
		}
		
		
		public function get id():uint {
			return _id;
		}
		
		public function get mapEdit() :MapBarrierEdit{
			return _mapDataLayer.map;
		}
		
		
	   //margin这个属性设置角色可以走到离屏幕多远的距离才开始滚屏。
		public function set marginLeft(num:Number) {
			_marginLeft = (num>=0)?num:0;
		}
		public function get marginLeft():Number {
			return _marginLeft;
		}
		
		public function set marginRight(num:Number) {
			_marginRight = (num>=0)?num:0;
		}
		public function get marginRight():Number {
			return _marginRight;
		}
		
		public function set marginTop(num:Number) {
			_marginTop = (num>=0)?num:0;
		}
		public function get marginTop():Number {
			return _marginTop;
		}
		
		
		public function set marginBottom(num:Number) {
			_marginBottom = (num>=0)?num:0;
		}
		public function get marginBottom():Number {
			return _marginBottom;
		}
		//margin相关的 get set 方法完
		
	
		
		
		public function scrollMap(ox:Number=0,oy:Number=0) {
			_backgroundLayer.x +=  ox*_backgroundLayer.depth ;
			_backgroundLayer.y +=  oy*_backgroundLayer.depth; 
			
			 _terrainLayer.x += ox*_terrainLayer.depth;
			 _terrainLayer.y += oy*_terrainLayer.depth;

			 _foregroundLayer.x += ox*_foregroundLayer.depth 
			 _foregroundLayer.y += oy * _foregroundLayer.depth
			 
			 _mapDataLayer.x += ox*_mapDataLayer.depth 
			 _mapDataLayer.y += oy * _mapDataLayer.depth
			 
			 _charactersLayer.x += ox*_charactersLayer.depth 
			 _charactersLayer.y += oy * _charactersLayer.depth
		 
			 
		}
		
		
		public function scrollMapX(ox:Number) {
			
			_backgroundLayer.x +=  ox*_backgroundLayer.depth; 			
			 _terrainLayer.x += ox*_terrainLayer.depth;
			 _foregroundLayer.x += ox * _foregroundLayer.depth
			 _mapDataLayer.x += ox * _mapDataLayer.depth
			  _charactersLayer.x += ox*_charactersLayer.depth 
	
			 
		}
		public function scrollMapY(oy:Number) {
			
			_backgroundLayer.y +=  oy*_backgroundLayer.depth; 			
			 _terrainLayer.y += oy*_terrainLayer.depth;
			 _foregroundLayer.y += oy * _foregroundLayer.depth
			 _mapDataLayer.y += oy * _mapDataLayer.depth
			 _charactersLayer.y += oy * _charactersLayer.depth
		}
		
		public function get mapX():Number {
			return _terrainLayer.x ;
		}
		
		public function get mapY():Number {
			return _terrainLayer.y;
		}
		
		public function get mapWidth() {
			return _terrainLayer.width;
		}
		
		public function get mapheight() {
			return _terrainLayer.height;
		}
		
		
		override public function onUpdate() :void{
			super.onUpdate();
		 
		}
		override public  function beforeUpdate():void {
			super.beforeUpdate();
		}
		override public  function afterUpdate():void {
			super.afterUpdate();
		}
		
	}

}