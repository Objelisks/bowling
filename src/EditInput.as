package  
{
	import away3d.core.pick.PickingCollisionVO;
	import away3d.core.pick.RaycastPicker;
	import away3d.tools.utils.Ray;
	import org.flixel.FlxG;
	/**
	 * Input controls for when in edit mode
	 * @author Rather Fanciful
	 */
	public class EditInput extends Controller 
	{
		public function EditInput() 
		{
			super();
			FlxG.view.mousePicker = new RaycastPicker(false);
		}
		
		override public function update():void 
		{
			super.update();
			
			if(FlxG.mouse.justPressed()) {
				var collision:PickingCollisionVO = FlxG.view.mousePicker.getViewCollision(FlxG.mouse.x, FlxG.mouse.y, FlxG.view);
				if(collision) {
					trace(collision.entity.name);
				}
			}
		}
	}

}