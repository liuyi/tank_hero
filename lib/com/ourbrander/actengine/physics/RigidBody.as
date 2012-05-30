package com.ourbrander.actengine.physics 
{
	import com.ourbrander.actengine.physics.Collision;
	/**
	 * ...
	 * @author liuyi
	 */
	public class RigidBody 
	{
		private var _collision:Collision
		public function RigidBody() 
		{
			
		}
		
		public function set collision (c:Collision) {
			_collision = c;
		}
		public function get collision():Collision {
			return _collision;
		}
		
		
	}

}