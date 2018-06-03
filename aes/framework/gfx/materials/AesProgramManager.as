package aes.framework.gfx.materials 
{
	import aes.framework.gfx.AesAtlas;
	import flash.display3D.Context3D;
	import flash.utils.Dictionary;
	/**
	 * @author Назаров М. И.
	 */
	
	public class AesProgramManager extends Object
	{
		private var _atlases:Dictionary = new Dictionary();
		private var _context3d:Context3D;
		
		public function AesProgramManager(context3d:Context3D) 
		{
			_context3d = context3d;
		}
		
		public function add(name:String, atlas:AesAtlas):void
		{
			if (atlas.data == null) {
				atlas.create(_context3d);
			}
			
			_atlases[name] = atlas;
		}
		
		public function getAtlasFromRegion(name:String):AesAtlas
		{
			for each (var a:AesAtlas in _atlases) {
				if (a.contains(name)) {
					return a;
				}
			}
			
			return null;
		}
		
	}
}