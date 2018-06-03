package aes.framework.gfx.assembler
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesField
	{
		public var index:uint;
		public var size:uint;
		public var registry:AesRegistry;
		
		
		public function AesField(index:uint, size:uint, registry:AesRegistry)
		{
			this.index = index;
			this.size = size;
			this.registry = registry;
		}
		
	}
}