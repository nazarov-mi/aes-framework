package aes.framework.gfx.assembler
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesOperation
	{
		public var code:uint;
		public var flags:uint;
		
		
		public function AesOperation(code:uint, flags:uint)
		{
			this.code = code;
			this.flags = flags;
		}
		
		public function checkFlag(flag:uint):Boolean
		{
			return (flags & flag) > 0;
		}
		
	}
}