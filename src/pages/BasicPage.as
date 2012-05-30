package pages 
{
	import com.ourbrander.data.DataManager;
	import com.ourbrander.deepLink.DeepLink;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class BasicPage extends Sprite 
	{
		public var hash:String;
		public var specialTransition:Boolean;
		protected var _dataManager:DataManager;
		private var _deepLink:DeepLink
		public function BasicPage() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			
		}
		
		protected function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			init();
		}
		
		protected function onRemovedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function playIn(callback:Function=null):void {
			
		}
		
		protected function playOut(callback:Function=null):void {
			
		}
		
		protected function init():void {
			
		}
		
		
	}

}