package game.obj 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Animation;
import laya.events.Event;
import laya.resource.Texture;
import laya.utils.Handler;
import support.NotificationCenter;
import utils.Random;
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
	private var flyAni:Animation;
	private var bounce:Animation;
	private var flyAni1:Animation;
	private var flyAni2:Animation;
	private var bounce1:Animation;
	private var bounce2:Animation;
	//是否在下落
	private var isFall:Boolean;
	private var isBounce:Boolean;
	private var isBounceComplete:Boolean;
	private var isFlying:Boolean;
	private var flyIndex:int;
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
		this.isFlying = false;
		this.flyIndex = 1;
		this.isBounceComplete = true;
		
		this.pivotX = config.GameConstant.ROLE_WIDTH / 2;
		this.pivotY = config.GameConstant.ROLE_HEIGHT / 2;
		this.width = config.GameConstant.ROLE_WIDTH;
		this.width = config.GameConstant.ROLE_HEIGHT;
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
		this.flyAni2.visible = false;
		this.addChild(this.flyAni2);

		this.bounce1 = this.createAni("roleBounce1.json");
		this.bounce1.visible = false;
		this.addChild(this.bounce1);
		
		this.bounce2 = this.createAni("roleBounce2.json");
		this.bounce2.visible = false;
		this.addChild(this.bounce2);

		this.scaleX = -this.scaleX;
	}
	
	private function createAni(name:String):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_RES_PATH + name);
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
			if (Math.abs(this.vy) < this.minVy)
				this.vy = 0;
			else
				NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_BOUNCE);
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
		if (!this.isFlying && this.isFall && this.isBounceComplete)
		{
			this.isFlying = true;
			if (this.bounce)
			{
				this.bounce.stop();
				this.bounce.visible = false;
			}
			this.flyIndex = Random.randint(1, 2);
			if (this.flyAni)
			{
				this.flyAni.visible = false;
				this.flyAni.gotoAndStop(1);
			}
			this.flyAni = this["flyAni" + this.flyIndex];
			this.flyAni.visible = true;
			this.flyAni.play(0, false);
		}
		
		if (this.isBounceComplete && this.isBounce)
		{
			this.isBounceComplete = false;
			this.isFlying = false;
			this.flyAni.stop();
			this.flyAni.visible = false;
			if (this.bounce)
			{
				this.bounce.visible = false;
				this.bounce.gotoAndStop(1);
			}
			this.bounce = this["bounce" + this.flyIndex];
			this.bounce.visible = true;
			this.bounce.play(0, false);
			this.bounce.on(Event.COMPLETE, this, bounceComplete);
		}
	}
	
	//弹起结束
	private function bounceComplete():void 
	{
		this.isBounceComplete = true;
		this.isBounce = false;
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