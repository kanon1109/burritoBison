package 
{
import laya.display.Sprite;
/**
 * ...层级
 * @author Kanon
 */
public class Layer 
{
	public static var GAME_LAYER:Sprite;
	public static var GAME_ROLE_LAYER:Sprite;
	
	public static var GAME_BG_COLOR_LAYER:Sprite;
	public static var GAME_BG_LAYER:Sprite;
	public static var GAME_FG_LAYER:Sprite;
	public static var UI_LAYER:Sprite;
	public static var POP_LAYER:Sprite;
	public static function initLayer(parent:Sprite):void
	{
		GAME_LAYER = new Sprite();
		UI_LAYER = new Sprite();
		POP_LAYER = new Sprite();

		parent.addChild(GAME_LAYER);
		parent.addChild(UI_LAYER);
		parent.addChild(POP_LAYER);
		
		GAME_BG_COLOR_LAYER = new Sprite();
		GAME_BG_LAYER = new Sprite();
		GAME_ROLE_LAYER = new Sprite();
		GAME_FG_LAYER = new Sprite();
		
		GAME_LAYER.addChild(GAME_BG_COLOR_LAYER);
		GAME_LAYER.addChild(GAME_BG_LAYER);
		GAME_LAYER.addChild(GAME_ROLE_LAYER);
		GAME_LAYER.addChild(GAME_FG_LAYER);
	}
}
}