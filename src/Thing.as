package  
{
	import away3d.animators.VertexAnimator;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.SegmentMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.tools.utils.Projector;
	import away3d.tools.utils.Ray;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Thing extends FlxObject
	{
		public var name : String;
		public var mesh : Mesh;
		public var id : String;
		public var debugCollision : WireframePlane;
		
		public function Thing(Args:Object) 
		{
			var data:Object = Assetr.getData(Assetr.thingDir + Args.name + ".json");
			
			// flixel
			super(Args.x?Args.x:0, Args.y?Args.y:0, Args.w?Args.w:(data.w?data.w:0), Args.h?Args.h:(data.h?data.h:0));
			name = data.name;
			
			// model
			if(data.model) {
				if(data.anims)
					mesh = Assetr.getModel(data.model, data.anims);
				else
					mesh = Assetr.getModel(data.model);
				if(data.material)
					mesh.material = Assetr.getMaterial(data.material);
			}
			
			// physics
			if(data.fixed)
				this.immovable = true;
			if(data.noclip)
				this.allowCollisions = 0;
			this.drag.make(500, 500);
			
			debugCollision = new WireframePlane(width, height, 1, 1, 0xADD8E6, 2, "xz");
			debugCollision.y = 50;
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function postUpdate():void 
		{
			super.postUpdate();
			//update model position, rotation
			mesh.x = x + width / 2;
			mesh.z = -(y + height / 2);
			debugCollision.x = x + width / 2;
			debugCollision.z = -(y + height / 2);
			//model.yaw();
			// state will update model.y for rendering later
		}
		
	}

}