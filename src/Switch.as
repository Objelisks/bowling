package  
{
	import org.flixel.FlxRect;
	/**
	 * Switches that can be activated by things
	 * Switches trigger actions in other objects
	 * @author Rather Fanciful
	 */
	public class Switch extends Thing
	{
		// Switch types
		public static const FLOOR:uint = 0;
		private static const FLR_TRIGGERED:Array = [
		"box"];
		public static const TARGET:uint = 1;
		private static const TGT_TRIGGERED:Array = [
		];
		
		private static const FLR_WIDTH:Number = 100;
		private static const FLR_HEIGHT:Number = 100;
		
		// Whether the switch is currently activated
		public var active:Boolean;
		
		// Area that needs a thing in it to activate this switch (offset)
		public var trigger:Trigger;
		
		// Type of switch (see constants)
		public var type:uint;
		
		public function Switch(Args:Object) 
		{
			type = Args.type;
			
			var model:String;
			if(type == FLOOR) {
				model = "floorswitch";
				// TODO center trigger
				trigger = new Trigger(Args.x, Args.y, FLR_WIDTH, FLR_HEIGHT);
			} else {
				model = "wallswitch";
				trigger = new Trigger(Args.x, Args.y, FLR_WIDTH, FLR_HEIGHT);
			}
			
			super(model, Args.x, Args.y);
		}
		
	}

}