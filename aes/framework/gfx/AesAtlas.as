package aes.framework.gfx 
{
	import aes.framework.utils.AesMath;
	import aes.framework.utils.AesRect;
	import aes.framework.utils.AesStorage;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.utils.Dictionary;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public class AesAtlas 
	{
		public var data:Texture = null;
		private var _source:BitmapData;
		private var _regions:AesStorage = new AesStorage();
		
		public function AesAtlas(source:BitmapData) 
		{
			_source = source;
		}
		
		public function create(context3d:Context3D):void
		{
			const w:int = AesMath.nextPowerOf2(_source.width);
			const h:int = AesMath.nextPowerOf2(_source.height);
			
			data = context3d.createTexture(w, h, Context3DTextureFormat.BGRA, false);
			data.uploadFromBitmapData(_source);
		}
		
		public function dispose():void
		{
			data.dispose();
			data = null;
			
			_source.dispose();
			_source = null;
			
			_regions.clear();
		}
		
		public function add(name:String, x:uint, y:uint, width:uint, height:uint):void
		{
			const scw:Number = 1 / _source.width;
			const sch:Number = 1 / _source.height;
			
			_regions[name] = new AesTextureRegion(this, x * scw, y * sch, width * scw, height * sch, width, height);
		}
		
		public function get(name:String):AesTextureRegion
		{
			return _regions[name];
		}
		
		public function contains(name:String):Boolean
		{
			return _regions.containsKey(name);
		}
		
	}
}