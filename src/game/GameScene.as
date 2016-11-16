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
	//角色
	private var role:Role;

	//存放背景数组
	private var bg1Arr:Array;
	private var bg2Arr:Array;
	private var groundArr:Array;
	//背景初始y坐标位置
	private var bg1PosY:Number;
	private var bg2PosY:Number;
	private var groundPosY:Number;

	//滚屏背景图片的数量
	private	var bgCount:int;

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
		this.initTouch();
		this.initRole();
		this.initBg();
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
		
		this.bg1PosY = -GameConstant.BG1_HEIGHT / 2 + 5;
		this.bg2PosY = 20;
		this.groundPosY = Laya.stage.height - GameConstant.GROUND_HEIGHT;
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
			bg.vx = -this.role.speed;
			bg.width = GameConstant.BG1_WIDTH;
			bg.height = GameConstant.BG1_HEIGHT;
			Layer.GAME_BACKGROUND_LAYER.addChild(bg);
			this.bg1Arr.push(bg);
		}
		
		for (i = 0; i < this.bgCount; i++) 
		{
			bg = new GameBackGround();
			bg.loadImage(GameConstant.GAME_RES_PATH + "bg1_2.png", 0, 0, GameConstant.BG2_WIDTH, GameConstant.BG2_HEIGHT);
			bg.x = GameConstant.BG2_WIDTH * i;
			bg.y = this.bg2PosY;
			bg.vx = -this.role.speed;
			bg.width = GameConstant.BG2_WIDTH;
			bg.height = GameConstant.BG2_HEIGHT;
			Layer.GAME_BACKGROUND_LAYER.addChild(bg);
			this.bg2Arr.push(bg);
		}
		
		for (i = 0; i < this.bgCount; i++) 
		{
			var ground:GameBackGround = new GameBackGround();
			ground.loadImage(GameConstant.GAME_RES_PATH + "ground1.png", 0, 0, GameConstant.GROUND_WIDTH, GameConstant.GROUND_HEIGHT);
			ground.x = (GameConstant.GROUND_WIDTH - 2) * i;
			ground.y = this.groundPosY;
			ground.vx = -this.role.speed;
			ground.width = GameConstant.GROUND_WIDTH;
			ground.height = GameConstant.GROUND_HEIGHT;
			//定义地板高度
			this.role.groundY = ground.y + 20;
			Layer.GAME_BACKGROUND_LAYER.addChild(ground);
			this.groundArr.push(ground);
		}
		
		var go:GameBackGround;
		var length:int = this.bg1Arr.length;
		for (i = 0; i < length; ++i) 
		{
			go = this.bg1Arr[i];
			if (i == 0) go.prevBg = this.bg1Arr[length - 1];
			else go.prevBg = this.bg1Arr[i - 1];
		}
		
		length = this.bg2Arr.length;
		for (i = 0; i < length; ++i) 
		{
			go = this.bg2Arr[i];
			if (i == 0) go.prevBg = this.bg2Arr[length - 1];
			else go.prevBg = this.bg2Arr[i - 1];
		}
		
		length = this.groundArr.length;
		for (i = 0; i < length; ++i) 
		{
			go = this.groundArr[i];
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
		if (this.role)
		{
			this.role.speed = 20;
			this.role.jump();
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
			this.role.x = this.displayWidth / 2 - 200;
			this.role.y = this.displayHeight / 2;
			this.role.vx = 0;
			this.role.vy = 0;
			Layer.GAME_ROLE_LAYER.addChild(this.role);
		}
	}
	
	/**
	 * 更新地图
	 */
	private function updateBg():void
	{
		var go:GameBackGround;
		//背景活动
		for (var i:int = 0; i < this.bg1Arr.length; ++i) 
		{
			go = this.bg1Arr[i];
			go.vx = -this.role.speed;
			if (this.role.isOutTop) go.vy = -this.role.vy * .9;
			go.update();

			go = this.bg2Arr[i];
			go.vx = -this.role.speed;
			if (this.role.isOutTop) go.vy = -this.role.vy;
			go.update();
			
			go = this.groundArr[i];
			if (this.role.isOutTop) go.vy = -this.role.vy;
			
			go.vx = -this.role.speed;
			go.update();
		}
		
		//滚屏
		for (i = 0; i < this.bg1Arr.length; ++i) 
		{
			go = this.bg1Arr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width
			if (go.y < this.bg1PosY)
			{
				go.y = this.bg1PosY;
				go.vy = 0;
			}

			go = this.bg2Arr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width;
			if (go.y < this.bg2PosY) 
			{
				go.y = this.bg2PosY;
				go.vy = 0;
			}

			go = this.groundArr[i];
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width - 2;
			if (go.y < this.groundPosY) 
			{
				go.y = this.groundPosY;
				go.vy = 0;
				this.role.isOutTop = false;
			}
		}
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
		//TODO
		//角色循环
		//背景循环
		//前景循环
		this.updateBg();
		this.updateRole();
	}

}
}