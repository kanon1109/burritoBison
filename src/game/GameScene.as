package game 
{
import game.obj.GameBackGround;
import game.obj.Role;
import laya.events.Event;
import laya.ui.View;
/**
 * ...游戏场景层
 * @author Kanon
 */
public class GameScene extends View 
{
	private var role:Role;
	//地板坐标
	private var groundY:int;
	//顶部范围
	private var topY:int; 
	private var bg1Arr:Array;
	private var bg2Arr:Array;
	private var groundArr:Array;
	
	private var bg1PosY:Number;
	private var bg2PosY:Number;
	private var groundPosY:Number;
	
	private var speed:Number;
	private var jumpSpeed:Number;
	//是否飞入顶部区域
	private var isTop:Boolean;
	private	var bgCount:int;
	//横向摩擦力
	private var frictionX:Number;
	//纵向摩擦力
	private var frictionY:Number;
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
		this.size(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		this.bgCount = 3;
		this.timerLoop(1 / GameConstant.GAME_FRAME * 1000, this, gameLoop);
		this.bg1Arr = [];
		this.bg2Arr = [];
		this.groundArr = [];
		this.speed = 20;
		this.jumpSpeed = 30;
		this.topY = 200;
		this.bg1PosY = -GameConstant.BG1_HEIGHT / 2 + 5;
		this.bg2PosY = 20;
		this.groundPosY = Laya.stage.height - GameConstant.GROUND_HEIGHT;
		this.frictionX = .9;
		this.frictionY = .7;
		this.initTouch();
		this.initBg();
		this.initRole();
	}
	
	/**
	 * 初始化背景
	 */
	private function initBg():void 
	{
		//TODO 背景滚屏
		//TODO 异步处理背景高宽问题
		for (var i:int = 0; i < this.bgCount; i++) 
		{
			var bg:GameBackGround = new GameBackGround();
			bg.loadImage(GameConstant.GAME_RES_PATH + "bg1_1.png", 0, 0, GameConstant.BG1_WIDTH, GameConstant.BG1_HEIGHT);
			bg.x = GameConstant.BG1_WIDTH * i;
			bg.y = this.bg1PosY;
			bg.vx = -this.speed;
			bg.width = GameConstant.BG1_WIDTH;
			bg.height = GameConstant.BG1_HEIGHT;
			Layer.GAME_BACKGROUND_LAYER.addChild(bg);
			this.bg1Arr.push(bg);
		}
		
		for (i = 0; i < this.bgCount; i++) 
		{
			var bg:GameBackGround = new GameBackGround();
			bg.loadImage(GameConstant.GAME_RES_PATH + "bg1_2.png", 0, 0, GameConstant.BG2_WIDTH, GameConstant.BG2_HEIGHT);
			bg.x = GameConstant.BG2_WIDTH * i;
			bg.y = this.bg2PosY;
			bg.vx = -this.speed;
			bg.width = GameConstant.BG2_WIDTH;
			bg.height = GameConstant.BG2_HEIGHT;
			Layer.GAME_BACKGROUND_LAYER.addChild(bg);
			this.bg2Arr.push(bg);
		}
		
		for (i = 0; i < this.bgCount; i++) 
		{
			var ground:GameBackGround = new GameBackGround();
			ground.loadImage(GameConstant.GAME_RES_PATH + "ground1.png", 0, 0, GameConstant.GROUND_WIDTH, GameConstant.GROUND_HEIGHT);
			ground.x = GameConstant.GROUND_WIDTH * i;
			ground.y = this.groundPosY;
			ground.vx = -this.speed;
			ground.width = GameConstant.GROUND_WIDTH;
			ground.height = GameConstant.GROUND_HEIGHT;
			//定义地板高度
			this.groundY = ground.y + 20;
			Layer.GAME_BACKGROUND_LAYER.addChild(ground);
			this.groundArr.push(ground);
		}
		
		var length:int = this.bg1Arr.length;
		for (var i:int = 0; i < length; ++i) 
		{
			var go:GameBackGround = this.bg1Arr[i];
			if (i == 0) go.prevBg = this.bg1Arr[length - 1];
			else go.prevBg = this.bg1Arr[i - 1];
		}
		
		length = this.bg2Arr.length;
		for (i = 0; i < length; ++i) 
		{
			var go:GameBackGround = this.bg2Arr[i];
			if (i == 0) go.prevBg = this.bg2Arr[length - 1];
			else go.prevBg = this.bg2Arr[i - 1];
		}
		
		length = this.groundArr.length;
		for (i = 0; i < length; ++i) 
		{
			var go:GameBackGround = this.groundArr[i];
			if (i == 0) go.prevBg = this.groundArr[length - 1];
			else go.prevBg = this.groundArr[i - 1];
		}
	}
	
	/**
	 * 初始化点击
	 */
	private function initTouch():void
	{
		this.on(Event.CLICK, this, mouseClickHander);
	}
	
	private function mouseClickHander():void 
	{
		this.speed += 10;
		this.role.vy = this.jumpSpeed;
	}
	
	/**
	 * 初始化角色
	 */
	private function initRole():void
	{
		if (!this.role)
		{
			this.role = new Role();
			this.role.x = this.displayWidth / 2 - 200;
			this.role.y = this.displayHeight / 2;
			this.role.gravity = .98;
			this.role.vy = this.jumpSpeed;
			Layer.GAME_ROLE_LAYER.addChild(this.role);
		}
	}
	
	/**
	 * 更新地图
	 */
	private function updateBg():void
	{
		//背景活动
		for (var i:int = 0; i < this.bg1Arr.length; ++i) 
		{
			var go:GameBackGround = this.bg1Arr[i];
			go.vx = -this.speed;
			if (this.isTop) 
			{
				go.vy = this.role.vy;
			}
			else 
			{
				//if (go.y > this.bg1PosY)
					//go.vy = -this.role.vy;
			}
			go.update();
			trace(go.vy,  this.role.vy);

			go = this.bg2Arr[i];
			go.vx = -this.speed;
			if (this.isTop) 
			{
				go.vy = this.role.vy;
			}
			else 
			{
				/*if (go.y > this.bg2PosY)
					go.vy = -this.role.vy;*/
			}
			go.update();
			
			go = this.groundArr[i];
			if (this.isTop)
			{
				go.vy = this.role.vy;
			}
			else 
			{
				/*if (go.y > this.groundPosY)
					go.vy = -this.role.vy;*/
			}
			go.vx = -this.speed;
			go.update();
		}
		
		//限制活动范围
		for (i = 0; i < this.bg1Arr.length; ++i) 
		{
			var go:GameBackGround = this.bg1Arr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width;
			if (go.y < this.bg1PosY)
			{
				go.y = this.bg1PosY;
				go.vy = 0;
				trace("this.bg1PosY")
			}

			go = this.bg2Arr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width;
			if (go.y < this.bg2PosY) 
			{
				go.y = this.bg2PosY;
				go.vy = 0;
			}

			go = this.groundArr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width;
			if (go.y < this.groundPosY) 
			{
				go.y = this.groundPosY;
				go.vy = 0;
			}

		}
	}
	
	/**
	 * 更新角色
	 */
	private function updateRole():void
	{
		this.role.update();
		if (this.role.y > this.groundY)
		{
			this.role.y = this.groundY;
			this.speed *= this.frictionX;
			this.role.vy = -this.role.vy * this.frictionY;
			//速度过小停下
			if (this.role.vy > 0 && this.role.vy <= 1)
				this.role.vy = 0;
		}
		//是否超越顶部范围
		this.isTop = this.role.vy <= 0 && this.role.y < this.topY;
		if (this.isTop) this.role.y = this.topY;
		//速度过小停下
		if (Math.abs(this.speed) < 1) this.speed = 0;
	}
	
	/**
	 * 游戏主循环
	 */
	private function gameLoop():void 
	{
		//TODO
		//角色循环
		//背景循环
		//前景循环
		this.updateBg();
		this.updateRole();
	}

}
}