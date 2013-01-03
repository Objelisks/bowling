package  
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Player extends Thing
	{
		public var primary:Item;
		public var stored:Item;
		
		public function Player(Args:Object) 
		{
			super( { name:"player", x:Args.x, y:Args.y } );
			primary = null;
			stored = null;
			
			// add hud interface stuff
		}
		
		override public function update():void 
		{
			super.update();
			if(primary)
				primary.update();
		}
		
		public function useItem():void {
			if(!primary) return;
			primary.activate();
		}
		
		public function switchItem():void {
			var temp:Item = primary;
			primary = stored;
			stored = temp;
		}
		
		public function dropItem():void {
			if(!primary) return;
			(FlxG.state as GameState).area.addThing(primary);
			FlxG.view.scene.addChild(primary.mesh);
			primary = null;
		}
		
		public function addInventory(pickup:Item):void {
			trace("picked up item");
			if(primary) dropItem();
			primary = pickup;
			mesh.addChild(pickup.mesh);
			pickup.x -= x + width/2;
			pickup.y -= y + width/2;
			pickup.allowCollisions = 0;
		}
	}

}