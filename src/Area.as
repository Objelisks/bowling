package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import org.flixel.*;
	
	/**
	 * Areas hold the level structure and are manipulated by the game state
	 * Areas have:
		 * Lights
		 * Tiles
		 * Things
		 * Triggers
	 * Things and triggers and tiles are part of the area flxgroup
	 * @author Rather Fanciful
	 */
	public class Area extends FlxGroup
	{
		// Name of the area
		public var name:String;
		
		// All the moving and visible things
		public var things:FlxGroup;
		
		// All the lights in the current area (should be the same as the light picker in Assetr)
		public var lights:Array;
		
		// All the triggers (invisible)
		public var triggers:FlxGroup;
		
		// The tiles that make up the area collision
		public var tiles:Tiles;
		
		// Whether the area has finished loading and is ready to be displayed and updated
		public var loaded:Boolean;
		
		// Directory of objects that have ids (triggers or things)
		public var idObjs:Object;
		
		public function Area(Name:String) 
		{
			super();
			var data:Object = Assetr.getData(Assetr.areaDir + Name + ".json");
			
			idObjs = new Array();
			
			// Parse terrain data
			name = data.name;
			
			// LET THERE BE LIGHT
			this.lights = new Array();
			if(data.lights) {
				for each(var li:Object in data.lights) {
					buildLight(li);
				}
			}
			Assetr.lightPicker.lights = this.lights;
			
			// Build the tilemap
			this.tiles = new Tiles();
			if(data.tiles) {
				buildTiles(data);
			}
			
			// Initialize triggers
			this.triggers = new FlxGroup();
			if(data.triggers) {
				for each(var trig:Object in data.triggers) {
					buildTrigger(trig);
				}
			}
			
			// Initialize things with models
			this.things = new FlxGroup();
			if(data.things) {
				for each(var obj:Object in data.things) {
					buildObject(obj);
				}
			}
			
			// Add flixel objects to the area flxgroup
			this.add(things);
			this.add(triggers);
			this.add(tiles);
			this.loaded = true;
		}
		
		// Adding a thing requires adding the meshes to the scene and adding to the flxgroup
		public function addThing(thing:Thing):FlxBasic 
		{
			if(thing.mesh)
				FlxG.view.scene.addChild(thing.mesh);
			if(thing.debugCollision)
				FlxG.view.scene.addChild(thing.debugCollision);
			return this.things.add(thing);
		}
		
		// Set up the tiles
		private function buildTiles(data:Object):void {
			trace("-building tiles:");
			this.tiles.buildMap(data.tiles.join("\n"), Assetr.getMaterial("sand"));
			trace("--tiles: w: "+ tiles.widthInTiles +" h: "+ tiles.heightInTiles +" c:"+ tiles.totalTiles);
		}
		
		// Set up the thing (may require special stuff)
		// TODO: move everything over to args params
		private function buildObject(data:Object):void {
			var thing:*;
			var type:Class;
			if(data.special) {
				type = getDefinitionByName(data.special) as Class;
			} else {
				type = Thing;
			}
			if(data.args) 
				thing = new type(data);
			else
				thing = new type(data);
			if(data.props) {
				for (var prop:String in data.props) {
					thing[prop] = data.props[prop];
				}
			}
			
			this.things.add(thing);
			if(thing.mesh)
				FlxG.view.scene.addChild(thing.mesh);
			//if(thing.debugCollision)
				//FlxG.view.scene.addChild(thing.debugCollision);
				
			if(data.id) {
				trace("--object with id: " + data.id);
				this.idObjs[data.id] = thing;
			}
		}
		
		// Set up the lights
		private function buildLight(data:Object):void {
			if(data.type == "direct") {
				var light:DirectionalLight = new DirectionalLight(data.x, data.y, data.z);
				light.ambient = data.strength;
				light.castsShadows = true;
				light.shadowMapper = new DirectionalShadowMapper();
				FlxG.view.scene.addChild(light);
				this.lights.push(light);
				
				if(data.id)
					this.idObjs[data.id] = light;
			}
		}
		
		// Set up the triggers
		private function buildTrigger(data:Object):void {
			var trigger:Trigger = new Trigger(data);
			trigger.ids = this.idObjs;
			this.triggers.add(trigger);
			FlxG.view.scene.addChild(trigger.debugCollision);
			
			if(data.id)
				this.idObjs[data.id] = trigger;
		}
	}

}
