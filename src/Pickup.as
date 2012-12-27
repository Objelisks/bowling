package  
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxBasic;
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
		
		override public function overlaps(ObjectOrGroup:FlxBasic, InScreenSpace:Boolean = false, Camera:FlxCamera = null):Boolean 
		{
			var hit:Boolean = super.overlaps(ObjectOrGroup, InScreenSpace, Camera);
			if(hit) {
				
			}
			return hit;
		}
	}

}