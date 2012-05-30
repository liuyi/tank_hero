package com.ourbrander.actengine 
{
	import com.ourbrander.actengine.ActManager;
	import com.ourbrander.actengine.actLayer.ActLayer;
	import com.ourbrander.actengine.character.Character;
	import com.ourbrander.actengine.key.KeyManager;
	import flash.geom.Point;
	//import com.ourbrander.actengine.terrain.Terrain;
	import flash.display.Sprite;
	import flash.display.DisplayObject
	import flash.events.Event;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActGamebox extends Sprite 
	{
		
		//data
		protected var _actManager:ActManager;
		protected var _keyManager:KeyManager
		protected var _currentRound:ActGameRound;
		protected var _width:Number;
		protected var _height:Number;
		//physics
		protected var _gravity:Number;
		//display
		protected var _roundContainer:Sprite;
		//fun
		protected var _onUpdate:Function
		
		public function ActGamebox(w:Number=640,h:Number=480) :void
		{
			init(w,h);
		}
		
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage)
			_keyManager.setTarget(stage);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
		}
		
		
		private function init(w:Number=800,h:Number=600):void{
			_actManager = ActManager.getInstance();
			_actManager.setGameStatus("unready");
			_actManager.gamebox = this;
			_keyManager =  KeyManager.getInstance();
			width = w;
			height = h;
			initDisplayObj();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage)
			addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		

		private function initDisplayObj() {
			createRoundContainer();
		}
		
		public function set gravity(g:Number) {
			_gravity = g;
		}
		
		public function get gravity():Number {
			return _gravity;
		}
		
		public function pauseGame() {
			removeEventListener(Event.ENTER_FRAME, update);
			_actManager.setGameStatus("pause")
		}
		
		public function resumeGame() {
			addEventListener(Event.ENTER_FRAME, update);
			_actManager.setGameStatus("playing")
		}
		
		public function exitGame() {
			removeEventListener(Event.ENTER_FRAME, update);
			_actManager.setGameStatus("exit")
		}
		
		public function addRound(round:ActGameRound):void {
			
			//if (_roundContainer == null) { createRoundContainer()}
			if (_currentRound != null) { removeRound()};
			_currentRound = round;
			round.setId(_actManager.addedRound());
			
			//_roundContainer.addChild(_currentRound);
			addChild(_currentRound);
		}
		
		public function removeRound() {
			//_roundContainer.removeChild(_currentRound);
			removeChild(_currentRound);
		}
		
		protected function createRoundContainer() {
			if (_roundContainer == null) {
				_roundContainer = new Sprite();
				_roundContainer.name='roundContainer'
				addChild(_roundContainer) 
			}
		}
		
		public function get currentRound():ActGameRound {
			return _currentRound;
		}
		
		protected function update(e:Event) {
			if (_onUpdate != null) {
				_onUpdate();
			}
		 
			_actManager.onUpdate();
			
		}
		
		public function set onUpdate(fun:Function) {
			_onUpdate = fun;
			
		}
		
		public function get onUpdate():Function {
			return _onUpdate;
		}
		
		
		public function getPositionFromGlobal(p:Point) :Point{
			p = this.globalToLocal(p);
			return p;
		}
		
		
		//设定游戏世界的显示范围
		override public function set width(num:Number):void {
			_width= num;
			
		}
		override public function get width() :Number{
			return _width
		}
		
		override public function set height(num:Number):void {
			_height= num;
			
		}
		override public function get height() :Number{
			return _height
		}
		
		
		
		
		
		
		
		
		
		
		
	}

}