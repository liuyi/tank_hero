package com.ourbrander.actengine.character 
{
	/**
	 * ...
	 * @author liuyi
	 */
	dynamic public class CharacterData extends Object 
	{
		
		private var _walkSpeed:Number ;
		private var _runSpeed:Number ;
		private var _life:Number;
		private var _power:Number;
		private var _magic:Number;
		
		private var _teamId:uint;
		
		public function CharacterData() 
		{
			init()
		}
		
		private function init() {
			
		}
		
		public function set walkSpeed(num:Number) {
			_walkSpeed = num;
		}
		
		public function get walkSpeed():Number {
			return _walkSpeed;
		}
		
		public function set runSpeed(num:Number) {
			_runSpeed = num;
		}
		
		public function get runSpeed():Number {
			return _runSpeed;
		}
		
		public function set life(num:Number) {
			_life = num;
		}
		
		public function get life():Number {
			return _life;
		}
		
		public function set power(num:Number) {
			_power = num;
		}
		
		public function get power():Number {
			return _power;
		}
		
		public function set magic(num:Number) {
			_magic = num;
		}
		
		public function get magic():Number {
			return _magic;
		}
		
		
		
		public function set  teamId(num:uint) {
			_teamId = num;
		}
		
		public function get teamId():uint {
			return _teamId;
		}
		
		
		
	}

}