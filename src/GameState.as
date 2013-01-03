package  
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.filters.DepthOfFieldFilter3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.materials.lightpickers.StaticLightPicker;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.flixel.*;
	
	/**
	 * This state controls stuff that happens during active gameplay
	 * Mostly takes data from area and handles colliding it and any interactions that result from collisions
	 * Also does a little bit of 3d scene / flixel setup
	 * @author Rather Fanciful
	 */
	public class GameState extends FlxState
	{
		// Group of controllers for updating
		public var controllers:FlxGroup;
		
		public var playerInput:PlayerInput;
		public var editInput:EditInput;
		
		// Current active area
		public var area:Area;
		
		// 3d view for drawing
		public var view:View3D;
		
		// Camera tools
		public var cameraAlign:CameraAlign;
		
		// Player object (TODO: needed?)
		public var player:Player;
		
		// Whether in edit mode or not
		// Should this be a separate state, or just separate input?
		public var editMode:Boolean;
		
		override public function create():void 
		{
			super.create();
			
			FlxG.worldBounds = new FlxRect( -10000, -10000, 20000, 20000);
			
			// View will automatically size itself I think
			view = new View3D();
			FlxG.view = view;
			FlxG.stage.addChild(view);
			view.scene = new Scene3D();
			
			controllers = new FlxGroup();
			editInput = new EditInput();
			controllers.add(editInput);
			
			initCamera();
			
			initWorld();
			
			initPlayer();
			
			// shiny
			var filter:DepthOfFieldFilter3D = new DepthOfFieldFilter3D();
			filter.focusTarget = player.mesh;
			view.filters3d = [filter];
			
			// new game
		}
		
		override public function update():void 
		{
			super.update();
			
			if(FlxG.keys.justPressed("TAB")) {
				// switch to editmode
				if(editMode) {
					editInput.active = true;
					playerInput.active = false;
				} else {
					editInput.active = false;
					playerInput.active = true;
				}
				editMode = !editMode;
			}
			
			controllers.update();
			
			area.preUpdate();
			
			// collide stuff
			//FlxG.collide(area.things, area.things);
			//FlxG.overlap(area.triggers, area.things, triggerOverlap);
			//if(area.loaded)
			//	FlxG.collide(area.things, area.tiles);
			
			// risqué
			FlxG.overlap(area.things, null, FlxObject.separate, overlapper);
			
			area.update();
			
			area.postUpdate();
			
			cameraAlign.update();
		}
		
		override public function draw():void 
		{
			// Scale set to zero bug
			// caused by mesh coordinates set to NaN
			view.render();
		}
		
		// Does class specific collision stuff
		// Returns whether to separate objects
		// this function is as an octopus
		private function overlapper(obj1:FlxObject, obj2:FlxObject):Boolean {
			if(obj1 is Trigger) {
				return (obj1 as Trigger).hit(obj2);
			} else if(obj1 is Item) {
				return (obj1 as Item).hit(obj2);
			}
			
			// Thing, Tilemap
			return true;
		}
		
		private function initCamera() : void {
			view.camera = new Camera3D(new PerspectiveLens());
			cameraAlign = new CameraAlign(view.camera);
		}
		
		private function initPlayer() : void {
			player = new Player({x:200, y:400});
			cameraAlign.target = player.mesh;
			cameraAlign.offset.setTo(0, 500, -800);
			area.addThing(player);
			
			playerInput = new PlayerInput(player);
			controllers.add(playerInput);
		}
		
		private function initWorld() : void {
			// Area to start in (newgame)
			area = new Area("sword");
		}
	}

}