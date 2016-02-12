package com.vm.Verlet  {
	import flash.geom.Point;
	/**
	 * @website http://www.yoambulante.com/
	 * @author Alex Nino
	 */
	public class VStick{
		public var pointa:VPoint;
		public var pointb:VPoint;
		private var hypotenuse:Number;
		
		public function VStick(a:VPoint, b:VPoint) {
			pointa = a;
			pointb = b;
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			hypotenuse = Math.sqrt(dx * dx + dy * dy);
		}
		
		public function contract():void {
			var dx:Number = pointb.x - pointa.x;
			var dy:Number = pointb.y - pointa.y;
			var h:Number = Math.sqrt(dx * dx + dy * dy);
			var diff:Number = hypotenuse - h;
			var offx:Number = (diff * dx / h) * .5;
			var offy:Number = (diff * dy / h) * .5;
			pointa.x -= offx;
			pointa.y -= offy;
			pointb.x += offx;
			pointb.y += offy;
		}
		
	}

}