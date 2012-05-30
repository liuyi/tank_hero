package com.ourbrander.actengine.math 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author liu yi
	 */
	public class VectorCalculate
	{
		
		public function VectorCalculate() 
		{
			
		}
		
		//获取两条直线或选段的相交点，如果没有相交则返回null，有相交的话则返回[x,y]的数组。参数line为2的话，则验证的是两条直线。
		//line=1,一条是直线一条是线段的,默认前面的x1,y1,x2,y2属于线段上的点。line=0都是线段
		//这个是从mathkit里拷贝过来的为了配合这个引擎里的矢量碰撞检测。
		public static  function Line2Line(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number, line:uint=0):Point {
			var intersected:Boolean = false
			var k1, b1, k2, b2:Number;
			 
			b1 = (y2 * x1 - y1 * x2) / (x1 - x2);
			k1 = (y1 - b1) / x1;
			
			b2 = (y4 * x3 - y3 * x4) / (x3 - x4);
			k2 = (y3 - b2) / x3;
			
			//trace(k1,k2)
			if (k1==k2) {
				//如果两个直线或线段的斜率相同，则是平行的。
			}else {
			    //计算直线或线段的交点
				var nx:Number
				if (k1==-Infinity || k1==Infinity) {
						nx=x1
				}else if ( k2 == -Infinity || k2==Infinity)
				{
					nx=x3
				}
				else{
					nx = (b2 - b1) / (k1 - k2);
				}
				var ny:Number = k1 * nx + b1;
				 
				
				if (line==2) {
					//如果是两条直线:
					intersected = true;
				}else if (line == 1) 
				{ 
					//是一条直线与一条线段相交:
					var tx1, tx2:Number
					if (x1 < x2) {
						if (x1<=nx && x2>=nx) {
							intersected=true
						}
					}else {
						if (x1>=nx && x2<=nx) {
							intersected=true
						}
					}
				}
				else if (line == 0)
				{
					//都是线段
					
					var t=0
					if (x1 < x2) {
						if (x1<=nx && x2>=nx) {
							t+=0.5
						}
					}else {
						if (x1>=nx && x2<=nx) {
							t+=0.5
						}
					}
					
					if (x3 < x4) {
						if (x3<=nx && x4>=nx) {
							t+=0.5
						}
					}else {
						if (x3>=nx && x4<=nx) {
							t+=0.5
						}
					}
					
					
					if (t>=1) {
						intersected=true
					}
				}//end if
				
			}//end if
			if (intersected==true) {
				return new Point(nx, ny)
			}else {
				return null
			}
		}//end function
		
		
		//线段或直线是否与多边形相交，返回相交状态和相交点。line:0为线段与多边形，1为直线与多边形
		public static function getIntersectionBetweenLineAndPolygon(x1, y1, x2, y2, polygon:Polygon, line:uint = 0):Array {
			//返回一个数组，这个数组包括下面的 point,还要包括一组分析数据。在线段或直线与多边形交点的两边，交点的分布数量。
			var polygon:Polygon = polygon
			
			var len:uint = polygon.points.length
			var point:Array //[[x,y],[x,y],[x,y]]依次是交点、交点所在边的顶点A，顶点B
			//这个数组将会按照序列返回新生成的节点分布（将交点插入到节点序列中。）
			var pathNode:Array=[]
			//计算该直线是否与多边形的每个边相交，并给出相交的点
			
			for (var i = 0; i < len; i++ ) {
				//判断目标点是不是顶点
				
				if (x1 == polygon[i][0] && y1 == polygon[i][1]) {
					//trace("is peak")
					return [point,pathNode]
				}
				
				var g:uint = ((i + 1) == len)?0:i + 1
				
				var p:Array = MathKit.getLineIntersection(polygon[i][0], polygon[i][1], polygon[g][0], polygon[g][1], x1, y1, x2, y2,0);
				//trace(p)
				pathNode.push([polygon[i][0], polygon[i][1], 0])//最后一个数字表示该点的状态:0为顶点，1为交点，2为最后的交点.
				
				if (p != null) {
				    //如果交点不是顶点或者目标点的话，就插入交点到节点序列里。
					if (  isExist(p[0], p[1]) == false) {
						
						if (point == null) {
							point = [];
						}
						//point.push([p, [polygon[i][0]], polygon[i][1]], [ polygon[g][0], polygon[g][1]]);
					 
						point.push([p[0],p[1]]);
						pathNode.push([p[0], p[1]])
					}else {
						//如果交点是顶点或目标点的话，则不插入该点，但是要标记是如果是最后的一个交点的话则要标记
						
					}
				}
				
			}//end for
			
			
			//判断相交点是否是顶点和目标点
			function isExist($x1,$y1):Boolean {
				for (var k = 0; k < len; k++ ) {
					//判断相交点是不是顶点
					if ($x1==polygon[k][0] && $y1==polygon[k][1]) {
						return true
					}
					
					//判断相交点是不是目标点
					if ($x1==x1 && $y1==y1) {
						return true
					}
				}
				return false
			}
			return [point,pathNode]//如果result[0]=null则没有相交点，result[1]是返回的插入了交点的多边形节点序列。
			
		}//end fuction
		
	}

}