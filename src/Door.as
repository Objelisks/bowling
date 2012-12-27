package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Door extends Thing
	{
		public var maxHeight:Number;
		
		public function Door(Args:Object) 
		{
			super(Args);
			maxHeight = 200;
			immovable = true;
		}
		
		public function handle(msg:String, objs:Array):void {
			if(msg == "onStay") {
				if(objs.some(function(thing:*, i:uint, a:Array):Boolean {
					return thing.name == "Box";
				})) {
					if(this.mesh.y < maxHeight) {
						this.mesh.y += 100 * FlxG.elapsed;
						if(this.mesh.y > maxHeight) {
							this.allowCollisions = 0;
							this.mesh.y = maxHeight;
						}
					}
				}
				else
				{
					if(this.mesh.y > 0) {
						this.mesh.y -= 1000 * FlxG.elapsed;
						this.allowCollisions = FlxObject.ANY;
						if(this.mesh.y < 0)
							this.mesh.y = 0;
					}
				}
			}
		}
	}

}