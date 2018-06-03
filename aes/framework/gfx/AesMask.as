package aes.framework.gfx 
{
	import flash.display3D.textures.Texture;
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMask 
	{
		public var source:Texture;
		public var offsetX:int;
		public var offsetY:int;
		
		
		public function AesMask(source:Texture, offsetX:int, offsetY:int)
		{
			this.source = source;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
		}
		
	}
}