package aes.framework.events
{
	import aes.framework.aes_internal;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMouseEvent extends AesEvent
	{
		public static const HOVER:String = 'hover';
		public static const BEGAN:String = 'began';
		public static const MOVED:String = 'moved';
		public static const ENDED:String = 'ended';
		public static const WHEEL:String = 'wheel';
		
		
		public var globalX:Number = null;
		public var globalY:Number = null;
		public var localX:Number;
		public var localY:Number;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		public var shiftKey:Boolean;
		
		aes_internal var _phase:String = null;
		
		
		public function AesMouseEvent(type:String = null, bubbles:Boolean = false, localX:Number = null, localY:Number = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false)
		{
			super(type, bubbles);
			
			this.localX = localX
			this.localY = localY;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
		}
		
		override public function identity():AesMouseEvent
		{
			globalX = null;
			globalY = null;
			localX = null;
			localY = null;
			ctrlKey = false;
			altKey = false;
			shiftKey = false;
			_phase = null;
			
			super.identity();
			
			return this;
		}
		
		override public function toString():String
		{
			return '[AesMouseEvent (type: ' + _type + '; bubbles: ' + _bubbles + '; ctrlKey: ' + _ctrlKey + '; shiftKey: ' + _shiftKey + ']';
		}
		
	}
}