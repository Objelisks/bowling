package  
{
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.misc.AssetLoaderToken;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.SoftShadowMapMethod;
	import flash.filesystem.*;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Assetr 
	{
		// Directories (./src/../bin/*)
		public static const dataDir:String = "./data/";
		public static const areaDir:String = dataDir + "areas/";
		public static const thingDir:String = dataDir + "things/";
		public static const modelDir:String = "./models/";
		
		// full of geometries
		public static var models:Object = { };
		
		// Map of color name to 
		public static var materials:Object = getData(dataDir + "colors.json");
		
		// Light picker containing lights of current area
		public static var lightPicker:StaticLightPicker = new StaticLightPicker([]);
		
		// Read and parse a json file
		public static function getData(path:String) : Object {
			var file:File = File.applicationDirectory.resolvePath(path);
			trace("-loading " + file.url);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var filetext:String = stream.readUTFBytes(stream.bytesAvailable);
			return JSON.parse(filetext);
		}
		
		// Get a model and return a mesh that will eventually have the correct geometry in it.
		public static function getModel(name:String) : Mesh {
			var mesh:Mesh = new Mesh(null, null);
			mesh.name = name;
			mesh.visible = false;
			
			if(models[name] == null) {
				// start loading a model, store the token to allow multiple subscribers
				trace("-loading " + name);
				var url:URLRequest = new URLRequest(File.applicationDirectory.resolvePath(modelDir + name).url);
				var token:AssetLoaderToken = AssetLibrary.load(url);
				loadLater(token, mesh);
				models[name] = token;
			}
			else if(models[name] is Geometry) {
				// if the model is finished, take the stored model
				mesh.geometry = models[name];
				mesh.visible = true;
			}
			else if(models[name] is AssetLoaderToken) {
				// if the model was started before, but still isn't done yet, subscribe
				loadLater(models[name], mesh);
			}
			
			return mesh;
		}
		
		// Helper for loading models
		// When the model is done, it updates all the meshes with the correct geometry
		private static function loadLater(token:AssetLoaderToken, mesh:Mesh):void {
			token.addEventListener(AssetEvent.MESH_COMPLETE, function(event:AssetEvent):void {
				trace("-done loading " + mesh.name);
				event.asset.name = mesh.name; // set the asset name
				if(models[mesh.name] == null || !(models[mesh.name] is Geometry)) {
					models[mesh.name] = (event.asset as Mesh).geometry; // store the geometry for later
				}
				mesh.geometry = models[mesh.name]; // update the return geometry
				mesh.visible = true;
			});
		}
		
		// Get a color material
		// TODO: this needs to be expanded to allow multiple colors per model
		// TODO: tie materials to models
		public static function getMaterial(name:String) : MaterialBase {
			var color:uint = uint(materials[name]);
			var rgb:uint = color & 0xffffff;
			var alpha:Number = ((color >> 24) & 0xff) / 255.0;
			var material:ColorMaterial = new ColorMaterial(rgb, alpha);
			material.ambient = 0.9;
			material.ambientColor = rgb;
			material.specular = 0.0;
			material.smooth = false;
			
			// TODO: fix the shadows (see tiles)
			material.shadowMethod = new SoftShadowMapMethod(lightPicker.directionalLights[0]);
			material.lightPicker = lightPicker;
			
			return material;
		}
		
		// --Special Classes--
		// Okay so this is horrible, but we can't dynamically get a class name unless it is referenced
		// at least indirectly by the main class.
		private static var door:Door;
	}

}