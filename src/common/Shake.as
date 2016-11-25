package common 
{
import laya.display.Sprite;
import utils.Random;
/**
 * ...
 * @author Kanon
 */
public class Shake 
{
	private static var target:Sprite;
	private static var delay:int;
	private static var shakeDelta:Number;
	private static var targetY:Number;
	public function Shake() 
	{
		
	}
	
	
	public static function shake(target:Sprite, delay:int = 5, shakeDelta:Number = 5):void
	{
		Shake.target = target;
		Shake.targetY = target.y;
		Shake.delay = delay;
		Shake.shakeDelta = shakeDelta;
	}
	
	
	public static function update():void
	{
		if (Shake.target)
		{
			Shake.delay--;
			trace(Shake.delay)
			if (Shake.delay > 0)
			{
				Shake.target.y += Shake.shakeDelta * Random.randint(-1, 1);
			}
			else
			{
				Shake.target.y = Shake.targetY;
				Shake.delay = 0;
			}
		}
	}
}
}