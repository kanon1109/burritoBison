package game.obj 
{
import game.GameConstant;
import laya.display.Animation;
import laya.events.Event;
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
	//是否飞入顶部区域
	private var _isOutTop:Boolean;
	//是否到滚屏位置
	private var _isOnTop:Boolean;
	//地板坐标
	private var _groundY:int;
	//动画
	private var flyAni1:Animation;
	private var flyAni2:Animation;
	private var bounce1:Animation;
	//是否在下落
	private var isFall:Boolean;
	private var isBounce:Boolean;
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
		this._speed = 20;
		this._isOutTop = false;
		
		this.gravity = .98;
		this.topY = 200;
		this.minVy = 5;
		this.frictionX = .9;
		this.frictionY = .7;
		this.isFall = false;
		this.isBounce = false;
		
		this.pivotX = GameConstant.ROLE_WIDTH / 2;
		this.pivotY = GameConstant.ROLE_HEIGHT / 2;
		this.width = GameConstant.ROLE_WIDTH;
		this.width = GameConstant.ROLE_HEIGHT;
	}
	
	/**
	 * 初始化
	 */
	private function init():void
	{
		this.flyAni1 = this.createAni("roleFly1.json");
		this.flyAni1.visible = false;
		this.addChild(this.flyAni1);
		
		this.flyAni2 = this.createAni("roleFly2.json");
		
		this.bounce1 = this.createAni("roleBounce1.json");
		this.addChild(this.bounce1);
		this.bounce1.visible = false;


		this.scaleX = -this.scaleX;
	}
	
	private function createAni(name:String):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(GameConstant.GAME_RES_PATH + name);
		ani.interval = 60;
		return ani;
	}
	
	override public function update():void 
	{
		this.x += this.vx;
		if (!this._isOnTop) this.y += this.vy;
		this.vy += this.gravity;
		if (this.y > this._groundY)
		{
			//弹起
			this.isBounce = true;
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
			if (!this._isOutTop) this.y = this.topY;
			this._isOnTop = true;
		}
		else if (this.y > this.topY)
		{
			this._isOutTop = false;
		}
		
		//下落
		this.isFall = this.vy > 0;
		this.updateAniState();
	}
	
	/**
	 * 更新状态
	 */
	private function updateAniState():void
	{
		if (!this.flyAni1.visible && this.isFall && !this.isBounce)
		{
			this.bounce1.stop();
			this.bounce1.visible = false;
			this.flyAni1.visible = true;
			this.flyAni1.play(0, false);
		}
		
		if (!this.bounce1.visible && this.isBounce)
		{
			this.flyAni1.stop();
			this.flyAni1.visible = false;
			this.bounce1.visible = true;
			this.bounce1.play(0, false);
			this.bounce1.on(Event.COMPLETE, this, bounceComplete);
		}
	}
	
	//弹起结束
	private function bounceComplete():void 
	{
		this.isBounce = false;
		trace("colp;ete")
	}

	/**
	 * 跳跃
	 */
	public function jump(speed:Number):void
	{
		this.vy = speed;
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
	
	/**
	 * 是否到滚屏位置
	 */
	public function get isOnTop():Boolean {return _isOnTop;}
	public function set isOnTop(value:Boolean):void 
	{
		_isOnTop = value;
	}
}
}