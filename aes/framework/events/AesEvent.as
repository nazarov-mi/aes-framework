package aes.framework.events
{
	import aes.framework.aes_internal;
	import aes.framework.display.AesBasic;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesEvent
	{
		public static const DISPOSE:String = 'dispose';
		public static const UPDATE:String  = 'update';
		public static const KILL:String    = 'kill';
		public static const REVIVE:String  = 'revive';
		
		
		aes_internal var _type:String;
		aes_internal var _bubbles:Boolean;
		aes_internal var _data:Object;
		
		aes_internal var _eventPhase:String = AesEventPhase.AT_TARGET;
		aes_internal var _target:AesEventDispatcher = null;
		aes_internal var _currentTarget:AesEventDispatcher = null;
		aes_internal var _stop:Boolean = false;
		aes_internal var _stopImmediate:Boolean = false;
		
		
		public function AesEvent(type:String = null, bubbles:Boolean = false, data:Object = null)
		{
			_type = type;
			_bubbles = bubbles;
			_data = data;
		}
		
		public function identity():AesEvent
		{
			_type = null;
			_bubbles = false;
			_data = null;
			_target = null;
			_currentTarget = null;
			_stop = false;
			_stopImmediate = false;
			
			return this;
		}
		
		public function stopPropagation():void
		{
			_stop = true;
		}
		
		public function stopImmediatePropagation():void
		{
			_stopImmediate = true;
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================		
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get bubbles():Boolean 
		{
			return _bubbles;
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function get target():AesEventDispatcher 
		{
			return _target;
		}
		
		public function get currentTarget():AesEventDispatcher 
		{
			return _currentTarget;
		}
		
		public function get eventPhase():String 
		{
			return _eventPhase;
		}
		
		
		public function toString():String
		{
			return '[AesEvent (type: ' + _type + '; bubbles: ' + _bubbles + ']';
		}
		
	}
}