package data 
{
	/**
	 * ...
	 * @author liu yi
	 */
	public class BuildData 
	{
		
		//id="block01" across="false" depth="1" life="0" defence="0" friction="0"
		public var id:int;
		public var across:Boolean;
		public var depth:int;
		public var life:Number;
		public var defence:Number;
		public var friction:Number;
		public var skinId:String;
		public function BuildData() 
		{
			
		}
		
		public function clone():BuildData {
			var buildData:BuildData = new BuildData();
			buildData.id = id;
			buildData.across = across;
			buildData.depth = depth;
			buildData.life = life;
			buildData.defence = defence;
			buildData.friction = friction;
			buildData.skinId = skinId;
			
			return buildData;
		}
		
	}

}