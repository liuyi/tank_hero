package com.ourbrander.actengine 
{

	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActManager extends EventDispatcher 
	{
		
		protected static var actManager:ActManager;
		public static var devMode:Boolean = true;
		protected var _gameBox:ActGamebox;
		
		protected var _gameObjList:Object//所有的gameObject都存到这个对象里面。
		protected var _playerList:Object//存储所有玩家的实例.
		protected var _enemyList:Object//存储所有敌人的实例.
		protected var _objLists:Vector.<Object>
		private var _uniqueId:int
		
		
		//states
		protected var _gameStatus:String//playing,pause,exit,unready
		protected var _currentGameRound:uint;
		protected var _roundCount:uint;
		public function ActManager():void 
		{
			if (actManager!=null) {
				return;
			}
			_objLists = new Vector.<Object>();
			_gameObjList = { };
			_enemyList = { };
			_playerList = { };
			_objLists.push(_gameObjList)
			_objLists.push(_enemyList)
			_objLists.push(_playerList);
		
			_roundCount = 0;
			_uniqueId = 0;
		}
		
		public static function getInstance():ActManager {
			if (actManager!=null) {
				return actManager
			}else {
				actManager = new ActManager(); 
				return actManager
			}
		}
		
		
		public final function onUpdate(){
		
			for (var i in _gameObjList) {
		
				try{
					if (_gameObjList[i]["beforeUpdate"] != null) {
						_gameObjList[i]["beforeUpdate"]();
					}
				}catch (e:Error) { }
			}
			
			for ( i in _playerList) {
		
				try{
					if (_playerList[i]["beforeUpdate"] != null) {
						_playerList[i]["beforeUpdate"]();
					}
				}catch (e:Error) { }
			}
			
			for ( i in _enemyList) {
		
				try{
					if (_enemyList[i]["beforeUpdate"] != null) {
						_enemyList[i]["beforeUpdate"]();
					}
				}catch (e:Error) { }
			}
			
			_gameBox.currentRound.beforeUpdate();
			
			
			for ( i in _gameObjList) {
				try{
					if(_gameObjList[i]["onUpdate"]!=null){
						_gameObjList[i]["onUpdate"]();
					}
				}catch(e:Error){}
			}
			
			for ( i in _playerList) {
				try{
					if(_playerList[i]["onUpdate"]!=null){
						_playerList[i]["onUpdate"]();
					}
				}catch(e:Error){}
			}
			
			for ( i in _enemyList) {
				try{
					if(_enemyList[i]["onUpdate"]!=null){
						_enemyList[i]["onUpdate"]();
					}
				}catch(e:Error){}
			}
			
			_gameBox.currentRound.onUpdate();
			 
			for ( i in _gameObjList) {
				try{
					
					if(_gameObjList[i]["afterUpdate"]!=null){
						_gameObjList[i]["afterUpdate"]();
					}
				}catch(e:Error){}
			}
			
			for ( i in _playerList) {
				try{
					
					if(_playerList[i]["afterUpdate"]!=null){
						_playerList[i]["afterUpdate"]();
					}
				}catch(e:Error){}
			}
			
			for ( i in _enemyList) {
				try{
					
					if(_enemyList[i]["afterUpdate"]!=null){
						_enemyList[i]["afterUpdate"]();
					}
				}catch(e:Error){}
			}
			
			_gameBox.currentRound.afterUpdate();
			
		}

		public  function registerGameObj(target:*,type:uint){
			target.uniqueId=_uniqueId;
			switch(type) {
				case 0:
					_gameObjList["actObj_"+_uniqueId] = target;
				break;
				case 1:
					_enemyList["actObj_"+_uniqueId] = target;
				break;
				case 2:
					_playerList["actObj_"+_uniqueId] = target;
				break;
			}
			
				addUniqueId();
		}

		public function deRegisterGameObj(target:*) {
			
			delete _gameObjList["actObj_"+target.uniqueId];
			delete _enemyList["actObj_"+target.uniqueId] ;
			delete _playerList["actObj_"+target.uniqueId] ;
		}
		
		internal function setGameStatus(str:String) {
			_gameStatus = str;
		}
		
		public function get gameStatus():String {
			return _gameStatus;
		}
		
		
		internal function setCurrentGameRound(id:uint) {
			_currentGameRound =id;
		}
		
		public function get currentGameRound():uint {
			return _currentGameRound;
		}
		
		internal function addedRound() {
			_currentGameRound=_roundCount
			_roundCount++;
			return _roundCount - 1;
		}
		
		public function get roundCount():uint {
			return _roundCount;
		}
		
		public function set gamebox(target:ActGamebox) {
			_gameBox = target;
		}
		
		public function get gamebox():ActGamebox {
			return _gameBox;
		}
		
		public function get objList():Vector.<Object> {
			return _objLists;
		}
		
		protected function getUniqueId():uint {
			//_uniqueId++;
			return _uniqueId;
		}
		
		internal function addUniqueId() :void{
			_uniqueId++;
		}
		
		
		
		
	}

}