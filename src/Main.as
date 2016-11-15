package 
{
import game.GameConstant;
import game.GameScene;
import laya.display.Stage;
/**
 * ...主文件
 * @author Kanon
 */
public class Main 
{
	public function Main() 
	{
		Laya.init(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Layer.initLayer(Laya.stage);
		this.initGame();
	}
	
	
	private function initGame():void
	{
		var gameScene:GameScene = new GameScene();
		Layer.GAME_LAYER.addChild(gameScene);
	}
}
}