package game.obj 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Animation;
import laya.events.Event;
import laya.resource.Texture;
import laya.utils.Handler;
import laya.utils.Tween;
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
	//角色最小移动速度
	private var minVx:Number;
	//角色最小下落速度（小于这个速度不再弹起）
	private var minVy:Number;
	//是否飞入顶部区域
	private var _isOutTop:Boolean;
	//是否到滚屏位置
	private var _isOnTop:Boolean;
	//地板坐标
	private var _groundY:int;
	//动作动画
	private var flyAni:Animation;
	private var bounceAni:Animation;
	private var flyAni1:Animation;
	private var flyAni2:Animation;
	private var bounceAni1:Animation;
	private var bounceAni2:Animation;
	private var failAni:Animation;
	private var failRunAni:Animation;
	//是否在下落
	private var isFall:Boolean;
	//是否着地停下
	private var isFail:Boolean;
	private var isFailRun:Boolean;
	//是否在弹起
	private var isBounce:Boolean;
	//弹起是否结束
	private var isBounceComplete:Boolean;
	//是否在飞行
	private var isFlying:Boolean;
	//飞行动作的索引
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
		this.minVx = 5;
		this.minVy = 10;
		this.frictionX = .9;
		this.frictionY = .7;
		this.isFail = false;
		this.isFailRun = false;
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

		this.bounceAni1 = this.createAni("roleBounce1.json");
		this.bounceAni1.visible = false;
		this.addChild(this.bounceAni1);
		
		this.bounceAni2 = this.createAni("roleBounce2.json");
		this.bounceAni2.visible = false;
		this.addChild(this.bounceAni2);

		this.failAni = this.createAni("roleFail.json");
		this.failAni.visible = false;
		this.addChild(this.failAni);
		
		this.failRunAni = this.createAni("roleFailRun.json");
		this.failRunAni.y = -80;
		this.failRunAni.visible = false;
		this.addChild(this.failRunAni);

		this.scaleX = -this.scaleX;
	}
	
	private function createAni(name:String):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_RES_PATH + name);
		ani.interval = 60;
		ani.stop();
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
		if (Math.abs(this.speed) < this.minVx) this.speed = 0;
		if (this.speed == 0 && this.vy == 0)
		{
			this.isFail = true;
		}
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
		if (!this.isFail)
		{
			if (!this.isFlying && this.isFall && this.isBounceComplete)
			{
				this.isFlying = true;
				if (this.bounceAni)
				{
					this.bounceAni.stop();
					this.bounceAni.visible = false;
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
				if (this.bounceAni)
				{
					this.bounceAni.visible = false;
					this.bounceAni.gotoAndStop(1);
				}
				this.bounceAni = this["bounceAni" + this.flyIndex];
				this.bounceAni.visible = true;
				this.bounceAni.play(0, false);
				this.bounceAni.on(Event.COMPLETE, this, bounceComplete);
			}
		}
		else
		{
			if (!this.isFailRun)
			{
				this.isFailRun = true;
				this.flyAni.stop();
				this.bounceAni.stop();
				this.flyAni.visible = false;
				this.bounceAni.visible = false;
				this.failAni.visible = true;
				this.failAni.y = 0;
				this.timerOnce(400, this, function() {
					this.failAni.play(0, false);
				});
				this.timerOnce(580, this, function() {
					this.failAni.y = -80;
				});
				this.failAni.on(Event.COMPLETE, this, failComplete);
			}
		}
	}
	
	private function failComplete():void 
	{
		this.failAni.visible = false;
		this.failRunAni.visible = true;
		this.failRunAni.play(0, false);
		NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_FAIL_STAND);
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