package  
{
	import away3d.containers.Scene3D;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * Static class for storing actions done by triggers
	 * @author Rather Fanciful
	 */
	public class Actions 
	{
		public static const Exit:Function = function(params:Object, obj:FlxObject=null):void {
			// move to area params.exit
			var state:GameState = FlxG.state as GameState;
			FlxG.view.scene = new Scene3D();
			
			var newArea:Area = new Area(params.exit);
			newArea.addThing(state.player);
			state.player.x = params.x;
			state.player.y = params.y;
			state.area = newArea;
			
			// TODO: Lots (polish)
			// should add some transition effects here
			// clean up old area (save player)
			// fade out
			// fade in
		};
	}

}