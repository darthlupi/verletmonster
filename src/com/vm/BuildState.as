package com.vm 
{
	import com.vm.Verlet.VPoint;
	import com.vm.Verlet.VStick;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import org.flixel.*;
	/**
	 * ...
	 * @author mark
	 */
	public class BuildState extends FlxState
	{
		
		public static var line_group:FlxGroup = new FlxGroup();
		public static var point_group:FlxGroup = new FlxGroup();

		public static var test_group:FlxGroup = new FlxGroup();
	
		private var _current_line:LineSprite; //The current line being drawn...
		private var _current_point:PointSprite; //Current Point...
		
		private var _point_lit:int = 0; //If a point is moused over or not
		
		private var _start_point:int = -1; //Store the current index of the member array in the FlxGroup 
										   //of first point selected
		private var _end_point:int = -1; //Store the current index of the member array in the FlxGroup 
										 //of last point selected
		
		private var _draw_go:int = 0; //Drawing line or not...
		
		private var _draw_mode:String = "Point"; //Line or Point for drawing guess what, lines or points.
		private var _mode:String = "Edit";//Edit or test...
		//Text
		private var _mode_draw:FlxText;
		
		//Gravity
		private var _gravity:Number = 20;
		
		//TESTING VARS
		
		private var _verlet_points:Array = new Array;
		private var _verlet_sticks:Array = new Array;	
		private var _verlet_pieces:Array = new Array;	
		
		//Saving..
		private var getFile:File = File.documentsDirectory;
		

		
		override public function create():void
		{
				//Used instead of the constructor for some reason - A  reason I forgot...
				add(point_group);
				add(line_group);
				
				add(test_group);
		
				_mode_draw = new FlxText(10, 420, 400, "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...\nGravity="+_gravity );
				
				add(_mode_draw);
				FlxG.mouse.show();
		}
		
		

		//Switch between Line and Point draw modes
		private function switchMode():void
		{
			//Switch drawing mode :)
			if (  _draw_mode == "Line" )
				_draw_mode = "Point";
			else
				_draw_mode = "Line";
			//Refresh menu text
			_mode_draw.text = "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...\nGravity=" + _gravity;
		}
		
		//Switch between test mode and edit
		private function switchMainMode():void
		{
			
			var tmp_point:PointSprite;
			var tmp_line:LineSprite;
			
			//Switch to EDIT mode
			if (  _mode == "Test" )
			{
				_mode = "Edit";
				//Reset the test verlet arrays
				_verlet_points = [];
				_verlet_sticks = [];
				_verlet_pieces = [];
				test_group.members = [];
				
				
				for each ( tmp_point in point_group.members )
				{
					tmp_point.visible = true;
				}
				for each ( tmp_line in line_group.members )
				{
					tmp_line.visible = true;
				}					
			}
			else //Switch to Test Mode
			{
				
				//Reset the test verlet arrays
				_verlet_points = [];
				_verlet_sticks = [];
				_verlet_pieces = [];
				test_group.members = [];
				
				_mode = "Test";
				
				//Build array of VPoints
				for each ( tmp_point in point_group.members )
				{
					tmp_point.visible = false;
					//Push coordinates from the points into the verlet points
					_verlet_points.push( new VPoint(tmp_point.x,tmp_point.y) )
				}
				//Build array of VSticks
				for each ( tmp_line in line_group.members )
				{
					_verlet_sticks.push( new VStick(_verlet_points[tmp_line.start_point], _verlet_points[tmp_line.end_point] ) );
					tmp_line.visible = false;
				}	
				//Build array of test sprites that represent the points....
				for (var i:int = 0; i < _verlet_points.length; i++) 
				{
					var tmp_piece:FlxSprite = new FlxSprite(_verlet_points[i].x, _verlet_points[i].y) ;
					tmp_piece.createGraphic(5, 5,0xffFFFFFF);
					_verlet_pieces.push( tmp_piece );
					test_group.add(tmp_piece);
					trace("X" + tmp_piece.x + " Y" + tmp_piece.y);
				}				
				
			}
			//Refresh menu text
			_mode_draw.text = "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...\nGravity="+_gravity;
		}		
		
		//Gravity 
		private function gravity(G:int):void
		{
			_gravity += G;
			_mode_draw.text = "MODE=" + _draw_mode + " Press M to switch draw mode...\nPress T to test...\nPress S to Save...\nGravity=" + _gravity;
			
		}
		
		
		//Save 
		private function openFile():void
		{
			try
			{
				trace("Trying to open file...");
				getFile.browseForSave("Save As");
				getFile.addEventListener(Event.SELECT, saveXML);
				
			}
			catch (error:Error)
			{
				trace("Failed:", error.message);
			}
			
		}
		
		
		
		private function saveXML(event:Event):void
		{
			
			var newFile:File = event.target as File;
			//if (newFile.exists)
			//{
				var stream:FileStream = new FileStream();
				stream.open(newFile,FileMode.WRITE);			
				var tmp_string:String = "<Verlet> ";
				//Output the points
				stream.writeUTFBytes(tmp_string);
				stream.writeUTFBytes(File.lineEnding);
				for each ( var tmp_point:PointSprite in point_group.members )
				{
					var tmp_point_first:PointSprite = point_group.members[0];
					tmp_string = "	<Point x=\"" + ( tmp_point.x - tmp_point_first.x )+ "\" y=\"" + ( tmp_point.y - tmp_point_first.y ) + "\" frame=\"" + tmp_point.which_frame + "\"\/>";
					trace(tmp_string);
					stream.writeUTFBytes(tmp_string);
					stream.writeUTFBytes(File.lineEnding);
				}
				//Output the lines
				for each ( var tmp_line:LineSprite in line_group.members )
				{
					tmp_string = "	<Line start=\"" + tmp_line.start_point + "\" end=\"" +  tmp_line.end_point + "\"\/>";
					trace(tmp_string);
					stream.writeUTFBytes(tmp_string);
					stream.writeUTFBytes(File.lineEnding);
				}	
				tmp_string = "</Verlet>";
				stream.writeUTFBytes(tmp_string);
				stream.writeUTFBytes(File.lineEnding);
				stream.close(); //Close file
			//}

			
			
		}
		
		
		//Alls the magic happens here :)
		override public function update():void
		{
			//Switch draw modes
			if ( FlxG.keys.justPressed("M") )
				switchMode();
				
			//Save stuff	
			if ( FlxG.keys.justPressed("S") )
				openFile();
			
			//Gravity
			if (FlxG.keys.pressed("X"))
			{
				gravity(1);
			}
			if (FlxG.keys.pressed("Z"))
			{
				gravity(-1);
			}			
				
			//Switch between edit and test mode...
			if ( FlxG.keys.justPressed("T") )
				switchMainMode();
				
			//Start over!!!
			if ( FlxG.keys.justPressed("C") )
				clear();
			
			//Edit mode
			if (_mode == "Edit")
				editorMode();
			if (_mode == "Test")
				testMode();
		}
		
		private function testMode():void
		{
			//Update verlet positions
			updateVerlet();
		}
		
		private function updateVerlet():void
		{
			//Load test objects and stuff
			//TEMP VERLET STUFF
			_verlet_points[0].x = FlxG.mouse.x;
			_verlet_points[0].y = FlxG.mouse.y;
			
			//Loop through _verlet_points
			var i:int = 0;
			
			for (i = 0; i < _verlet_points.length; i++) 
			{
				_verlet_points[i].y += FlxG.elapsed * _gravity; //Gravity
				_verlet_points[i].refresh();  //Set verlet velocity - add diff of old and new x,y
				
				_verlet_pieces[i].x = _verlet_points[i].x; //Update visible sprites
				_verlet_pieces[i].y = _verlet_points[i].y; //Update visible sprites
				
			}
            
			//This portion covers the constraints...
			//Currently only distance
			for (var stiff:int = 0; stiff < 10; stiff++)
			{
				for (i = 0; i < _verlet_sticks.length; i++) {
					_verlet_sticks[i].contract();
				}
			}					
		}
		
		private function clear():void
		{
			
			if (  _mode == "Test" )
			{
				switchMainMode();
			}
			//Reset the test verlet arrays
			_verlet_points = [];
			_verlet_sticks = [];
			_verlet_pieces = [];
			test_group.members = [];
			
			line_group.members = [];
			point_group.members = [];
			test_group.members = [];
			
			
		}
		
	
		private function editorMode():void
		{
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
			
			//Stop drawing if drawing ( draw_go = 1 ) and SAVE the current line information
			if ( !FlxG.mouse.pressed() && _draw_go == 1 )
			{
				if ( _draw_mode == "Line" )
				{
					if ( _end_point < 0 ) //If there is no end point then remove the current line
					{
						line_group.remove(_current_line,true);
						
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
						_current_line.start_point = tmp_point.which;
						trace( "START:" + _current_line.start_point );
					}
					
					if ( tmp_point.which != _start_point && _start_point > -1 && _draw_go == 1)
					{
						_end_point = tmp_point.which;
						_current_line.targetX = tmp_point.x;
						_current_line.targetY = tmp_point.y;
						//trace( "START:" + _start_point + " END:" +_end_point);
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