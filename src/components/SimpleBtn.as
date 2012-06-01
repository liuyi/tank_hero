package components 
{
	import com.ourbrander.components.BasicButton;
	import com.ourbrander.utils.Utils;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author liu yi
	 */
	public class SimpleBtn extends BasicButton 
	{
		public var txt:TextField
		public var bg_mc:Sprite
		private var padding:uint = 5;
		public function SimpleBtn() 
		{
			
		}
		
		public function setText(obj:Object, extra:Object = null) :void {
			trace(txt);
			if (txt == null) return;
			Utils.setTextByObj(txt, obj, extra);
			txt.autoSize="left"
			txt.width = txt.textWidth;
			txt.height = txt.textHeight + 5;
			txt.x = padding;
			txt.y = padding;
			bg_mc.width = txt.width + padding*2;
			bg_mc.height = txt.height + padding * 2;
		}
		
		
		
		
		
	}

}