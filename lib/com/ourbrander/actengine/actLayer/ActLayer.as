package com.ourbrander.actengine.actLayer 
{
	import com.ourbrander.actengine.ActGamebox;
	import com.ourbrander.actengine.ActGameRound;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class ActLayer extends Sprite 
	{
		private var _depth:Number;//how far the instance near screen(or character layer?not sure yet)
		//private var _ord:Number;//the ord of instance  in its parent
		
		private var _isFix:Boolean
		public function ActLayer() 
		{
			isFix = false;
			_depth = 0;
		
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
		}
		
		protected function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
		}
		
		protected function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
		}
		public function set depth(num:Number) {
			
			_depth = (num > 0)?num:0;
			if (this.parent != null) {
				
				if (this.parent is ActGameRound) {
					var p:ActGameRound = this.parent as ActGameRound;
					p.autoSwapDepth();
					p = null;
				}
			}
		}
		
		public function get depth():Number {
			return _depth;
		}
		
		
		
		/*public function set ord(num:Number) {
			
			_ord = (num>0)?num:0;
		}
		
		public function get ord():Number {
			return _ord;
		}*/
		
		public function set isFix(b:Boolean) {
			_isFix = b;
		}
		
		public function get isFix():Boolean {
			return _isFix;
		}
		
	
		
	}

}