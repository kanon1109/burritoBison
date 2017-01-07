package game.obj 
{
import config.GameConstant;
import laya.ani.bone.Skeleton;
import laya.ani.bone.Templet;
import laya.d3.core.Layer;
import laya.events.Event;
import laya.ui.Image;
/**
 * ...
 * @author Kanon
 */
public class Boss extends GameObject 
{
	//boss动画
	private var bossAni:Skeleton;
	private var bossHurt:Image;
	public function Boss() 
	{
		super();
	}
	
	/**
	 * 初始化boss
	 * @param	index	boss索引
	 */
	public function init(index:int):void
	{
		var boss:Templet = new Templet();
		boss.on(Event.COMPLETE, this, function(fac:Templet)
		{
			this.bossAni = fac.buildArmature(0);
			this.bossAni.play(0, true);
			this.addChild(this.bossAni);
		});
		boss.on(Event.ERROR, this, function(e:*) {
			trace("load fail");
		});
		boss.loadAni(GameConstant.GAME_BONES_PATH + "boss" + index + "Ani.sk");
		this.bossHurt = new Image(GameConstant.GAME_BOSS_PATH + "boss" + index + "Hurt.png");
		this.bossHurt.pivotX = GameConstant.BOSS1_WIDTH / 2;
		this.bossHurt.pivotY = GameConstant.BOSS1_HEIGHT;
		this.bossHurt.x = 45;
		this.bossHurt.y = -5;
		this.bossHurt.visible = false;
		this.addChild(this.bossHurt);
	}
	
	/**
	 * 受伤
	 */
	public function hurt():void 
	{
		if (this.bossAni)
		{
			this.bossAni.stop();
			this.bossAni.visible = false;
		}
		if (this.bossHurt)
			this.bossHurt.visible = true;
	}
}
}