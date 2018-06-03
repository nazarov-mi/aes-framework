package aes.framework.core
{
	import aes.framework.aes_internal;
	import aes.framework.utils.AesColor;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesVec;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesCamera
	{
		public var backgroundColor:AesColor;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _w:Number = 0;
		private var _h:Number = 0;
		private var _zoom:Number = 1;
		private var _matrix:AesMat = new AesMat();
		private var _mustTransform:Boolean = true;
		
		public function AesCamera(backgroundColor:AesColor = null)
		{
			this.backgroundColor = backgroundColor == null ? AesColor.WHITE : backgroundColor;
		}
		
		aes_internal function resize(width:int, height:int):AesCamera
		{
			if (_w != width && _h != height) {
				_w = width;
				_h = height;
				_mustTransform = true;
			}
			
			return this;
		}
		
		public function setPosition(x:int, y:int):AesCamera
		{
			if (_x != x && _y != y) {
				_x = x;
				_y = y;
				_mustTransform = true;
			}
			
			return this;
		}
		
		public function screenToGlobalCoordinates(v:AesVec):AesVec
		{
			return v.scl(1 / _zoom);
		}
		
		public function get matrix():AesMat
		{
			if (_mustTransform) {
				_matrix.composeOrthographicProjectionMatrix(_x, _y, _w, _h, _zoom);
				_mustTransform = false;
			}
			
			return _matrix;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			if (_x != value) {
				_x = value;
				_mustTransform = true;
			}
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			if (_y != value) {
				_y = value;
				_mustTransform = true;
			}
		}
		
		public function get w():Number 
		{
			return _w;
		}
		
		public function get h():Number 
		{
			return _h;
		}
		
		public function get zoom():Number 
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void 
		{
			if (_zoom != value) {
				_zoom = value;
				_mustTransform = true;
			}
		}
		
	}
}