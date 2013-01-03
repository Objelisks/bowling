package 
{
	import away3d.containers.View3D;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import away3d.loaders.parsers.OBJParser;
	import flash.display.Sprite;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Rather Fanciful
	 */
	public class Main extends FlxGame 
	{
		public var view:View3D;
		
		public function Main():void 
		{
			// Size set to 1, 1 to prevent 0 bugs and to stop flixel from drawing over stuff
			super(1, 1, GameState);
			
			// can't see debugger anyways
			forceDebugger = false;
			
			// Enable parser for loading files later
			AssetLoader.enableParser(MD5AnimParser);
			AssetLoader.enableParser(MD5MeshParser);
			AssetLoader.enableParser(OBJParser);
		}
		
	}
	
}