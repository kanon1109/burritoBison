package game.obj 
{
import common.Shake;
import config.GameConstant;
import config.MsgConstant;
import laya.display.Animation;
import laya.events.Event;
import laya.ui.Image;
import laya.utils.Handler;
import laya.utils.Tween;
import support.NotificationCenter;
import utils.Random;
/**
 * ...角色
 * 拥有外表动作
 * 
 * @author Kanon
 */
public class Role extends GameObject 
{
	//重力
	private var gravity:Number;
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
	//动作动画
	private var flyAni:Animation;
	private var bounceAni:Animation;
	private var flyAni1:Animation;
	private var flyAni2:Animation;
	private var flyAni3:Animation;
	private var flyAni4:Animation;
	private var flyAni5:Animation;
	private var flyAni6:Animation;
	private var bounceAni1:Animation;
	private var bounceAni2:Animation;
	private var bounceAni3:Animation;
	private var bounceAni4:Animation;
	private var bounceAni5:Animation;
	private var bounceAni6:Animation;
	private var failAni:Animation;
	private var failRunAni:Animation;
	private var startAni:Animation;
	//受伤
	private var hurt1:Image;
	private var hurt2:Image;
	private var hurt3:Image;
	private var hurt:Image;
	private var fly:Image;
	//飞行动作的索引
	private var flyIndex:int;
	//受伤动作索引
	private var hurtIndex:int;
	private var hurtCount:int;
	//是否在下落
	private var isFall:Boolean;
	//是否着地停下
	private var _isFail:Boolean;
	private var isFailRun:Boolean;
	//是否在弹起
	private var isBounce:Boolean;
	//弹起是否结束
	private var isBounceComplete:Boolean;
	//是否在飞行
	private var isFlying:Boolean;
	//是否受伤
	private var isHurt:Boolean;
	//一次冲刺
	private var swoopOnce:Boolean;
	//是否开始冲撞boss
	private var isStartRush:Boolean;

	
	//----------public-----------
	//地板坐标
	public var groundY:int;
	//是否飞入顶部区域
	public var isOutTop:Boolean;
	//是否到滚屏位置
	public var isOnTop:Boolean;
	//是否开始
	public var isStart:Boolean;
	//俯冲速度
	public var swoopSpeed:Number;
	//超级俯冲
	public var superSwoopSpeed:Number;
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
		this.isOutTop = false;
		this.gravity = .98;
		this.swoopSpeed = 40;
		this.superSwoopSpeed = 50;
		this.topY = 200;
		this.minVx = 20;
		this.minVy = 20;
		this.frictionX = .9;
		this.frictionY = .8;
		this._isFail = false;
		this.isFailRun = false;
		this.isFall = false;
		this.isBounce = false;
		this.isFlying = false;
		this.swoopOnce = false;
		this.flyIndex = 1;
		this.hurtIndex = 1;
		this.hurtCount = 3;
		this.isBounceComplete = true;
		this.isStart = false;
		this.isStartRush = false;
		
		this.pivotX = config.GameConstant.ROLE_WIDTH / 2;
		this.pivotY = config.GameConstant.ROLE_HEIGHT / 2;
		this.width = config.GameConstant.ROLE_WIDTH;
		this.height = config.GameConstant.ROLE_HEIGHT;
		
		/*var testImg:Image = new Image(GameConstant.GAME_RES_PATH + "test.png");
		this.addChild(testImg);
		testImg.x = -this.width / 2;*/

/*		testImg = new Image(GameConstant.GAME_RES_PATH + "test.png");
		this.addChild(testImg);
		testImg.rotation = 90;*/
	}
	
	/**
	 * 初始化
	 */
	private function init():void
	{
		this.fly = new Image(GameConstant.GAME_ROLE_PATH + "roleFly.png");
		this.fly.visible = false;
		this.addChild(this.fly);

		this.startAni = this.createAni("roleStart.json");
		this.startAni.play();
		this.addChild(this.startAni);
		
		this.flyAni1 = this.createAni("roleFly1.json");
		this.flyAni1.visible = false;
		this.addChild(this.flyAni1);
		
		this.flyAni2 = this.createAni("roleFly2.json");
		this.flyAni2.visible = false;
		this.addChild(this.flyAni2);
		
		this.flyAni3 = this.createAni("roleFly3.json");
		this.flyAni3.visible = false;
		this.addChild(this.flyAni3);
		
		this.flyAni4 = this.createAni("roleFly4.json");
		this.flyAni4.visible = false;
		this.addChild(this.flyAni4);
		
		this.flyAni5 = this.createAni("roleFly5.json");
		this.flyAni5.visible = false;
		this.addChild(this.flyAni5);
		
		this.flyAni6 = this.createAni("roleFly6.json");
		this.flyAni6.visible = false;
		this.addChild(this.flyAni6);

		this.bounceAni1 = this.createAni("roleBounce1.json");
		this.bounceAni1.visible = false;
		this.addChild(this.bounceAni1);
		
		this.bounceAni2 = this.createAni("roleBounce2.json");
		this.bounceAni2.visible = false;
		this.addChild(this.bounceAni2);
		
		this.bounceAni3 = this.createAni("roleBounce3.json");
		this.bounceAni3.visible = false;
		this.addChild(this.bounceAni3);
		
		this.bounceAni4 = this.createAni("roleBounce4.json");
		this.bounceAni4.visible = false;
		this.addChild(this.bounceAni4);
		
		this.bounceAni5 = this.createAni("roleBounce5.json");
		this.bounceAni5.visible = false;
		this.addChild(this.bounceAni5);
		
		this.bounceAni6 = this.createAni("roleBounce6.json");
		this.bounceAni6.visible = false;
		this.addChild(this.bounceAni6);

		this.failAni = this.createAni("roleFail.json");
		this.failAni.visible = false;
		this.addChild(this.failAni);
		
		this.failRunAni = this.createAni("roleFailRun.json");
		this.failRunAni.y = this.failAni.y - 50;
		this.failRunAni.visible = false;
		this.addChild(this.failRunAni);
		
		this.hurt1 = new Image(GameConstant.GAME_ROLE_PATH + "roleHurt1.png");
		this.hurt1.visible = false;
		this.hurt1.width = 111;
		this.hurt1.height = 100;
		this.hurt1.pivot(this.hurt1.width / 2, this.hurt1.height / 2);
		this.hurt1.x = this.hurt1.width / 2;
		this.hurt1.y = this.hurt1.height / 2;
		this.addChild(this.hurt1);
		
		this.hurt2 = new Image(GameConstant.GAME_ROLE_PATH + "roleHurt2.png");
		this.hurt2.visible = false;
		this.hurt2.width = 128;
		this.hurt2.height = 92;
		this.hurt2.pivot(this.hurt2.width / 2, this.hurt2.height / 2);
		this.hurt2.x = this.hurt2.width / 2;
		this.hurt2.y = this.hurt2.height / 2;
		this.addChild(this.hurt2);
		
		this.hurt3 = new Image(GameConstant.GAME_ROLE_PATH + "roleHurt3.png");
		this.hurt3.visible = false;
		this.hurt3.width = 109;
		this.hurt3.height = 119;
		this.hurt3.pivot(this.hurt3.width / 2, this.hurt3.height / 2);
		this.hurt3.x = this.hurt3.width / 2;
		this.hurt3.y = this.hurt3.height / 2;
		this.addChild(this.hurt3);
		this.scaleX = -this.scaleX;
	}
	
	/**
	 * 创建动画
	 * @param	name	动画名
	 * @return
	 */
	private function createAni(name:String):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_ATLAS_PATH + name);
		ani.interval = 60;
		ani.stop();
		return ani;
	}
	
	override public function update():void 
	{
		if (!this.isStart) return;
		if (!this.isOnTop) this.y += this.vy;
		this.vy += this.gravity;
		if (this.y > this.groundY && !this._isFail)
		{
			//弹起
			this.bounce();
			this.y = this.groundY;
			if (!this.swoopOnce)
			{
				//如果不处于一次强制冲刺时播放受伤动画。
				this.isHurt = true;
				if (this.isHurt)
				{
					if (this.hurt) this.hurt.visible = false;
					this.hurt = this["hurt" + this.hurtIndex];
					this.hurt.rotation = 0;
					this.hurtIndex++;
					if (this.hurtIndex > this.hurtCount) this.hurtIndex = 1;
				}
				this.vx *= this.frictionX;
				//速度过小停下
				if (Math.abs(this.vx) < this.minVx && Math.abs(this.vy) < this.minVy) 
				{
					this._isFail = true;
					this.vx = 0;
					this.vy = 0;
					Shake.shake(this, 5);
				}
			}
			//最后一次停下不需要震动
			if (!this._isFail)
			{
				var shakeDelta:int = 7;
				if (this.swoopOnce) shakeDelta = 15;
				Shake.shake(Layer.GAME_BG_LAYER, 5, shakeDelta);
				NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_BOUNCE);
			}
			this.swoopOnce = false;
		}
		//超过顶部范围
		if (this.y < this.topY)
		{
			if (!this.isOutTop) this.y = this.topY;
			this.isOnTop = true;
		}
		else if (this.y > this.topY)
		{
			this.isOutTop = false;
		}
		
		if (this.isHurt && this.hurt)
			this.hurt.rotation -= this.vx / 3;
		//下落
		this.isFall = this.vy > 0;
		if (this.isFail) this.isStartRush = false;
		this.updateAniState();
	}
	
	/**
	 * 起始冲刺
	 * @param	isMaxPower	是否最大力冲刺
	 */
	public function startRush(isMaxPower:Boolean):void
	{
		if (!isMaxPower)
		{
			this.vx = 25;
			this.vy = -30;
		}
		else
		{
			this.vx = 50;
			this.vy = -35;
		}
		this.isStart = true;
	}
		
	/**
	 * 弹起
	 */
	public function bounce():void 
	{
		this.isBounce = true;
		this.vy = -this.vy * this.frictionY;
	}
	
	/**
	 * 冲击
	 */
	public function bump():void
	{
		this.stopStart();
		this.showFlyAni(6);
	}
	
	/**
	 * 更新状态
	 */
	private function updateAniState():void
	{
		if (!this._isFail)
		{	
			if (this.isStart)
			{
				this.stopStart();
				if (!this.isStartRush)
				{
					this.isStartRush = true;
					this.showFlyAni(6);
				}
			}
			
			if (!this.isHurt)
			{
				if (!this.isFlying && !this.isFall && this.isBounceComplete && !this.isStartRush)
				{
					this.fly.visible = true;
				}
				
				if (!this.isFlying && this.isFall && this.isBounceComplete)
				{
					this.isFlying = true;
					this.stopBounce();
					this.stopFly();
					this.stopHurt();
					this.fly.visible = false;
					this.flyIndex = Random.randint(1, 6);
					this.showFlyAni(this.flyIndex);
				}
				
				if (this.isBounceComplete && this.isBounce)
				{
					this.isBounceComplete = false;
					this.isFlying = false;
					this.stopFly();
					this.stopHurt();
					this.stopBounce();
					this.bounceAni = this["bounceAni" + this.flyIndex];
					this.bounceAni.visible = true;
					this.bounceAni.play(0, false);
					this.bounceAni.on(Event.COMPLETE, this, bounceComplete);
				}
			}
			else
			{
				//受伤动作
				this.stopFly();
				this.stopBounce();
				this.fly.visible = false;
				this.hurt.visible = true;
			}
		}
		else
		{
			//停下失败
			if (!this.isFailRun)
			{
				this.isFailRun = true;
				this.stopFly();
				this.stopBounce();
				this.stopHurt();
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
		this.stopFail();
		this.failRunAni.visible = true;
		this.failRunAni.play(0, false);
		Tween.to(this, { x: -100 }, 800, null, Handler.create(this, function() {
			NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_FAIL_RUN_COMPLETE);
		}))
	}
	
	/**
	 * 显示飞行动作
	 * @param	index	动作索引
	 */
	private function showFlyAni(index:int):void
	{
		this.flyAni = this["flyAni" + index];
		this.flyAni.visible = true;
		this.flyAni.play(0, false);
	}
	
	/**
	 * 停止失败动作
	 */
	private function stopFail():void
	{
		if (this.failAni)
		{
			this.failAni.gotoAndStop(1);
			this.failAni.visible = false;
		}
	}
	
	/**
	 * 停止失败跑步动作
	 */
	private function stopFailRun():void
	{
		if (this.failRunAni)
		{
			this.failRunAni.gotoAndStop(1);
			this.failRunAni.visible = false;
		}
	}
	
	/**
	 * 停止飞行动画
	 */
	private function stopFly():void
	{
		if (this.flyAni)
		{
			this.flyAni.gotoAndStop(1);
			this.flyAni.visible = false;
		}
	}
	
	/**
	 * 停止弹起动画
	 */
	private function stopBounce():void
	{
		if (this.bounceAni)
		{
			this.bounceAni.gotoAndStop(1);
			this.bounceAni.visible = false;
		}
	}
	
	/**
	 * 停止受伤动作
	 */
	private function stopHurt():void
	{
		if (this.hurt)
			this.hurt.visible = false;
	}
	
	/**
	 * 停止开始动作
	 */
	private function stopStart():void
	{
		if (this.startAni)
		{
			this.startAni.gotoAndStop(1);
			this.startAni.visible = false;
		}
	}
	
	//弹起结束
	private function bounceComplete():void 
	{
		this.isBounceComplete = true;
		this.isBounce = false;
	}

	/**
	 * 俯冲
	 */
	public function swoop(speed:Number):void
	{
		this.isHurt = false;
		this.swoopOnce = true;
		this.vy = speed;
	}
	
	/**
	 * 是否失败了
	 */
	public function get isFail():Boolean { return _isFail; }

	/**
	 * 是否允许加速俯冲
	 * @return
	 */
	public function canSwoop():Boolean
	{
		return !this.isOutTop && !this._isFail;
	}
}
}