package aes.framework.display 
{
	import aes.framework.display.AesMesh;
	import aes.framework.gfx.AesTextureRegion;
	
	/**
	 * ...
	 * @author Назаров М.И.
	 */
	
	public class AesActor extends AesMesh
	{
		
		public function AesActor(region:AesTextureRegion) 
		{
			addRect(0, 0, 1, 1);
			this.region = region;
		}
		
	}
}