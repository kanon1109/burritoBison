package game.obj 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Animation;
import laya.events.Event;
import laya.ui.Image;
import laya.utils.Handler;
import support.NotificationCenter;
/**
 * ...敌人
 * @author Kanon
 */
public class Enemy extends GameObject 
{
	private var run:Animation;
	private var deadEffect1:Animation;
	private var deadEffect2:Animation;
	private var _isDead:Boolean;
	public var speedVx:Number;
	public function Enemy() 
	{
		super();
		this.width = 60;
		this.height = 90;
		this.pivotX = this.width / 2;
		this.scaleX = -this.scaleX;

/*		var testImg:Image = new Image(GameConstant.GAME_RES_PATH + "test.png");
		this.addChild(testImg);
		testImg.x = -this.width / 2;
		
		testImg = new Image(GameConstant.GAME_RES_PATH + "test.png");
		this.addChild(testImg);
		testImg.rotation = 90;*/
	}
	
	/**
	 * 创建敌人
	 * @param	type	敌人类型
	 */
	public function create(type:int):void
	{
		this.run = this.createAni("enemy" + type + ".json");
		this.run.y = -this.height;
		this.run.play();
		this.addChild(this.run);
		
		this.deadEffect2 = this.createAni("dead2.json");
		this.deadEffect2.x = -100;
		this.deadEffect2.y = -28;
		this.deadEffect2.visible = false;
		this.addChild(this.deadEffect2);
		
		this.deadEffect1 = this.createAni("dead1.json");
		this.deadEffect1.x = -102;
		this.deadEffect1.y = -115;
		this.deadEffect1.visible = false;
		this.addChild(this.deadEffect1);
	}
	
	/**
	 * 创建动画
	 * @param	name	动画名
	 * @return
	 */
	private function createAni(name:String, loader:Handler = null):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_ATLAS_PATH + name, loader);
		ani.interval = 60;
		ani.stop();
		return ani;
	}
	
	/**
	 * 死亡
	 */
	public function dead():void
	{
		//TODO发送事件
		if (this._isDead) return;
		this.stopRun();
		if (this.deadEffect1)
		{
			this.deadEffect1.visible = true;
			this.deadEffect1.on(Event.COMPLETE, this, function(){
				NotificationCenter.getInstance().postNotification(MsgConstant.ENEMY_DEAD_EFFECT_COMPLETE, this);
			});
			this.deadEffect1.play(0, false);
		}
		if (this.deadEffect2)
		{
			this.deadEffect2.visible = true;
			this.deadEffect2.play(0, false);
		}
		this._isDead = true;
	}
	
	/**
	 * 停止跑步
	 */
	private function stopRun():void
	{
		if (this.run)
		{
			this.run.stop();
			this.run.visible = false;
		}
	}
	
	/**
	 * 是否死亡
	 */
	public function get isDead():Boolean {return _isDead; }
}
}