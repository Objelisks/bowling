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
			
			controllers = new FlxGroup();
			
			// View will automatically size itself I think
			view = new View3D();
			FlxG.view = view;
			FlxG.stage.addChild(view);
			view.scene = new Scene3D();
			
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
			controllers.update();
			
			// not adding to group because then I'd have to go find it to remove it
			area.preUpdate();
			
			// collide stuff
			FlxG.collide(area.things, area.things);
			FlxG.overlap(area.triggers, area.things, triggerOverlap);
			if(area.loaded)
				FlxG.collide(area.things, area.tiles);
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
		
		private function triggerOverlap(obj1:FlxObject, obj2:FlxObject):void {
			if(obj1 is Trigger) {
				(obj1 as Trigger).trigger(obj2);
			} else if(obj2 is Trigger) {
				(obj2 as Trigger).trigger(obj1);
			}
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
			
			var playerInput:PlayerInput = new PlayerInput(player);
			controllers.add(playerInput);
		}
		
		private function initWorld() : void {
			// Area to start in (newgame)
			area = new Area("sword");
		}
	}

}