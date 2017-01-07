package game.obj 
{
/**
 * ...敌人
 * @author Kanon
 */
public class Enemy extends GameObject 
{
	public function Enemy() 
	{
		super();
	}
	
	/**
	 * 创建敌人
	 * @param	type	敌人类型
	 */
	public function create(type:int):void
	{
		
	}
	
	/**
	 * 死亡
	 */
	public function dead():void
	{
		//TODO发送事件
	}
}
}