package com.ourbrander.actengine.character 
{
	/**
	 * ...
	 * @author ...
	 */
	
	 /*
	  * 角色在运动中的各种状态，可以通过这个调用不同的特殊动画或做特殊的动作。
	  * */
	 
	public class MoveStatus 
	{
		public static const  HORIZON = "horizon";
		public static const  UPHILL = "uphill";
		public static const  DOWNHILL = "downhill";
		public static const  HIT_WALL = "hitwall";
		public static const  JUMP = "jump";
		public static const IDLE = "idle";
		public function MoveStatus() 
		{
			
		}
		
	}

}