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
	//重力
	private var gravity:Number;
	//移动速度
	private var _speed:Number;
	//横向摩擦力
	private var frictionX:Number;
	//纵向摩擦力
	private var frictionY:Number;
	//顶部范围
	private var topY:int;
	//角色最小下落速度（小于这个速度不再弹起）
	private var minVy:Number;
	
	//跳跃速度
	private var _jumpSpeed:Number;
	//是否飞入顶部区域
	private var _isOutTop:Boolean;
	//地板坐标
	private var _groundY:int;
	public function Role() 
	{
		super();
		this.initData();
		this.init();
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this._speed = 0;
		this._jumpSpeed = 60;
		this._isOutTop = false;
		
		this.gravity = .98;
		this.topY = 200;
		this.minVy = 5;
		this.frictionX = .9;
		this.frictionY = .7;
	}
	
	/**
	 * 初始化
	 */
	private function init():void
	{
		this.loadImage(GameConstant.GAME_RES_PATH + "role.png", 0, 0, 0, 0, Handler.create(this, loadCompleteHandler));
		this.scaleX = -this.scaleX;
	}
		
	private function loadCompleteHandler(tex:Texture):void 
	{
		//锚点
		this.pivotX = tex.width / 2;
		this.pivotY = tex.height / 2;
		this.width = tex.width;
		this.width = tex.height;
	}
	
	override public function update():void 
	{
		this.x += this.vx;
		if (!this._isOutTop) this.y += this.vy;
		this.vy += this.gravity;
		if (this.y > this._groundY)
		{
			this.y = this._groundY;
			this.speed *= this.frictionX;
			this.vy = -this.vy * this.frictionY;
			//下落速度过小则停下
			if (Math.abs(this.vy) < this.minVy) this.vy = 0;
		}
		//速度过小停下
		if (Math.abs(this.speed) < 1) this.speed = 0;
		//超过顶部范围
		if (this.y < this.topY)
		{
			this.y = this.topY;
			this._isOutTop = true;
		}
	}

	/**
	 * 跳跃
	 */
	public function jump():void
	{
		this.vy = this.jumpSpeed;
	}
	
	/**
	 * 跳跃速度
	 */
	public function get jumpSpeed():Number {return _jumpSpeed; }
	public function set jumpSpeed(value:Number):void 
	{
		_jumpSpeed = value;
	}
	
	/**
	 * 是否飞入顶部区域
	 */
	public function get isOutTop():Boolean {return _isOutTop;}
	public function set isOutTop(value:Boolean):void 
	{
		_isOutTop = value;
	}
	
	/**
	 * 地板坐标
	 */
	public function get groundY():int {return _groundY; }
	public function set groundY(value:int):void 
	{
		_groundY = value;
	}
	
	/**
	 * 移动速度
	 */
	public function get speed():Number {return _speed;}
	public function set speed(value:Number):void 
	{
		_speed = value;
	}
}
}