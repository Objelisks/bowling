package  
{
	import away3d.animators.data.Skeleton;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimationState;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
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
	import items.Sword;
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
		public static var anims:Object = { };
		
		// Map of color name to 
		public static var materials:Object = getData(dataDir + "colors.json");
		
		// Light picker containing lights of current area
		public static var lightPicker:StaticLightPicker = new StaticLightPicker([]);
		
		// Read and parse a json file
		public static function getData(path:String) : Object {
			var file:File = File.applicationDirectory.resolvePath(path);
			trace(">opening " + file.url);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var filetext:String = stream.readUTFBytes(stream.bytesAvailable);
			return JSON.parse(filetext);
		}
		
		// Get a model and return a mesh that will eventually have the correct geometry in it.
		public static function getModel(name:String, anims:Array=null) : Mesh {
			var mesh:Mesh = new Mesh(null, null);
			mesh.name = name;
			mesh.visible = false;
			
			if(models[name] == null) {
				// start loading a model, store the token to allow multiple subscribers
				trace(">opening " + name);
				var url:URLRequest = new URLRequest(File.applicationDirectory.resolvePath(modelDir + name).url);
				var token:AssetLoaderToken = AssetLibrary.load(url);
				loadMeshLater(token, mesh, anims);
				models[name] = token;
			}
			else if(models[name] is Mesh) {
				// if the model is finished, take the stored model
				mesh.geometry = models[name].geometry;
				mesh.visible = true;
			}
			else if(models[name] is AssetLoaderToken) {
				// if the model was started before, but still isn't done yet, subscribe
				loadMeshLater(models[name], mesh, anims);
			}
			
			return mesh;
		}
		
		// Helper for loading models
		// When the model is done, it updates all the meshes with the correct geometry
		private static function loadMeshLater(token:AssetLoaderToken, mesh:Mesh, anims:Array=null):void {
			var animationSet:SkeletonAnimationSet = null;
			var skeleton:Skeleton = null;
			trace("*("+mesh.name+") will load animation: " + (anims != null));
			if(anims) {
				token.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function():void {
					trace("::(" + mesh.name + ") as: " + animationSet + " sk: " + skeleton);
					mesh.animator = new SkeletonAnimator(animationSet, skeleton);
					trace("::(" + mesh.name + ") resource complete, loading animation");
					anims.forEach(function(anim:String, i:uint, a:Array):void {
						getAnim(mesh, anim);
					});
				});
			}
			
			token.addEventListener(AssetEvent.ASSET_COMPLETE, function(event:AssetEvent):void { 
				trace("--("+mesh.name+") " + event.asset.assetType + ": " + event.asset.name);
			});
			token.addEventListener(AssetEvent.SKELETON_COMPLETE, function(event:AssetEvent):void {
				trace("+(" + mesh.name + ") skeleton complete: " + event.asset);
				skeleton = Skeleton(event.asset);
			});
			token.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, function(event:AssetEvent):void {
				trace("+(" + mesh.name + ") animation set complete: " + event.asset);
				animationSet = SkeletonAnimationSet(event.asset);
			});
			token.addEventListener(AssetEvent.MESH_COMPLETE, function(event:AssetEvent):void {
				trace("<mesh complete: " + mesh.name);
				event.asset.name = mesh.name; // set the asset name
				if(models[mesh.name] == null || !(models[mesh.name] is Mesh)) {
					models[mesh.name] = (event.asset as Mesh); // store the geometry for later
				}
				mesh.geometry = models[mesh.name].geometry; // update the return geometry
				mesh.visible = true;
			});
		}
		
		public static function getAnim(mesh:Mesh, name:String) : void {
			if(anims[name] == null) {
				// start loading a model, store the token to allow multiple subscribers
				trace(">opening: " + name);
				var url:URLRequest = new URLRequest(File.applicationDirectory.resolvePath(modelDir + name).url);
				var token:AssetLoaderToken = AssetLibrary.load(url);
				loadAnimLater(token, mesh, name);
				anims[name] = token;
			}
			else if(anims[name] is SkeletonAnimationSet) {
				// if the model is finished, take the stored model
				mesh.animator = new SkeletonAnimator(anims[name], null);
			}
			else if(anims[name] is AssetLoaderToken) {
				// if the model was started before, but still isn't done yet, subscribe
				loadAnimLater(anims[name], mesh, name);
			}
		}
		
		// Helper for loading animations
		// When the animation is done, it updates all the animators with the correct animation set
		private static function loadAnimLater(token:AssetLoaderToken, mesh:Mesh, name:String):void {
			token.addEventListener(AssetEvent.ASSET_COMPLETE, function(event:AssetEvent):void { 
				trace("--(" + name + ") " + event.asset.assetType + ": " + event.asset.name);
			});
			token.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, function(event:AssetEvent):void {
				var animName:String = name.slice(0, name.length - 8);
				trace("+("+name+") adding animation state: " + animName);
				mesh.animator.animationSet.addState(animName, event.asset as SkeletonAnimationState); // update the return geometry
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
		private static var sword:Sword;
	}

}