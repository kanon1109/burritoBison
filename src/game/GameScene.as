package game 
{
import common.Shake;
import config.GameConstant;
import config.MsgConstant;
import game.obj.Boss;
import game.obj.Enemy;
import game.obj.GameBackGround;
import game.obj.PowerMete;
import game.obj.Role;
import laya.display.Sprite;
import laya.events.Event;
import laya.maths.MathUtil;
import laya.maths.Point;
import laya.ui.Image;
import laya.ui.View;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
import support.NotificationCenter;
import utils.Random;
/**
 * ...游戏场景层
 * TODO
 * [云层]
 * [限定最高高度]
 * [人物在最顶部自动进入云层后加速下落]
 * [根据下落速度调整震动大小]
 * [角色失败停下动作]
 * [角色起始动作]
 * [撞击boss]
 * 重置角色位置速度
 * 敌人出现移动删除
 * 人物动作变化
 * 地图高宽需要配置
 * bug
 * 敌人初始位置在角色顶部的时候发生错误
 * @author Kanon
 */
public class GameScene extends View 
{
	//角色
	private var role:Role;
	//存放背景数组
	private var bg1Arr:Array;
	private var bg2Arr:Array;
	private var groundArr:Array;
	//云数组
	private var cloud1Arr:Array;
	private var cloud2Arr:Array;
	//背景初始y坐标位置
	private var bg1PosY:Number;
	private var bg2PosY:Number;
	private var groundPosY:Number;
	private var roleGroundY:Number;
	//初始化云的位置
	private var cloud1PosY:Number;
	private var cloud2PosY:Number;
	//起始舞台图片
	private var startStageImg:Image;
	//滚屏背景图片的数量
	private	var bgCount:int;
	//背景滚动的范围
	private var bgMoveRangY:Number;
	//起始速度仪表
	private var powerMete:PowerMete;
	//是否开始
	private var canStart:Boolean;
	//boss
	private var boss:Boss;
	//敌人数组
	private var enemyArr:Array;
	public function GameScene() 
	{
		super();
		this.init();
	}

	/**
	 * 初始化游戏
	 */
	private function init():void
	{
		//TODO 
		//创建游戏角色
		//创建背景
		//创建前景
		//鼠标交互
		this.initData();
		this.initEvent();
		this.initBg();
		this.initCloud();
		this.initPowerMete();
		this.initBoss();
		this.initRole();
		trace("init");
		//this.createEnemy();
	}
	
	/**
	 * 初始化boss
	 */
	private function initBoss():void 
	{
		this.boss = new Boss();
		this.boss.init(1);
		this.boss.x = 700;
		this.boss.y = this.groundPosY - 78;
		Layer.GAME_ROLE_LAYER.addChild(this.boss);
	}
	
	private function initPowerMete():void 
	{
		if (!this.powerMete)
		{
			this.powerMete = new PowerMete();
			Layer.GAME_LAYER.addChild(this.powerMete);
			this.powerMete.x = this.startStageImg.x + 333;
		}
		this.powerMete.y = -300;
		Tween.to(this.powerMete, { y: -50}, 600, Ease.circOut, Handler.create(this, function() { 
			this.powerMete.start();
			this.canStart = true;
		} ) );
	}
	
	/**
	 * 初始化事件
	 */
	private function initEvent():void 
	{
		NotificationCenter.getInstance().addObserver(MsgConstant.ROLE_BOUNCE, roleBounceHandler, this);
		NotificationCenter.getInstance().addObserver(MsgConstant.ROLE_FAIL_RUN_COMPLETE, roleFailRunCompleteHandler, this);
		NotificationCenter.getInstance().addObserver(MsgConstant.ENEMY_DEAD_EFFECT_COMPLETE, enemyDeadEffectCompleteHandler, this);
		this.on(Event.MOUSE_DOWN, this, mouseDownHander);
		Laya.timer.loop(GameConstant.CREATE_ENEMY_DELAY, this, 
		function() {
			if (this.role && !this.role.isFail)
				this.createEnemy();
		}, null, false);
		
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this.size(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		this.bgCount = 3;
		this.timerLoop(1 / GameConstant.GAME_FRAME * 1000, this, gameLoop);
		this.bg1Arr = [];
		this.bg2Arr = [];
		this.groundArr = [];
		this.cloud1Arr = [];
		this.cloud2Arr = [];
		this.enemyArr = [];
		this.bg1PosY = -GameConstant.BG1_HEIGHT / 2 + 5;
		this.bg2PosY = 15;
		this.groundPosY = Laya.stage.height - GameConstant.GROUND_HEIGHT + 20;
		this.roleGroundY = this.groundPosY + 20;
		this.cloud1PosY = this.bg1PosY - GameConstant.CLOUD1_HEIGHT - 300;
		this.cloud2PosY = this.cloud1PosY + 430;
		this.bgMoveRangY =  -180 - this.cloud1PosY;
		this.canStart = false;
	}
	
	/**
	 * 初始化背景
	 */
	private function initBg():void 
	{		
		var bgColor:Sprite = new Sprite();
		bgColor.graphics.drawRect(0, 0, GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT, "#BFF5F2");
		Layer.GAME_BG_COLOR_LAYER.addChild(bgColor);
		
		//背景滚屏
		this.createBg("bg1_1.png", 
					GameConstant.BG1_WIDTH, 
					GameConstant.BG1_HEIGHT, 
					this.bgCount, this.bg1PosY, 
					Layer.GAME_BG_LAYER, this.bg1Arr);
		
		this.createBg("bg1_2.png", 
					GameConstant.BG2_WIDTH, 
					GameConstant.BG2_HEIGHT, 
					this.bgCount, this.bg2PosY, 
					Layer.GAME_BG_LAYER, this.bg2Arr);
					
		this.createBg("ground1.png", 
					GameConstant.GROUND_WIDTH, 
					GameConstant.GROUND_HEIGHT, 
					this.bgCount, this.groundPosY, 
					Layer.GAME_BG_LAYER, this.groundArr);
					
		this.startStageImg = new Image(GameConstant.GAME_BG_PATH + "startStage.png");
		this.startStageImg.x = 150;
		this.startStageImg.y = this.groundPosY - 136;
		Layer.GAME_FG_LAYER.addChild(this.startStageImg);
	}
	
	/**
	 * 初始化云
	 */
	private function initCloud():void 
	{
		this.createBg("cloud1.png", 
					GameConstant.CLOUD1_WIDTH, 
					GameConstant.CLOUD1_HEIGHT, 
					this.bgCount, this.cloud1PosY, 
					Layer.GAME_FG_LAYER, this.cloud1Arr);
					
		this.createBg("cloud2.png", 
					GameConstant.CLOUD2_WIDTH, 
					GameConstant.CLOUD2_HEIGHT, 
					this.bgCount, this.cloud2PosY, 
					Layer.GAME_BG_LAYER, this.cloud2Arr);
	}
	
	/**
	 * 创建一个背景层
	 * @param	name	名字
	 * @param	width	宽度
	 * @param	height	高度
	 * @param	count	数量
	 * @param	posY	初始y坐标
	 * @param	parent	父节点
	 * @param	arr		存放数组
	 * @param	scale	缩放
	 */
	private function createBg(name:String, width:int, height:int, count:int, posY:Number, parent:Sprite, arr:Array, scale:Number = 1):void
	{
		var bg:GameBackGround;
		for (var i:int = 0; i < count; i++) 
		{
			bg = new GameBackGround();
			bg.loadImage(GameConstant.GAME_BG_PATH + name, 0, 0, width, height);
			bg.x = width * i;
			bg.y = posY;
			bg.width = width;
			bg.height = height;
			bg.scale(scale, scale);
			parent.addChild(bg);
			arr.push(bg);
		}
		
		for (i = 0; i < count; ++i) 
		{
			bg = arr[i];
			if (i == 0) bg.prevBg = arr[count - 1];
			else bg.prevBg = arr[i - 1];
		}
	}
	
	private function mouseDownHander():void 
	{
		if (!this.canStart) return;
		if (this.role && this.role.canSwoop())
		{
			if (this.role.isStart)
			{
				this.role.swoop(this.role.swoopSpeed);
			}
			else
			{
				this.powerMete.stop();
				Tween.to(this.powerMete, { y: -300 }, 600, Ease.circOut, null, 800);
				if (this.powerMete.isMax())
				{
					//TODO 播放撞击boss动画
					this.role.bump();
					var startPosX:Number = this.role.x;
					Tween.to(this.role, {x: 620}, 600, Ease.linearNone, null);
					Tween.to(this.role, {y: this.role.y - 250}, 300, Ease.circOut, null);
					Tween.to(this.role, {y: this.role.y - 130}, 300, Ease.circIn, Handler.create(this, function(){
							this.role.startRush(true);
							this.boss.hurt();
							//返回原始位置
							Tween.to(this.role, {x: startPosX}, 200, Ease.linearNone, null);
					}), 300);
				}
				else
				{
					this.role.startRush(false);
				}
			}
		}
	}
	
	/**
	 * 初始化角色
	 */
	private function initRole():void
	{
		if (!this.role)
		{
			this.role = new Role();
			this.role.x = 250;
			this.role.y = this.displayHeight / 2 + 50;
			this.role.vx = 0;
			this.role.vy = 0;
			this.role.groundY = this.roleGroundY;
			Layer.GAME_ROLE_LAYER.addChild(this.role);
		}
	}
	
	/**
	 * 创建敌人
	 */
	private function createEnemy():void
	{
		var count:int = parseInt((this.role.vx / 2).toString());
		var num:int = Random.randint(count - 10, count);
		num = 1;
		var startX:Number = config.GameConstant.GAME_WIDTH + 50;
		for (var i:int = 0; i < num; i++) 
		{
			var enemy:Enemy = new Enemy();
			enemy.x = Random.randrange(startX, startX + 500, 10);
			enemy.y = this.roleGroundY + Random.randnum(0, 10);
			enemy.speedVx = Random.randnum(8, 15);
			enemy.create(1);
			this.enemyArr.push(enemy);
		}
		//深度排序
		this.enemyArr.sort(MathUtil.sortByKey("y"));
		for (var i:int = 0; i < this.enemyArr.length; i++) 
		{
			var enemy:Enemy = this.enemyArr[i];
			Layer.GAME_ENEMY_LAYER.addChild(enemy);
		}
	}
	
	/**
	 * 更新单个一层地图位置
	 * @param	arr		地图数组
	 * @param	vx		横向速度
	 * @param	vy		纵向速度
	 */
	private function updateBg(arr:Array, vx:Number, vy:Number):void
	{
		for (var i:int = 0; i < arr.length; ++i) 
		{
			var go:GameBackGround = arr[i];
			go.vx = vx;
			if (this.role.isOnTop) go.vy = vy;
			go.update();
		}
	}
	
	/**
	 * 单个一层背景滚动
	 * @param	arr		存放背景的数字
	 * @param	posY	地图起始位置
	 */
	private function scrollBg(arr:Array, posY:Number):void
	{
		for (var i:int = 0; i < arr.length; ++i) 
		{
			var go:GameBackGround = arr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width;
			if (go.y < posY)
			{
				go.y = posY;
				go.vy = 0;
				this.role.isOnTop = false;
			}
			if (go.y > posY + this.bgMoveRangY)
			{
				go.y = posY + this.bgMoveRangY;
				//吸入云层
				if (!this.role.isOutTop)
				{
					this.role.isOutTop = true;
					Tween.to(this.role, {y: -this.role.height}, 200, null, Handler.create(this, roleMoveTopComplete));
				}
			}
		}
	}
	
	private function roleMoveTopComplete():void
	{
		this.role.swoop(this.role.superSwoopSpeed);
	}
	
	/**
	 * 更新所有背景图
	 */
	private function updateAllBg():void
	{
		this.updateBg(this.bg1Arr, -this.role.vx * .3, -this.role.vy * .9);
		this.updateBg(this.bg2Arr, -this.role.vx, -this.role.vy);
		this.updateBg(this.groundArr, -this.role.vx, -this.role.vy);
		this.updateBg(this.cloud1Arr, -this.role.vx * 1.5, -this.role.vy);
		this.updateBg(this.cloud2Arr, -this.role.vx * .1, -this.role.vy);
		//滚屏
		this.scrollBg(this.bg1Arr, this.bg1PosY);
		this.scrollBg(this.bg2Arr, this.bg2PosY);
		this.scrollBg(this.groundArr, this.groundPosY);
		this.scrollBg(this.cloud1Arr, this.cloud1PosY);
		this.scrollBg(this.cloud2Arr, this.cloud2PosY);
		
		this.startStageImg.x -= this.role.vx;
		if (this.role.isOnTop) this.startStageImg.y -= this.role.vy;
	}
		
	//弹起
	private function roleBounceHandler():void 
	{
	}
	
	//角色跑了
	private function roleFailRunCompleteHandler():void 
	{
		//TODO 重置 
		//重玩
	}
	
	/**
	 * 更新角色
	 */
	private function updateRole():void
	{
		if (this.role)
			this.role.update();
			
		if (this.boss)
		{
			this.boss.vx = -this.role.vx;
			if (this.role.isOnTop) this.boss.vy = -this.role.vy;
			this.boss.update();
		}
	}
	
	/**
	 * 更新单个一层地图位置
	 * @param	arr		地图数组
	 * @param	vx		横向速度
	 * @param	vy		纵向速度
	 */
	private function updateEnemy():void
	{
		Layer.GAME_ENEMY_LAYER.y = this.groundArr[0].y - this.groundPosY;
		for (var i:int = 0; i < enemyArr.length; ++i) 
		{
			var e:Enemy = enemyArr[i];
			e.vx = e.speedVx - this.role.vx;
			if (this.role.isFail) e.vx = 20;
			//死亡效果时去除往前的速度
			if (e.isDead) e.vx = - this.role.vx;
			e.update();
			//role下落后 防止敌人向上越界
			//判断
			if (e.x < -200 || e.x > 1500)
			{
				enemyArr.splice(i, 1);
				e.removeSelf();
				continue;
			}
			
			var pos:Point = this.localToGlobal(new Point(e.x, e.y));
			var testImg:Image = new Image(GameConstant.GAME_RES_PATH + "test.png");
			e.parent.addChild(testImg);
			testImg.x = e.x;
			testImg.y = e.y - e.height;
			trace("e.x, e.x", e.x, e.y);
			trace(pos.x, pos.y);
			
			if (!this.role.isFail && 
				this.role.vy > 15 && 
				(this.role.y + this.role.height / 2) >= (e.y - e.height) && 
				Math.abs(e.x - this.role.x) < 20)
			{
				e.dead();
				if (this.role.vy < 20) this.role.vy = 20;
				this.role.bounce();
				continue;
			}
		}
	}
		
	private function enemyDeadEffectCompleteHandler(enemy:Enemy):void 
	{
		var length:int = enemyArr.length;
		for (var i:int = 0; i < length; ++i) 
		{
			var e:Enemy = enemyArr[i];
			if (e == enemy)
			{
				enemyArr.splice(i, 1);
				break;
			}
		}
		enemy.removeSelf();
	}
	
	/**
	 * 游戏主循环
	 */
	private function gameLoop():void 
	{
		//背景循环
		this.updateAllBg();
		//角色循环
		this.updateRole();
		//敌人循环
		this.updateEnemy();
		//震动
		Shake.update();
	}

}
}