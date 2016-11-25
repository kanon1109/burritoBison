package game 
{
import common.Shake;
import config.GameConstant;
import config.MsgConstant;
import game.obj.GameBackGround;
import game.obj.Role;
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;
import laya.ui.View;
import laya.utils.Handler;
import laya.utils.Tween;
import support.NotificationCenter;
/**
 * ...游戏场景层
 * TODO
 * [云层]
 * [限定最高高度]
 * [人物在最顶部自动进入云层后加速下落]
 * [根据下落速度调整震动大小]
 * [角色失败停下动作]
 * 角色起始动作
 * 重置角色位置速度
 * 敌人出现移动删除
 * 人物动作变化
 * 地图高宽需要配置
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
	//初始化云的位置
	private var cloud1PosY:Number;
	private var cloud2PosY:Number;
	//起始舞台图片
	private var startStageImg:Image;
	//滚屏背景图片的数量
	private	var bgCount:int;
	//背景滚动的范围
	private var bgMoveRangY:Number;
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
		this.initRole();
		this.initBg();
		this.initCloud();

	}
	
	/**
	 * 初始化事件
	 */
	private function initEvent():void 
	{
		NotificationCenter.getInstance().addObserver(MsgConstant.ROLE_BOUNCE, roleBounceHandler, this);
		NotificationCenter.getInstance().addObserver(MsgConstant.ROLE_FAIL_RUN_COMPLETE, roleFailRunCompleteHandler, this);
		this.on(Event.CLICK, this, mouseClickHander);
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
		this.bg1PosY = -GameConstant.BG1_HEIGHT / 2 + 5;
		this.bg2PosY = 15;
		this.groundPosY = Laya.stage.height - GameConstant.GROUND_HEIGHT + 20;
		
		this.cloud1PosY = this.bg1PosY - GameConstant.CLOUD1_HEIGHT - 300;
		this.cloud2PosY = this.cloud1PosY + 430;
		this.bgMoveRangY =  -180 - this.cloud1PosY;
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
					
		this.startStageImg = new Image(GameConstant.GAME_RES_PATH + "startStage.png");
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
			bg.loadImage(GameConstant.GAME_RES_PATH + name, 0, 0, width, height);
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
	
	private function mouseClickHander():void 
	{
		if (this.role && this.role.canSwoop())
		{
			if (this.role.isStart)
			{
				this.role.vx = 20;
				this.role.swoop(40);
			}
			else
			{
				this.role.isStart = true;
				this.role.vx = 50;
				this.role.vy = -40;
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
			this.role.groundY = this.groundPosY + 20;
			Layer.GAME_ROLE_LAYER.addChild(this.role);
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
		this.role.swoop(50);
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
		Shake.shake(Layer.GAME_BG_LAYER);
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
	}
	
	/**
	 * 游戏主循环
	 */
	private function gameLoop():void 
	{
		//背景循环
		//前景循环
		this.updateAllBg();
		//角色循环
		this.updateRole();
		//震动
		Shake.update();
	}

}
}