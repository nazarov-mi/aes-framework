package aes.framework.gfx
{
	import flash.display3D.Context3DBlendFactor;
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesBlendMode
	{
		public static const NONE:AesBlendMode     = new AesBlendMode(Context3DBlendFactor.ONE,                         Context3DBlendFactor.ZERO);
		public static const NORMAL:AesBlendMode   = new AesBlendMode(Context3DBlendFactor.ONE,                         Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		public static const ADD:AesBlendMode      = new AesBlendMode(Context3DBlendFactor.ONE,                         Context3DBlendFactor.ONE);
		public static const MULTIPLY:AesBlendMode = new AesBlendMode(Context3DBlendFactor.DESTINATION_COLOR,           Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		public static const SCREEN:AesBlendMode   = new AesBlendMode(Context3DBlendFactor.ONE,                         Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
		public static const ERASE:AesBlendMode    = new AesBlendMode(Context3DBlendFactor.ZERO,                        Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		public static const MASK:AesBlendMode     = new AesBlendMode(Context3DBlendFactor.ZERO,                        Context3DBlendFactor.SOURCE_ALPHA);
		public static const BELOW:AesBlendMode    = new AesBlendMode(Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA);
		
		
		private var _sourceFactor:String;
		private var _destinationFactor:String;
		
		
		public function AesBlendMode(sourceFactor:String, destinationFactor:String)
		{
			_sourceFactor = sourceFactor;
			_destinationFactor = destinationFactor;
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================
		
		public function get sourceFactor():String 
		{
			return _sourceFactor;
		}
		
		public function get destinationFactor():String 
		{
			return _destinationFactor;
		}
		
	}
}