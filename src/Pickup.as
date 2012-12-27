package  
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxBasic;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Pickup extends Thing
	{
		
		public function Pickup(Args:Object) 
		{
			super(Args);
		}
		
		public function hit(obj:FlxObject):Boolean {
			if(obj is Player) {
				var player:Player = obj as Player;
				player.addInventory(this);
				this.kill();
				return false;
			}
			return true;
		}
	}

}