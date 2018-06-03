package aes.framework.events
{
	import aes.framework.errors.AesAbstractClassError;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesEventPhase
	{
		
		public static const CAPTURING_PHASE:String = 'capturingPhase';
		public static const BUBBLING_PHASE:String  = 'bubblingPhase';
		public static const AT_TARGET:String       = 'atTarget';
		
		
		public function AesEventPhase()
		{
			throw new AesAbstractClassError();
		}
		
	}
}