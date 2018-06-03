package aes.framework.gfx.assembler 
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesRegistry
	{
		public static const ATTRIBUTE:AesRegistry = new AesRegistry('Attribute', 0x0, AesRegistryFlag.READ  | AesRegistryFlag.VERT);
		public static const CONSTANT:AesRegistry  = new AesRegistry('Constant',  0x1, AesRegistryFlag.READ  | AesRegistryFlag.VERT  | AesRegistryFlag.FRAG);
		public static const TEMPORARY:AesRegistry = new AesRegistry('Temporary', 0x2, AesRegistryFlag.READ  | AesRegistryFlag.WRITE | AesRegistryFlag.VERT | AesRegistryFlag.FRAG);
		public static const OUTPUT:AesRegistry    = new AesRegistry('Output',    0x3, AesRegistryFlag.WRITE | AesRegistryFlag.VERT  | AesRegistryFlag.FRAG);
		public static const VARYING:AesRegistry   = new AesRegistry('Varying',   0x4, AesRegistryFlag.READ  | AesRegistryFlag.WRITE | AesRegistryFlag.VERT | AesRegistryFlag.FRAG);
		public static const SAMPLER:AesRegistry   = new AesRegistry('Sampler',   0x5, AesRegistryFlag.READ  | AesRegistryFlag.FRAG);
		public static const DEPTH:AesRegistry     = new AesRegistry('Depth',     0x6, AesRegistryFlag.WRITE | AesRegistryFlag.FRAG);
		
		
		public var name:String;
		public var code:uint;
		public var flags:uint;
		
		
		public function AesRegistry(name:String, code:uint, flags:uint)
		{
			this.name = name;
			this.code = code;
			this.flags = flags;
		}
		
		public function checkFlag(flag:uint):Boolean
		{
			return (flags & flag) > 0;
		}
		
	}
}