package aes.framework.managers
{
	import aes.framework.errors.AesAbstractClassError;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesManager
	{
		public static var LIST:Vector.<AesManager> = new Vector.<AesManager>();
		
		
		public function AesManager()
		{
			if (Capabilities.isDebugger && getQualifiedClassName(this) == 'aes.framework.managers') {
				throw new AesAbstractClassError();
			}
			
			LIST[LIST.length] = this;
		}
		
		public function create():void 
		{
			//
		}
		
		public function dispose():void 
		{
			//
		}
		
		public function start():void 
		{
			//
		}
		
		public function stop():void 
		{
			//
		}
		
		public function update():void 
		{
			//
		}
		
	}
}