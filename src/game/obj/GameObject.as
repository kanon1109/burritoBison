package game.obj 
{
import laya.display.Sprite;
/**
 * ...游戏对象
 * @author Kanon
 */
public class GameObject extends Sprite 
{
	//速度
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var speedVx:Number = 0;
	public function GameObject() 
	{
		
	}
	
	/**
	 * 游戏对象更新方法
	 */
	public function update():void
	{
		this.x += this.vx;
		this.y += this.vy;
	}
}
}