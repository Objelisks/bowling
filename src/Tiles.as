package  
{
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import flash.geom.Vector3D;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Tiles extends FlxTilemap
	{
		[Embed(source="./org/flixel/data/autotiles_alt.png")]
		private static var autotiles:Class;
		public static const tileWidth:Number = 200;
		public static const tileHeight:Number = 200;
		private var models:Array;
		public var meshes:Array;
		public var material:MaterialBase;
		
		public function Tiles() 
		{
			super();
		}
		
		public function buildMap(MapData:String, Material:MaterialBase):void 
		{
			var style:String = "basic";
			//material = Assetr.getMaterial("sand");
			loadMap(MapData, autotiles, tileWidth, tileHeight, ALT, 0, 1, 1);
			_tileObjects.forEach(function(tileObj:FlxTile, i:uint, a:Array):void {
				if(tileObj.index == 0)
					tileObj.allowCollisions = FlxObject.ANY;
				else
					tileObj.allowCollisions = FlxObject.NONE;
			});
			trace(_tileObjects.length);
			for(var type:uint = 1; type < 16; type++) {
				var coords:Array = getTileCoords(type, true);
				if(coords == null || coords.length == 0) 
					continue;
				coords.forEach(function(pt:FlxPoint, index:uint, array:Array):void {
					var mesh:Mesh = Assetr.getModel("tiles/"+style+"_"+(type-1)+".obj");
					mesh.x = pt.x;
					mesh.y = tileWidth/2;
					mesh.z = -pt.y;
					mesh.scale(tileWidth/100);
					mesh.material = Assetr.getMaterial("sand");
					FlxG.view.scene.addChild(mesh);
				});
			}
		}
	}

}