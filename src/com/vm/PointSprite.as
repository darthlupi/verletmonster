package com.vm 
{

	import org.flixel.*;	
	
	public class PointSprite extends FlxSprite
	{
		
		public var which:int = 0; //Store the current id of the point :)
		public var which_frame:int = 0; //Store the frame of the point :)
		
		public function PointSprite(X:int, Y:int,Point:int):void
		{
			super(X, Y);
			createGraphic(6, 6,0xffFFFFFF);
			offset.x = offset.y = 3;
			which = Point;  //Make sure the point knows where it is in the array :)
		}
	}
}