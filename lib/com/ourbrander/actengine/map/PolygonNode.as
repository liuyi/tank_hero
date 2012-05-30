package com.ourbrander.actengine.map 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 */
	public class PolygonNode extends Sprite
	{
		private var _clicked:Boolean = false
	
		 
		public function PolygonNode() 
		{   
			
			
			init();
		}
		private function init() {
			createNode();
			addEvent()
		}
		private function createNode() {
			this.graphics.lineStyle(1, 0xffffff, 1)
			this.graphics.beginFill(0x00cc00,0.5)
			this.graphics.drawCircle(x, y, 4)
			this.graphics.endFill();
		}
		private function addEvent() {
			addEventListener(MouseEvent.MOUSE_DOWN, clicked)
			addEventListener(MouseEvent.MOUSE_OUT, out)
			addEventListener(MouseEvent.MOUSE_UP, up)
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
		}
		private function removedFromStage(e:Event) {
			removeEventListener(MouseEvent.MOUSE_DOWN, clicked)
			removeEventListener(MouseEvent.MOUSE_OUT, out)
			removeEventListener(MouseEvent.MOUSE_UP,up)
		}
		protected function up(e:MouseEvent):void 
		{
			_clicked = false
			this.stopDrag();
		}
		
		protected function out(e:MouseEvent):void 
		{
			if (_clicked == true) {
				var p:PolygonCreation = this.parent as PolygonCreation
				var barrier:PolygonNode = p.createNode(this.x , this.y ,this)
				barrier.startDrag(true);
			
			}
			_clicked=false
		}
		private function clicked(e:MouseEvent) {
             
			 if (e.ctrlKey == true) {
				_clicked = true
			 }else if (e.shiftKey == true) {
				var p:PolygonCreation = this.parent as PolygonCreation
				p.removeNode(this)
			 }else if(e.altKey!=true){
				this.startDrag()
			 }
			 
			
		}
		
		
		
		 
		
	}

}