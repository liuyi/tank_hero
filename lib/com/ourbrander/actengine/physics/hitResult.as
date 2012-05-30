package com.ourbrander.actengine.physics 
{
	import flash.geom.Point;
 
	/**
	 * ...
	 * @author ...
	 */
	public class hitResult extends Object
	{
		public var hitCount:uint;
		public var hitPoints:Array
		public function hitResult() 
		{
			hitPoints = []
	
			//0,1,2,3 start from top ,right,bottom, left;
			/*try{
				hitPoints[0] = [];
				hitPoints[1] =[];
				hitPoints[2] = [];
				hitPoints[3]=[];
			}catch(e){	trace("hitResult error:",e)}*/
		
		 
			hitCount = 0;
		
			
		}
		
	}

}