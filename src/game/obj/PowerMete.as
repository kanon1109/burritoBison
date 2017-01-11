package game.obj 
{
import config.GameConstant;
import laya.display.Animation;
import laya.display.Sprite;
import laya.ui.Image;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ...功率计
 * @author Kanon
 */
public class PowerMete extends Sprite 
{
	private var ani1:Animation;
	private var pointer:Image;
	private var angleSpeed:Number = 10;
	private var angleEase:Number = .15;
	private var type:uint = 1;
	private var targetRotation:int = 180;
	private var tw1:Tween;
	private var tw2:Tween;
	public function PowerMete() 
	{
		this.initUI(type);
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI(type:int):void
	{
		switch (type) 
		{
			case 1:
				//底板
				var image:Image = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_1.png");
				this.addChild(image);
				
				//颜色板
				image = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_7.png");
				image.x = 14;
				image.y = 148;
				this.addChild(image);
				
				this.ani1 = new Animation();
				this.ani1.loadAtlas(config.GameConstant.GAME_ATLAS_PATH + "powerMeteAni1.json");
				this.ani1.x = image.x;
				this.ani1.y = image.y;
				this.ani1.interval = 60;
				this.ani1.visible = false;
				this.addChild(this.ani1);
				
				//头像地板
				image = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_4.png");
				image.x = 63;
				image.y = 148;
				this.addChild(image);
				
				//指针
				this.pointer = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_3.png");
				this.pointer.x = 89;
				this.pointer.y = 152;
				this.pointer.pivotX = 7.75;
				this.pointer.pivotY = 7.25;
				this.pointer.rotation = 0;
				this.addChild(this.pointer);
				
				//头像
				image = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_2.png");
				image.x = 69;
				image.y = 134;

				this.addChild(image);
				
				image = new Image(GameConstant.GAME_BG_PATH + "PowerMete1_6.png");
				image.x = 83;
				image.y = 211;
				this.addChild(image);
			break;
		}
	}
	
	/**
	 * 开始
	 */
	public function start():void
	{
		this.tw1 = Tween.to(this.pointer, { rotation:180 }, 400, Ease.linearOut, Handler.create(this, function() {
			this.tw2 = Tween.to(this.pointer, { rotation:0 }, 400, Ease.linearOut, Handler.create(this, function() {
				start();
			}));
		}));
	}
	
	/**
	 * 暂停
	 */
	public function stop():void
	{
		if (this.tw1) Tween.clear(this.tw1);
		if (this.tw2) Tween.clear(this.tw2);
		if (this.isMax())
		{
			this.pointer.rotation = 90;
			this.ani1.play();
			this.ani1.visible = true;
		}
	}
	
	/**
	 * 是否是最大值
	 * @return
	 */
	public function isMax():Boolean
	{
		return this.pointer.rotation >= 80 && this.pointer.rotation <= 100;
	}
}
}