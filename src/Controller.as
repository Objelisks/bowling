package  
{
	import org.flixel.FlxBasic;
	/**
	 * Basic controller for input and such things
	 * @author Rather Fanciful
	 */
	public class Controller extends FlxBasic
	{
		public function Controller() 
		{
			active = true;
			
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		public function enable():void {
			active = true;
		}
		
		public function disable():void {
			active = false;
		}
		
	}

}