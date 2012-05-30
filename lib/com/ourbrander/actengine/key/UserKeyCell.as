package com.ourbrander.actengine.key 
{
	/**
	 * ...
	 * @author liuyi
	 */
	public class UserKeyCell 
	{
		private var _name:String;
		private var _label:String;//lalel is use to display on screen.
		private var _keyCode:Vector.<uint>;
		private var _isDown:Boolean;
	
		public function UserKeyCell(str:String ,...keyCodes) 
		{
			
			name = str;
			var v:Vector.<uint>=new Vector.<uint>()

			for (var i:* in keyCodes[0]) {
				v.push(keyCodes[0][i])
			}

			keyCode =v
			_isDown = false;
		}
		
		public function set name(str:String):void {
			_name = str;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set label(str:String) :void{
			_label = str;
		}
		
		public function get label():String {
			return _label;
		}
		
		
		
		public function set keyCode($keyCode:Vector.<uint>):void {
			_keyCode =$keyCode
			
			/*for (var i:* in keyCodes) {
				_keyCode.push(keyCodes[i])
			}*/
			//_keyCode=keyCodes;
		}
		public function get keyCode():Vector.<uint> {
			return _keyCode;
		}
		public function set isDown(b:Boolean):void {
			_isDown = b;
		}
		
		public function get isDown():Boolean {
			return _isDown;
		}
		
		
		
	}

}