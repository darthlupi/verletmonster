package com.vm.Verlet {
	/**
	 * @website http://www.yoambulante.com/
	 * @author Alex Nino
	 */
	public class VPoint{
		public var x:Number;
		public var y:Number;
		private var oldx:Number;
		private var oldy:Number;
		
		public function VPoint(x:Number, y:Number) {
			setPos(x,y);
		}
		
		public function setPos(x:Number, y:Number):void{
			this.x = oldx = x;
			this.y = oldy = y;
		}
		
		public function refresh():void {
			var tempx:Number = x;
			var tempy:Number = y;
			//This basically sets velocity...
			x += x - oldx;
			y += y - oldy;
			oldx = tempx;
			oldy = tempy;
		}
		
	}

}