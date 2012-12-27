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
		
		public function Player(Args:Object) 
		{
			super( { name:"player", x:Args.x, y:Args.y } );
			primary = null;
			secondary = null;
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
	}

}