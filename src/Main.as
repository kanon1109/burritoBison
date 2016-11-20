package 
{
import config.GameConstant;
import game.GameScene;
import laya.display.Stage;
import laya.utils.Stat;
/**
 * ...主文件
 * @author Kanon
 */
public class Main 
{
	public function Main() 
	{
		Laya.init(config.GameConstant.GAME_WIDTH, config.GameConstant.GAME_HEIGHT);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Layer.initLayer(Laya.stage);
		Stat.show(0, 0);
		this.initGame();
	}
	
	
	private function initGame():void
	{
		var gameScene:GameScene = new GameScene();
		Layer.GAME_LAYER.addChild(gameScene);
	}
}
}