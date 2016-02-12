package
{
	import org.flixel.*;
	import com.vm.BuildState;

	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class VerletMonster extends FlxGame
	{
		public function VerletMonster()
		{
			super(640, 480, BuildState, 1);
			FlxState.bgColor = 0xff99AA55;
			
		}
	}
}
