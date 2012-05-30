package com.ourbrander.actengine.key 
{
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent
	import com.ourbrander.actengine.key.KeyManager
	/**
	 * ...
	 * @author liuyi
	 */
	
	public class KeyManager 
	{
		protected static var _keyManager:KeyManager ;
		protected var _target:DisplayObject;
		
		protected var _userKeyControlList:Array;
		
		public function KeyManager(target:DisplayObject)
		{
			if (_keyManager != null)
			throw new Error('KeyManager is a singleton mode.');
			
			setTarget(target)
			_keyManager = this;
		}
		
		public static  function getInstance(target:DisplayObject=null):KeyManager {
			if (_keyManager == null)  _keyManager=new KeyManager(target);
			 
			return _keyManager;
		}
		
		public function start():void {
			addEvent();
		}
		
		public function stop() :void{
			removeEvent();
		}
		
		
		
		public function setTarget(target:DisplayObject):void {
			
			if (target == null) { return };
			_target = target;
			start();
		}
		
		public function addUserControler(userkeyControler:UserkeyControler):void {
			if (_userKeyControlList==null) {
				_userKeyControlList = new Array();
			}
			_userKeyControlList[userkeyControler.name] = userkeyControler;
		}
		
		public function getUserControlers():Array {
			return _userKeyControlList;
		}
		
		public function getUserControlerByName($name:String) :UserkeyControler{
			 
			if (_userKeyControlList[$name]!=null) {
				return _userKeyControlList[$name];
			}else {
				return null;
			}
		}
		
		public function removeControler($name:String): void{
			if (_userKeyControlList[$name] != null) {
				_userKeyControlList[$name] = null;
				delete _userKeyControlList[$name] ;
			}
		}
		
		
		protected function addEvent():void {
			if(_target==null) throw new Error("Keyboard has no target")
			_target.addEventListener(KeyboardEvent.KEY_DOWN,keyDown_hdl)
			_target.addEventListener(KeyboardEvent.KEY_UP,keyUp_hdl)
		}
		
		protected function keyUp_hdl(e:KeyboardEvent):void 
		{
			
			for (var i:* in _userKeyControlList) {
				
				if(_userKeyControlList[i]!=null){
					var keyName:String;
					for (var k:* in _userKeyControlList[i].keyList) {
						if ( _userKeyControlList[i].keyList[k].keyCode.indexOf(e.keyCode)>=0) {
							_userKeyControlList[i].keyList[k].isDown = false;
							keyName = _userKeyControlList[i].keyList[k].name;
							
						}
					}//end for
					
					if (_userKeyControlList[i]["onKeyUp"] != null && _userKeyControlList[i].enable) {
							_userKeyControlList[i].onKeyUp( { keyName:keyName, keyCode:e.keyCode } );
					}
				}
				
			}//end for
		}
		
		protected function keyDown_hdl(e:KeyboardEvent):void 
		{
			for (var i :*in _userKeyControlList) {
				if(_userKeyControlList[i]!=null){
					var keyName:String;
					for (var k:* in _userKeyControlList[i].keyList) {
						trace(">> "+_userKeyControlList[i].keyList[k].keyCode+"/"+e.keyCode,"??"+_userKeyControlList[i].keyList[k].keyCode.indexOf(e.keyCode))
						if (_userKeyControlList[i].keyList[k].keyCode.indexOf(e.keyCode)>=0) {
							_userKeyControlList[i].keyList[k].isDown = true;
							keyName=_userKeyControlList[i].keyList[k].name
						}
						
					}//end for
					if(_userKeyControlList[i]["onKeyDown"]!=null && _userKeyControlList[i].enable){
						_userKeyControlList[i].onKeyDown( { keyName:keyName, keyCode:e.keyCode } );
					}
				}
			}//end for
			
		}
		
		protected function removeEvent() :void{
			_target.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown_hdl)
			_target.removeEventListener(KeyboardEvent.KEY_UP,keyUp_hdl)
		}
		
		
		
		
		
	}

}