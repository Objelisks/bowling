package  
{
	import flash.utils.getTimer;
	import org.flixel.*;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class PlayerInput extends Controller
	{
		public var movespeed:Number = 300;
		public var target:Player;
		
		public function PlayerInput(player:Player) 
		{
			super();
			target = player;
			player.drag.make(movespeed * 4, movespeed * 4);
			player.maxVelocity.make(movespeed, movespeed);
		}
		
		override public function update():void 
		{
			super.update();
			var joystick:FlxPoint = new FlxPoint();
			
			if(FlxG.keys.pressed("LEFT")) {
				joystick.x -= 1;
			}
			if(FlxG.keys.pressed("RIGHT")) {
				joystick.x += 1;
			}
			if(FlxG.keys.pressed("UP")) {
				joystick.y -= 1;
			}
			if(FlxG.keys.pressed("DOWN")) {
				joystick.y += 1;
			}
			
			// attack
			if(FlxG.keys.justPressed("X")) {
				// interact
				// context
			}
			
			// item use
			if(FlxG.keys.justPressed("C")) {
				target.useItem();
			}
			
			if(FlxG.keys.justPressed("S")) {
				target.switchItem();
			}
			
			if(FlxG.keys.justPressed("D")) {
				target.dropItem();
			}
			
			var norm:Number = FlxU.norm(joystick);
			target.acceleration.make(0, 0);
			if(norm != 0) {
				target.acceleration.x += joystick.x / norm * target.drag.x;
				target.acceleration.y += joystick.y / norm * target.drag.y;
			}
			target.mesh.y = Math.sin(getTimer()/500)*10+50;
		}
		
	}

}