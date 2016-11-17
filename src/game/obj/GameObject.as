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
	private var _vx:Number = 0;
	private var _vy:Number = 0;
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
	
	/**
	 * 横向速度
	 */
	public function get vx():Number {return _vx;}
	public function set vx(value:Number):void 
	{
		_vx = value;
	}
	
	/**
	 * 纵向速度
	 */
	public function get vy():Number {return _vy;}
	public function set vy(value:Number):void 
	{
		_vy = value;
	}
}
}