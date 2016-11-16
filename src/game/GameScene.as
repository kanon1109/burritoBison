package game 
{
import game.obj.GameBackGround;
import game.obj.Role;
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.View;
/**
 * ...游戏场景层
 * TODO 云层
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
		this.initCloud();
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
		this.bg2PosY = 20;
		this.groundPosY = Laya.stage.height - GameConstant.GROUND_HEIGHT;
		
		this.cloud1PosY = this.bg1PosY - GameConstant.CLOUD1_HEIGHT - 500;
		this.cloud2PosY = this.bg1PosY - GameConstant.CLOUD2_HEIGHT - 300;
	}
	
	/**
	 * 初始化背景
	 */
	private function initBg():void 
	{
		//TODO 背景滚屏
		//TODO 异步处理背景高宽问题
		this.createBg("bg1_1.png", 
					GameConstant.BG1_WIDTH, 
					GameConstant.BG1_HEIGHT, 
					this.bgCount, this.bg1PosY, 
					Layer.GAME_BACKGROUND_LAYER, this.bg1Arr);
		
		this.createBg("bg1_2.png", 
					GameConstant.BG2_WIDTH, 
					GameConstant.BG2_HEIGHT, 
					this.bgCount, this.bg2PosY, 
					Layer.GAME_BACKGROUND_LAYER, this.bg2Arr);
					
		this.createBg("ground1.png", 
					GameConstant.GROUND_WIDTH, 
					GameConstant.GROUND_HEIGHT, 
					this.bgCount, this.groundPosY, 
					Layer.GAME_BACKGROUND_LAYER, this.groundArr);
					
		this.layoutBg(this.bg1Arr);
		this.layoutBg(this.bg2Arr);
		this.layoutBg(this.groundArr);
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
					Layer.GAME_BACKGROUND_LAYER, this.cloud1Arr);
		
		this.createBg("cloud2.png", 
					GameConstant.CLOUD2_WIDTH, 
					GameConstant.CLOUD2_HEIGHT, 
					this.bgCount, this.cloud2PosY, 
					Layer.GAME_BACKGROUND_LAYER, this.cloud2Arr);
					
		this.layoutBg(this.cloud1Arr);
		this.layoutBg(this.cloud2Arr);
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
	 */
	private function createBg(name:String, width:int, height:int, count:int, posY:Number, parent:Sprite, arr:Array):void
	{
		for (var i:int = 0; i < count; i++) 
		{
			var bg:GameBackGround = new GameBackGround();
			bg.loadImage(GameConstant.GAME_RES_PATH + name, 0, 0, width, height);
			bg.x = width * i;
			bg.y = posY;
			bg.width = width;
			bg.height = height;
			parent.addChild(bg);
			arr.push(bg);
		}
	}
	
	/**
	 * 展开平铺布局地图
	 * @param	arr		地图数据列表
	 */
	private function layoutBg(arr:Array):void
	{
		var length:int = arr.length;
		for (var i:int = 0; i < length; ++i) 
		{
			var go:GameBackGround = arr[i];
			if (i == 0) go.prevBg = arr[length - 1];
			else go.prevBg = arr[i - 1];
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
			this.role.speed = 60;
			this.role.jump(60);
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
			if (this.role.isOutTop) go.vy = vy;
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
			if (go.x < -go.width) go.x = go.prevBg.x + go.prevBg.width
			if (go.y < posY)
			{
				go.y = posY;
				go.vy = 0;
				this.role.isOutTop = false;
			}
		}
	}
	
	/**
	 * 更新所有背景图
	 */
	private function updateAllBg():void
	{
		this.updateBg(this.bg1Arr, -this.role.speed * .3, -this.role.vy * .9);
		this.updateBg(this.bg2Arr, -this.role.speed, -this.role.vy);
		this.updateBg(this.groundArr, -this.role.speed, -this.role.vy);
		this.updateBg(this.cloud1Arr, -this.role.speed * 1.5, -this.role.vy);
		this.updateBg(this.cloud2Arr, -this.role.speed * .15, -this.role.vy);
		
		//滚屏
		this.scrollBg(this.bg1Arr, this.bg1PosY);
		this.scrollBg(this.bg2Arr, this.bg2PosY);
		this.scrollBg(this.groundArr, this.groundPosY);
		this.scrollBg(this.cloud1Arr, this.cloud1PosY);
		this.scrollBg(this.cloud2Arr, this.cloud2PosY);
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
		this.updateAllBg();
		this.updateRole();
	}

}
}