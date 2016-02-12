package com.vm 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author mark
	 */
	public class TestState extends FlxState
	{
		
		public static var line_group:FlxGroup = new FlxGroup();
		public static var point_group:FlxGroup = new FlxGroup();
		
		private var _current_line:LineSprite; //The current line being drawn...
		private var _current_point:PointSprite; //Current Point...
		
		private var _point_lit:int = 0; //If a point is moused over or not
		
		private var _start_point:int = -1; //Store the current index of the member array in the FlxGroup 
										   //of first point selected
		private var _end_point:int = -1; //Store the current index of the member array in the FlxGroup 
										 //of last point selected
		
		private var _draw_go:int = 0; //Drawing line or not...
		
		private var _draw_mode:String = "Point"; //Line or Point for drawing guess what, lines or points.
		
		//Buttons
		private var _mode_draw:FlxText;
		

		
		override public function create():void
		{
				//Used instead of the constructor for some reason - A  reason I forgot...
				add(point_group);
				add(line_group);
				
				_mode_draw = new FlxText(10, 420, 400, "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...");
				
				add(_mode_draw);
				FlxG.mouse.show();
		}
		
		
		private function switchMode():void
		{
			//Switch drawing mode :)
			if (  _draw_mode == "Line" )
				_draw_mode = "Point";
			else
				_draw_mode = "Line";
			//Refresh menu text
			_mode_draw.text = "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...";
		}
		
		
		override public function update():void
		{
			//Alls the magic happens here :)
			
	
			if ( FlxG.keys.justPressed("M") )
				switchMode();
			
			//Draw
			if ( FlxG.mouse.justPressed() )
			{
				//Draw lines between points
				if ( _draw_mode == "Line" && _point_lit )
				{
					_current_line = new LineSprite();
					_current_line.startLine(FlxG.mouse.x , FlxG.mouse.y, FlxG.mouse.x , FlxG.mouse.y);
					line_group.add(_current_line); //Save to group - used for drawing and for export - what!?! 
					_draw_go = 1; //Go into line drawing state!
				}

				//Place points on the map
				if ( _draw_mode == "Point" )
				{
					_current_point = new PointSprite(FlxG.mouse.x, FlxG.mouse.y, point_group.members.length);
					point_group.add(_current_point);
				}
			}
			
			//Stop drawing if drawing ( draw_go = 1 )
			if ( !FlxG.mouse.pressed() && _draw_go == 1 )
			{
				if ( _draw_mode == "Line" )
				{
					if ( _end_point < 0 ) //If there is no end point then remove the current line
					{
						line_group.remove(_current_line);
						//_current_line.kill();
						trace("KILLLLLL" + _end_point);
						//Reset the start and end point for saving lines
						_start_point = -1;
						_end_point = -1;						
					}
					else //If the is an end point then complete the line!
					{
						_current_line.end_point = _end_point;
						trace( "START:" + _current_line.start_point + " END:" +_current_line.end_point);
						//Reset the start and end point for saving lines
						_start_point = -1;
						_end_point = -1;						
					}
					

				}
				_draw_go = 0; //Turn off drawing
			}
			
			if ( _draw_go )
			{
				if ( _draw_mode == "Line" )
				{
					_current_line.targetX = FlxG.mouse.x;
					_current_line.targetY = FlxG.mouse.y;
				}
			}
			
			
			//Select Points
			_point_lit = 0; //Reset the point selection...
			_end_point = -1; //Reset end point -- should be reset as long as you are highlighting something other than the start point
			for each ( var tmp_point:PointSprite in point_group.members )
			{
				//Point is highlighted
				if ( tmp_point.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y) )
				{
					tmp_point.color = 0xFF0000; //Change the color to red
					_point_lit = 1; //A point is selected
					
					//If drawing a line
					if ( _start_point == -1 && _draw_go == 1 )
					{
						_start_point = tmp_point.which;
						trace( "START:" + _current_line.start_point );
					}
					
					if ( tmp_point.which != _start_point && _start_point > -1 && _draw_go == 1)
					{
						_end_point = tmp_point.which;
						_current_line.targetX = tmp_point.x;
						_current_line.targetY = tmp_point.y;
						trace( "START:" + _start_point + " END:" +_end_point);
					}
				}
				else //Point is not highlighted
				{
					tmp_point.color = 0xFFFFFF; //Change color back to white ( not selected )
				}
				
			}
			
			
		}
	}

}