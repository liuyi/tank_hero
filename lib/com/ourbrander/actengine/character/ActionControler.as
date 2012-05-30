package com.ourbrander.actengine.character 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author liuyi
	 * 
	 * 角色的动作不能使用movieClip直接显示在舞台上，实验超过40个角色就非常卡了。
	 */
	public class ActionControler 
	{
		private static var _actionSpeed:Number = 0.45;
		private var _animation:MovieClip;
		private var _actionList:Array;
		private var _isPlaying:Boolean;
		private var _currentPlayingAction:String;
		private var _nextAction:String;
		
 
		private var _switchSpeed:Number;
		private var _currentSpeed:Number
		private var _defaultAction:String;
		
		//temp
		private var _tempFrameNum:Number
		
		//character controler
		private var _generalActionList:Array;//general action,type:0
		private var _faceActionList:Array;//autokinesis,type:1
		private var _attackActionList:Array;//autokinesis,type:2
		private var _extraAttackActionList:Array;//autokinesis,type:3
		private var _injuredActionList:Array;//autokinesis,type:4
		
		private var _force:Boolean//if force to switch action?
	
		private var _belong:Character;
		public function ActionControler() 
		{
			reset();
		}
		
		private function reset() {
 
			_switchSpeed = _actionSpeed * 80
			_currentSpeed = _actionSpeed;
			_tempFrameNum = 0;
			_currentPlayingAction = "";
			_nextAction=""
			_actionList = [];
			initActionList()
		}
		
		protected function initActionList() {
			_generalActionList = [];
			_generalActionList["type"] = 0;
			
			_faceActionList =[];
			_faceActionList["type"] = 1;
			
			_attackActionList = [];
			_attackActionList["type"] = 2;
			
			_extraAttackActionList = [];
			_extraAttackActionList["type"] = 3;
			
			_injuredActionList = [];
			_injuredActionList ["type"] = 4;
		}
		public function set belong(target:Character) {
			_belong = target;
		}
		
		public function get belong():Character {
			return _belong;
		}
		
		public static function set actionSpeed(num:Number):void {
			ActionControler._actionSpeed = (num < 0)?0:num;
		}
		public static function get actionSpeed():Number {
			return ActionControler._actionSpeed;
		}
		public function set animation(target:MovieClip ){
			_animation = target;
		}
		
		public function get animation( ):MovieClip{
			return _animation;
		}
		
		
		public function set defaultAction(name:String) {
			_defaultAction = name;
		}
		
		public function get defaultAction():String {
			return _defaultAction;
		}
		
		public function get currentAction():CharacterAction {
			return _actionList[_currentPlayingAction];
		}
		
		public function getActionByName(n:String):CharacterAction {
			return _actionList[n];
		}
		
		public function addAction(name:String,start:uint,end:uint,type:uint=0,weight:uint=0,playMode:String='once',isDefaultAction:Boolean=false) {
			if (_actionList == null) { _actionList = new Array() };
			//_actionList.push(new CharacterAction(name,start,end,playMode));
			
			switch(type) {
				case 0:
					_generalActionList.push(name);
				break;
				case 1:
					_faceActionList.push(name);
				break;
				
				case 2:
					_attackActionList.push(name);
				break;
				case 3:
					_extraAttackActionList.push(name);
				break;
				case 4:
					_injuredActionList.push(name);
				break;
			}
			
			
			_actionList[name] = new CharacterAction(name, start, end,type,weight, playMode)
			if (isDefaultAction==true) {
				defaultAction=name
			}
		 
		}
		
		public function playAction(name:String,force:Boolean=false) :void{
		//	trace('playAction',name)
			_force=force
			if (_actionList[name]==null) {
				return
			}
			if (_currentPlayingAction != "") {
				/*if (name!=_currentPlayingAction) {
					_nextAction = name;
				}*/
				if (_nextAction != "") {
					if (checkWeight(name, _nextAction)) {
						_nextAction = name;
					}
				}else{
					_nextAction = name;
				}
			} else {
				_currentPlayingAction=name
			}
			
		}
		
		private function checkWeight(act1:String, act2:String):Boolean {
			var action1:CharacterAction = getActionByName(act1) as CharacterAction;
			var action2:CharacterAction = getActionByName(act2) as CharacterAction;
			if (action1.type > action2.type) {
				return true
			}else if (action1.type == action2.type) {
				if (action1.weight>action2.weight) {
					return true
				}
			}
			return false
		}
		
	 
		private function actionPlayOut() {
			
		}
		
		internal function onUpdate() {
		
			doAction()
		}
		
		internal function afterUpdate() {
			
		}
		
		private function doAction() {
			if (_currentPlayingAction == "" && _nextAction == "" ) {
				_currentPlayingAction = _defaultAction;
			};
			 
			
			if (_nextAction != ""  ) {
					if ( _animation.currentFrame == _actionList[_currentPlayingAction].end) {
					
						if (_actionList[_currentPlayingAction].playMode == "hold" && _nextAction == _currentPlayingAction) {
							_nextAction = "";
						}else{
						_actionList[_currentPlayingAction].setIsplaying(false);
						_currentPlayingAction = _nextAction;
						
						_currentSpeed = ActionControler.actionSpeed;
						_actionList[_currentPlayingAction].setCurrentFrame ( _actionList[_currentPlayingAction].start);
						}
						
					}else {
						if (_nextAction == _currentPlayingAction) {
							_nextAction = "";
						}else {
							_currentSpeed = _switchSpeed
						}
					}
			}
		 
			if (_actionList[_currentPlayingAction].isPlaying == false) {
					 
				_actionList[_currentPlayingAction].setIsplaying( true);
			 
				_actionList[_currentPlayingAction].setCurrentFrame ( _actionList[_currentPlayingAction].start);
		
			}
			
			if (_actionList[_currentPlayingAction].currentFrame >= _actionList[_currentPlayingAction].end) {
				switch(_actionList[_currentPlayingAction].playMode) {
					case "once":
						_actionList[_currentPlayingAction].setCurrentFrame ( _actionList[_currentPlayingAction].end);
						resetToDefaultAction(); 
					break;
					case "hold":
						_actionList[_currentPlayingAction].setCurrentFrame ( _actionList[_currentPlayingAction].end);
					break;
					case "loop":
						_actionList[_currentPlayingAction].setCurrentFrame ( _actionList[_currentPlayingAction].start);
					break;
					
				}
				
			}
			_tempFrameNum += _currentSpeed;
		
			if (_tempFrameNum >= 1) {
				_tempFrameNum = Math.round(_tempFrameNum);
				
				var targetFrame:uint = _actionList[_currentPlayingAction].currentFrame + _tempFrameNum;
				targetFrame = (targetFrame > _actionList[_currentPlayingAction].end)?_actionList[_currentPlayingAction].end:targetFrame;
				
				_actionList[_currentPlayingAction].setCurrentFrame (targetFrame);  
				_animation.gotoAndStop(_actionList[_currentPlayingAction].currentFrame);
				_tempFrameNum = 0;
			}
		
		}
		
		public function resetToDefaultAction() {
				_nextAction = _defaultAction;
		}
		
		
		
	}

}