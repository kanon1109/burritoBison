package game.obj 
{
/**
 * ...游戏背景（包括前景）
 * @author Kanon
 */
public class GameBackGround extends GameObject 
{
	private var _prevBg:GameObject;
	public function GameBackGround() 
	{
		super();
	}
	
	/**
	 * 上一个背景
	 */
	public function get prevBg():GameObject {return _prevBg; }
	public function set prevBg(value:GameObject):void 
	{
		_prevBg = value;
	}
}
}