package items 
{
	import away3d.animators.SkeletonAnimationState;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Sword extends Item
	{
		public var init:Boolean;
		public function Sword(Args:Object) 
		{
			super(Args);
			
			// initialize model
			// initialize animation
			// initialize damage area
		}
		
		override public function activate():void 
		{
			// start animation
			// place damage in world
			// reset life on damage
			if(mesh.animator) {
				if(!init) {
					mesh.animator.animationSet.states[0].looping = false;
				}
				mesh.animator.play("Swing");
			}
		}
		
		override public function update():void 
		{
			super.update();
		}
	}

}