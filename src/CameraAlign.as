package  
{
	import away3d.cameras.Camera3D;
	import away3d.core.base.Object3D;
	import flash.geom.Vector3D;
	/**
	 * Simple class for updating the camera position
	 * @author Rather Fanciful
	 */
	public class CameraAlign 
	{
		// Objec the camera is looking at
		public var target:Object3D;
		
		// Offset to position the camera from the target
		// If target is null, use offset from scene origin
		public var offset:Vector3D;
		
		// Camera to update
		public var camera:Camera3D;
		
		public function CameraAlign(cam:Camera3D = null) 
		{
			camera = cam;
			offset = new Vector3D();
			target = null;
		}
		
		public function update():void
		{
			if(camera && target) {
				camera.lookAt(target.position);
				var move:Vector3D = target.position.add(offset);
				camera.moveTo(move.x, move.y, move.z);
			}
			else {
				camera.moveTo(offset.x, offset.y, offset.z);
			}
		}
	}

}