package config 
{
/**
 * ...游戏常量
 * @author Kanon
 */
public class GameConstant 
{
	//游戏帧频
	public static const GAME_FRAME:int = 60;
	//游戏高宽
	public static const GAME_WIDTH:int = 1136;
	public static const GAME_HEIGHT:int = 640;
	//游戏资源地址
	public static const GAME_RES_PATH:String = "res/game/";
	public static const GAME_IMG_PATH:String = GameConstant.GAME_RES_PATH + "img/";
	public static const GAME_ANI_PATH:String = GameConstant.GAME_RES_PATH + "ani/";
	public static const GAME_ATLAS_PATH:String = GameConstant.GAME_ANI_PATH + "atlas/";
	public static const GAME_BONES_PATH:String = GameConstant.GAME_ANI_PATH + "bones/";
	public static const GAME_BG_PATH:String = GameConstant.GAME_IMG_PATH + "bg/";
	public static const GAME_ROLE_PATH:String = GameConstant.GAME_IMG_PATH + "role/";
	public static const GAME_BOSS_PATH:String = GameConstant.GAME_IMG_PATH + "boss/";
	//背景高宽
	public static const BG1_WIDTH:int = 1758;
	public static const BG1_HEIGHT:int = 636;
	//第二层背景高宽
	public static const BG2_WIDTH:int = 1747;
	public static const BG2_HEIGHT:int = 574;
	
	//地板高宽
	public static const GROUND_WIDTH:int = 1340;
	public static const GROUND_HEIGHT:int = 153;
	
	//云高宽
	public static const CLOUD1_WIDTH:int = 2487;
	public static const CLOUD1_HEIGHT:int = 887;
	
	public static const CLOUD2_WIDTH:int = 2131;
	public static const CLOUD2_HEIGHT:int = 590;
	
	//角色高宽
	public static const ROLE_WIDTH:int = 133;
	public static const ROLE_HEIGHT:int = 98;
	
	public static const BOSS1_WIDTH:int = 235;
	public static const BOSS1_HEIGHT:int = 167;
	
	//创建敌人的频率
	public static const CREATE_ENEMY_DELAY:int = 500;
}
}