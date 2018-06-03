package aes.framework.gfx
{
	import flash.display3D.textures.Texture;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesTextureRegion
	{
		private var _atlas:AesAtlas;
		private var _tx:Number;
		private var _ty:Number;
		private var _tw:Number;
		private var _th:Number;
		private var _w:uint;
		private var _h:uint;
		
		public function AesTextureRegion(atlas:AesAtlas, tx:Number, ty:Number, tw:Number, th:Number, width:uint, height:uint)
		{
			_atlas = atlas;
			_tx = tx;
			_ty = ty;
			_tw = tw;
			_th = th;
			_w = width;
			_h = height;
		}
		
		public function rawData():Vector.<Number>
		{
			return Vector.<Number>([_tx, _ty, _tw, _th]);
		}
		
		public function get texture():Texture 
		{
			return _atlas.data;
		}
		
		public function get width():uint 
		{
			return _w;
		}
		
		public function get height():uint 
		{
			return _h;
		}
		
	}
}