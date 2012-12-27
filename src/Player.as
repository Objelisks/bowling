package  
{
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Player extends Thing
	{
		public var primary:Item;
		public var secondary:Item;
		public var inventory:Array;
		
		public function Player(Args:Object) 
		{
			super( { name:"player", x:Args.x, y:Args.y } );
			primary = null;
			secondary = null;
			inventory = new Array();
		}
		
		public function usePrimary():void {
			useItem(primary);
		}
		
		public function useSecondary():void {
			useItem(secondary);
		}
		
		private function useItem(item:Item):void {
			if(!item) return;
			item.activate();
		}
		
		public function addInventory(pickup:Pickup):void {
			trace("picked up item");
			inventory.push(pickup);
		}
	}

}