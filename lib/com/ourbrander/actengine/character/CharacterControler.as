package com.ourbrander.actengine.character 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author liuyi
	 */
	public class CharacterControler  extends EventDispatcher
	{
		private var _generalActionList:Array;//general action,type:0
		private var _faceActionList:Array;//autokinesis,type:1
		private var _attackActionList:Array;//autokinesis,type:2
		private var _extraAttackActionList:Array;//autokinesis,type:3
		private var _injuredActionList:Array;//autokinesis,type:4
		
		
		private var _ActionControler:ActionControler
		
	 
		
		public function CharacterControler() 
		{
			
			init();
		}
		
		protected function init() {
			_generalActionList = new Array();
			_generalActionList["type"] = 0;
			_faceActionList = new Array();
			_faceActionList["type"] =1;
			_attackActionList = new Array();
			_attackActionList["type"] = 2;
			_extraAttackActionList = new Array();
			_extraAttackActionList["type"] = 3;
			_injuredActionList = new Array();
			_injuredActionList ["type"] = 4;
		}
		
		public function addAction(name:String, type:uint = 0) {
			switch(type) {
				case 0:
					_generalActionList.push(name);
				break;
				case 1;
					_faceActionList.push(name);
				break;
				case 2;
					_attackActionList.push(name);
				break;
				case 3:
					_extraAttackActionList.push(name);
				break;
				case 4:
					_injuredActionList.push(name);
				break;
			}
		}
		
		
		
	}

} 