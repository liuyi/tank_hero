package com.ourbrander.actengine.key 
{

	/**
	 * ...
	 * @author liuyi
	 */
	public class UserkeyControler 
	{
		private var _left:UserKeyCell;
		private var _right:UserKeyCell;
		private var _up:UserKeyCell;
		private var _down:UserKeyCell;
		private var _A:UserKeyCell;
		private var _B:UserKeyCell;
		private var _C:UserKeyCell;
		private var _D:UserKeyCell;
		
		protected var _keyList:Array;
		protected var _name:String;
		protected var _id:uint;
		
		
		protected var _onKeyDown:Function
		protected var _onKeyUp:Function
		
		protected var _onKeyDownList:Array
		protected var _onKeyUpList:Array
		public var enable:Boolean//if this is false, can  not accept keyboard callback
		public function UserkeyControler(str:String,num:uint=0) 
		{
			name = str;
			id = num;
			/*_keyList = new Vector.<UserKeyCell>();
			_keyList.push(_left);
			_keyList.push(_right);
			_keyList.push(_up);
			_keyList.push(_down);
			_keyList.push(_A);
			_keyList.push(_B);
			_keyList.push(_C);
			_keyList.push(_D);*/
			//_keyList = [_left, _right, _up, _down, _A, _B, _C, _D];
			_keyList = [];
			_onKeyDownList = new Array();
			_onKeyUpList = new Array();
			enable = true;
		}
		
		
		protected function setKey(label:String, ...$keyCode):void {
	
			var key:UserKeyCell=getKey(label)
			if (key== null) {
				key = new UserKeyCell(label, $keyCode[0]) ;
				_keyList[label] = key;
			}else {
				var keycodes:Vector.<uint> = new Vector.<uint>();
				for (var i:* in $keyCode[0]) {
					keycodes.push($keyCode[0][i])
				}
				key.keyCode = keycodes;
			}
			
			
		}
		
		protected function getKey(label:String):UserKeyCell {
			for (var i:* in _keyList ) {
				if (label==i) {
					return _keyList[i]
				}
			}
			
			return null;
		}
		
		public function setLeft(...keyCode):void {
			setKey("left",keyCode)
		}
		public function get left():UserKeyCell {
			var k:UserKeyCell = getKey("left");
			
			return k
		}
		
		public function setRight(...keyCode) :void{
			setKey("right",keyCode)
		}
		public function get right():UserKeyCell {
			return getKey("right");
		}
		
		public function setUp(...keyCode):void {
			setKey("up",keyCode)
		}
		public function get up():UserKeyCell {
			return getKey("up");
		}
		
		public function setDown(...keyCode) :void{
			setKey("down",keyCode)
		}
		public function get down():UserKeyCell {
			return getKey("down");
		}
		
		public function setA(...keyCode):void {
			setKey("A",keyCode)
		}
		public function get A():UserKeyCell {
			return getKey("A");
		}
		
		
		public function setB(...keyCode) :void{
			setKey("B",keyCode)
		}
		public function get B():UserKeyCell {
			return getKey("B");
		}
		
		public function setC(...keyCode) :void{
			setKey("C",keyCode)
		}
		public function get C():UserKeyCell {
			return getKey("C");
		}
		
		public function setD(...keyCode) :void{
			setKey("D",keyCode)
		}
		public function get D():UserKeyCell {
			return getKey("D");
		}
		
		
		
		 
		
		public function get keyList():Array {
			return _keyList;
		}
		
		public function set name(str:String) :void{
			_name = str;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set id(num:uint) :void{
			_id = num;
		}
		public function get id():uint {
			return _id
		}
		
		public function   addKeyDownCallBack(fun:Function) :void {
			
			_onKeyDownList.push(fun)
	 
		}
		
		internal function  onKeyDown(data:Object):void {
			 
			var fun:Function
			for (var i:* in _onKeyDownList) {
				fun = _onKeyDownList[i] as Function;
				fun(data);
			}
		}
		
		public function addKeyUpCallBack(fun:Function) :void{
		 
			_onKeyUpList.push(fun);
		}
		
		internal function onKeyUp(data:Object):void {
			
			var fun:Function
			for (var i:* in _onKeyUpList) {
				if ( _onKeyUpList[i] is Function) {
					fun = _onKeyUpList[i] as Function;
					fun(data);
				}
			}
		}
		
		 
		
		
		
	}

}