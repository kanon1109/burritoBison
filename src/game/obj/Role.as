package game.obj 
{
import game.GameConstant;
import laya.display.Sprite;
import laya.resource.Texture;
import laya.utils.Handler;
/**
 * ...角色
 * 拥有外表动作
 * @author Kanon
 */
public class Role extends GameObject 
{
	private var _gravity:Number = 0;
	public function Role() 
	{
		super();
		this.init();
	}
	
	private function init():void
	{
		this.loadImage(GameConstant.GAME_RES_PATH + "role.png", 0, 0, 0, 0, Handler.create(this, loadCompleteHandler));
		this.scaleX = -this.scaleX;
	}
	
	override public function update():void 
	{
		super.update();
		//重力
		this.vy += this._gravity;
	}
	
	private function loadCompleteHandler(tex:Texture):void 
	{
		//锚点
		this.pivotX = tex.width / 2;
		this.pivotY = tex.height / 2;
		this.width = tex.width;
		this.width = tex.height;
	}
	
		
	/**
	 * 重力加速度
	 */
	public function get gravity():Number {return _gravity;}
	public function set gravity(value:Number):void 
	{
		_gravity = value;
	}
}
}