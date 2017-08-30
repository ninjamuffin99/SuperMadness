package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class Player extends FlxSprite 
{
	private var _acc:Float = 1200;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(100, 100, FlxColor.BLUE);
		maxVelocity.x = 300;
		maxVelocity.y = maxVelocity.x * 0.3;
		drag.x = drag.y = 700;
		
	}
	override public function update(elapsed:Float):Void 
	{
		
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyPressed(["W", "UP", "I"]);
		_down = FlxG.keys.anyPressed(["S", "DOWN", "K"]);
		_left = FlxG.keys.anyPressed(["A", "LEFT", "J"]);
		_right = FlxG.keys.anyPressed(["D", "RIGHT", "L"]);
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		
		var _avgTimeScale:Float = 0.1;
			
		if (_up || _down || _right || _left)
		{
			
			var mA:Float = 0;
			
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
			}
			else if (_left)
			{
				mA = 180;
			}
			else if (_right)
			{
				mA = 0;
			}
			
			acceleration.set(_acc, 0);
			acceleration.rotate(FlxPoint.weak(0, 0), mA);
		}
		else
			acceleration.x = acceleration.y = 0;
		
		var _velX:Float = velocity.x;
		var _velY:Float = velocity.y;
		
		if (_velX < 0)
			_velX = -_velX;
		if (_velY < 0)
			_velY = -_velY;
		
		_avgTimeScale = FlxMath.remapToRange(_velY, 0, maxVelocity.y, 0.1, 1.1) + FlxMath.remapToRange(_velX, 0, maxVelocity.x, 0.1, 1.1);
		
		
		
		if (_avgTimeScale < 0 )
		{
			_avgTimeScale = -_avgTimeScale;
		}
		
		_avgTimeScale = FlxMath.bound(_avgTimeScale, 0.1, 1.1);
		
		FlxG.timeScale = _avgTimeScale;
		
		
		FlxG.watch.add(FlxG, "timeScale");
		FlxG.watch.add(this.maxVelocity, "x");
		
		super.update(elapsed);
	}
}