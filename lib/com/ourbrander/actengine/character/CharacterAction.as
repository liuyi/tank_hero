package com.ourbrander.actengine.character 
{
	/**
	 * ...
	 * @author liuyi
	 */
	public class CharacterAction 
	{
		private var _name:String
		private var _start:uint;
		private var _end:uint;
		private var _type:uint;//0-4
		private var _weight:uint;
		private var _currentFrame:uint;
		
		private var _playMode:String;//once,loop,hold
		private var _isPlaying:Boolean;
 
		
		public function CharacterAction(name:String,start:uint=0, end:uint=0,type:uint=0,weight:uint=0, playMode:String = 'once')
		{
			setAction(name,start, end,type,weight, playMode);
		}
		
		public function setAction(name:String, start:uint, end:uint,type:uint=0,weight:uint=0, playMode:String = 'once') {
			_name = name;
			_start = start;
			_end = end;
			_playMode = playMode;
			_isPlaying = false;
			_type = type;
			_weight = weight;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		internal function setIsplaying(b:Boolean) {
			_isPlaying = b;
		}
		
		internal function setCurrentFrame(num:uint) {
			_currentFrame = num;
		}
		
		public function get currentFrame():uint {
			return _currentFrame;
		}
		
		public function set start(num:uint) {
			_start = num;
		}
		public function get start():uint {
			return _start;
		}
		
		public function set end(num:uint) {
			_end = num;
		}
		public function get end():uint {
			return _end;
		}
		
		public function set type(num:uint) {
			_type = num;
		}
		public function get type():uint {
			return _type;
		}
		
		public function set weight(num:uint) {
			_weight = num;
		}
		public function get weight():uint {
			return _weight;
		}
		
		public function set playMode(str:String) {
			_playMode = str;
		}
		public function get playMode():String {
			return _playMode;
		}
		
		public function set name(str:String) {
			_name = str;
		}
		public function get name():String {
			return _name;
		}
		
		
		
		internal function onUpdate() {
			
		}
		
		
		
		
		
	}

}