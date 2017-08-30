package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.frontEnds.VCRFrontEnd;
import flixel.system.replay.FlxReplay;
import flixel.system.replay.FrameRecord;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _gravityBoxTest:FlxSprite;
	private var timer:Float = 0;
	
	private var _bg:FlxSprite;
	
	private static var recording:Bool = false;
	private static var replaying:Bool = false;
	
	override public function create():Void
	{
		_bg = new FlxSprite(0, 0);
		_bg.loadGraphic("assets/images/placeholder BG.png", false, 678, 465);
		add(_bg);
		
		_player = new Player(0, 200);
		add(_player);
		
		_gravityBoxTest = new FlxSprite(100, 0);
		_gravityBoxTest.makeGraphic(10, 10);
		_gravityBoxTest.maxVelocity.y = 300;
		_gravityBoxTest.acceleration.y = 100;
		add(_gravityBoxTest);
		
		init();
		
		super.create();
	}
	
	private function init():Void
	{
		if (recording)
		{
			_player.alpha = 1;
		}
		else if (replaying)
		{
			_player.alpha = 0.5;
		}
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.watch.add(_player.velocity, "x");
		
		timer += FlxG.elapsed;
		
		if (!recording && !replaying)
		{
			startRecording();
		}
		
		if (FlxG.keys.justPressed.R && recording)
		{
			loadReplay();
		}
		
		super.update(elapsed);
		
		/* this shit dont workkk
		if (replaying)
		{
			FlxG.timeScale = 1;
			//FlxG.game._elapsedMS = 17;
		}
		*/
	}


	private function startRecording():Void
	{
		recording = true;
		replaying = false;
		
		FlxG.vcr.startRecording(false);
	}
	
	private function loadReplay():Void
	{
		replaying = true;
		recording = false;
		
		
		var save:String = FlxG.vcr.stopRecording(false);
		FlxG.vcr.loadReplay(save, new PlayState(), ["ANY"], 0, startRecording);
	}
}