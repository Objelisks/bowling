package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Item extends Thing
	{
		
		public function Item(Args:Object) 
		{
			super(Args);
		}
		
		public function activate():void {
			// create collision
			// animate item
		}
		
		public function hit(obj:FlxObject):Boolean {
			if(obj is Player) {
				var player:Player = obj as Player;
				player.addInventory(this);
				player.primary = this;
				return false;
			}
			return true;
		}
	}

}