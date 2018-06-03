package aes.framework.gfx
{
	import aes.framework.gfx.materials.AesProgram;
	import flash.display3D.Context3D;
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMaterial
	{
		private var _program:AesProgram;
		private var _texture:AesTextureRegion;
		private var _textureRepeat:Boolean = false;
		private var _blendMode:AesBlendMode = AesBlendMode.NORMAL;
		
		
		public function AesMaterial()
		{
			
		}
		
	}
}