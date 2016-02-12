package com.vm
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import org.flixel.*;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
	public class LineSprite extends FlxSprite
	{
		private var radius:Number = 1;
		private var visibleDuration:Number = .25;
		private var visibleTimer:Number;
		public var targetX:int;
		public var targetY:int;
		private var boltOrigin:FlxPoint;
		private var _thickness:Number; //Line Thickness
		private var _line_color:uint = 0xFF3333;
		
		public var start_point:int = 0;
		public var end_point:int = 0;
		
		public function LineSprite():void
		{
			super();
			solid = false;
			boltOrigin = new FlxPoint()
		}
		
		public function SetTarget(Target:FlxPoint):void
		{
			targetX = Target.x;
			targetY = Target.y;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			var canvas:Shape = new Shape();
			var scrollX:int = FlxG.scroll.x;
			var scrollY:int = FlxG.scroll.y;

			canvas.graphics.clear();
			canvas.graphics.lineStyle(_thickness, 0xffffff);
			canvas.graphics.moveTo (boltOrigin.x, boltOrigin.y);

			canvas.graphics.lineTo (targetX+scrollX, targetY+scrollY);
			canvas.graphics.endFill();
			FlxG.buffer.draw(canvas,null,null,"screen");	
		}
		
		

		public function startLine(startX:Number, startY:Number, TargetX:Number, TargetY:Number,StartPoint:int=0,Thickness:Number=2,Color:uint=0xFF3333):void
		{
			boltOrigin.x = startX+FlxG.scroll.x;
			boltOrigin.y = startY + FlxG.scroll.y;
			_line_color = Color;
			_thickness = Thickness;
			targetX = TargetX;
			targetY = TargetY;
		}
	}
}