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
	private static var delay:uint;
	private static var shakeDelta:Number;
	public function Shake() 
	{
		
	}
	
	
	public static function shake(target:Sprite, delay:uint = 5, shakeDelta:Number = 5):void
	{
		Shake.target = target;
		Shake.delay = delay;
		Shake.shakeDelta = shakeDelta;
	}
	
	
	public static function update():void
	{
		if (Shake.target)
		{
			Shake.delay--;
			if (Shake.delay > 0)
			{
				Shake.target.y += Shake.shakeDelta * Random.randint(-1, 1);
			}
			else
			{
				Shake.target.y = 0;
				Shake.delay = 0;
			}
		}
	}
}
}