package com.ourbrander.actengine.character 
{
	import com.ourbrander.actengine.key.UserkeyControler;
	import com.ourbrander.actengine.physics.Collision;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import com.ourbrander.actengine.math.Polygon
	/**
	 * ...
	 * @author liuyi
	 */
	 public class Character extends EventDispatcher 
	{
		private var _body:CharacterBody;
		private var _animation:MovieClip;
		private var _animationControler:ActionControler
		private var _data:CharacterData;
		//private var _collision:Collision;
		//private var _characterControler:CharacterControler;
		private var _userKeyControler:UserkeyControler;
		
		//fun
		private var _onUpdate:Function;
		private var _afterUpdate:Function
		private var _onAwake:Function;
		private var _doAction:Function;
		
		//general attributes
		//private var _isRigidBody:Boolean;
		private var _awake:Boolean;
		private var _name:String
		
		private var _isFloor:Boolean;// Is on the floor?
		private var _isRoof:Boolean;// Is up to  the roof?
		
		private var _prePosition:Point;
		private var _tempPosition:Array;
		
		
		private var _tempb:Boolean
		
		private var _isPlayer:Boolean;
		private var _humanOperator :Boolean
		private var _teamId:uint
		protected var _uniqueId:uint;
		
		public function Character($name:String) 
		{
			
			initData($name);
			
		};
		public function set uniqueId(index:uint) :void{
			_uniqueId = index;
		}
		
		public function get uniqueId():uint {
			return  _uniqueId;
		}
		
		protected function initData($name:String) {
			
			if (_data == null) { _data = new CharacterData(); };
			_data.awake = false;
			name = $name;
			_prePosition = new Point();
			_tempPosition = [];
			if (_animationControler == null) { this.actionControler =new ActionControler()};
			isPlayer = false;
			humanOperator=false
		}
		
		/*
		 * This fuction would be execute everytime.
		 * */
		public function onUpdate() {
			
			if (_awake==false) {
				
			}else {
				
				if (_onUpdate != null) { _onUpdate(); }
				if (_body != null) { _body.onUpdate(); }
				if (_animationControler != null) {  _animationControler.onUpdate(); }
				if(_animation!=null){_animation.onUpdate();}
				
			}
			
		}
		
		public function set update(fun:Function) {
			_onUpdate = fun;
		}
		
		public function get update():Function {
			return _onUpdate;
		}

		public function afterUpdate() {
				
			if (_awake==true) {
				if (_afterUpdate != null) { _afterUpdate(); }
				if (_body != null) { _body.afterUpdate(); }
				if (_animationControler != null) {  _animationControler.afterUpdate(); }
				if(_animation!=null){_animation.afterUpdate();}
				
			}
		}
		
		public function set updated(fun:Function) {
			_afterUpdate = fun;
		}
		
		public function get updated():Function {
			return _afterUpdate;
		}

		public function set name(str:String) {
			_name = str;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set isPlayer(b:Boolean):void {
			_isPlayer = b;
		}
		
		public function get isPlayer():Boolean {
			return _isPlayer;
		}
		
		public function set humanOperator(b:Boolean):void {
			_humanOperator = b;
		}
		
		public function get humanOperator():Boolean {
			return _humanOperator;
		}
		
		public function set body(target:CharacterBody) {
			_body = target;
			target.belong = this;
			if (_body.getAnimation() != null) {
				_animation=_animationControler.animation = _body.getAnimation();
			}

		}
		
		public function get body():CharacterBody {
			return _body;
		}

		public function set animation(target:MovieClip) {
			_animation = target;
			_animation.stop();
			_animationControler.animation = _animation;
			_body.addAnimation(_animation);
		 
		}
		
		public function get animation():MovieClip {
			return _animation;
		}
		
		public function get data():CharacterData {
			return _data;
		}
		
		public function set  awake(b:Boolean) {
			_awake = b;
			if(_onAwake!=null){
				_onAwake();
			}
		}
		
		public function get awake():Boolean {
			return _awake;
		}

		
		public function set actionControler(target:ActionControler) {
			_animationControler = target;
			_animationControler.belong = this;
		}
		
		public function get actionControler():ActionControler {
			return _animationControler;
		}
		
		
		public function set userKeyControler(target:UserkeyControler) {
			_userKeyControler = target;
		}
		
		public function get userKeyControler():UserkeyControler {
			return _userKeyControler ;
		}

		
		protected function set  onAwake(fun:Function) {
			_onAwake = fun;
		}
		
		protected function get  onAwake():Function {
			return _onAwake;
		}

		
	}

}