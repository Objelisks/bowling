package  
{
	import org.flixel.FlxCamera;
	import away3d.primitives.WireframePlane;
	import org.flixel.FlxBasic;
	import org.flixel.FlxObject;
	/**
	 * Responds to things happening in gamestate by doing other things
	 * See Actions file
	 * @author Rather Fanciful
	 */
	public class Trigger extends Thing
	{
		public var action:Function;
		public var params:Object;
		
		public var ids:Object;
		
		public var onEnter:Array;
		public var onStay:Array;
		public var onLeave:Array;
		
		private var collisionsLastFrame:Array;
		private var collisionsThisFrame:Array;
		
		public function Trigger(Args:Object) 
		{
			name = Args.name;
			action = null;
			
			ids = { };
			
			onEnter = Args.onEnter ? Args.onEnter : new Array();
			onStay = Args.onStay ? Args.onStay : new Array();
			onLeave = Args.onLeave ? Args.onLeave : new Array();
			collisionsLastFrame = new Array();
			collisionsThisFrame = new Array();
			
			super(Args);
			
			immovable = true;
			moves = false;
			visible = false;
			
			debugCollision = new WireframePlane(width, height, 1, 1, 0xFF8C00, 2, "xz");
			debugCollision.x = x + width/2;
			debugCollision.z = -y + height/2;
			debugCollision.y = 50;
		}
		
		// This gets called for any collisions
		public function hit(obj:FlxObject):Boolean {
			// TODO: Make this a hashmap (faster)
			if(collisionsThisFrame.indexOf(obj) < 0) {
				collisionsThisFrame.push(obj);
			}
			
			return false;
		}
		
		// Process messages based on what collisions happened
		override public function postUpdate():void {
			super.postUpdate();
			
			// send messages
			if(onEnter.length > 0) {
				var enterObjs:Array = collisionsThisFrame.filter(Trigger.isNotIn(collisionsLastFrame), collisionsThisFrame);
				if(enterObjs.length > 0) {
					onEnter.forEach(sendMsg("onEnter", enterObjs));
				}
			}
			
			if(onStay.length > 0) {
				var stayObjs:Array = collisionsThisFrame.filter(Trigger.isIn(collisionsLastFrame), collisionsThisFrame);
				if(stayObjs.length > 0) {
					onStay.forEach(sendMsg("onStay", stayObjs));
				}
			}
			
			if(onLeave.length > 0) {
				var leaveObjs:Array = collisionsLastFrame.filter(Trigger.isNotIn(collisionsThisFrame), collisionsLastFrame);
				if(leaveObjs.length > 0) {
					onLeave.forEach(sendMsg("onLeave", leaveObjs));
				}
			}
			
			collisionsLastFrame = collisionsThisFrame;
			collisionsThisFrame = new Array();
		}
		
		private function sendMsg(msg:String, objs:Array):Function {
			return function(id:String, i:uint, a:Array):void {
				var receiver:* = ids[id];
				receiver.handle(msg, objs);
			};
		}
		
		private static function isIn(array:Array):Function {
			return function(item:*, i:uint, a:Array):Boolean {
				return array.indexOf(item) >= 0;
			};
		}
		
		private static function isNotIn(array:Array):Function {
			return function(item:*, i:uint, a:Array):Boolean {
				return array.indexOf(item) < 0;
			};
		}
	}

}