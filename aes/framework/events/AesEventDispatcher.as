package aes.framework.events
{
	import aes.framework.display.AesBasic;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.aes_internal;
	import aes.framework.utils.AesPool;
	import aes.framework.utils.AesStorage;
	import flash.utils.Dictionary;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesEventDispatcher
	{
		private var _bubbleListeners:AesStorage;
		private var _captureListeners:AesStorage;
		
		
		public function AesEventDispatcher()
		{
			super();
		}
		
		public function addListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (listener == null) {
				throw new AesArgumentError('listener');
			}
			
			var listenersBase:AesStorage;
			
			if (useCapture) {
				if (_captureListeners == null) {
					_captureListeners = new AesStorage();
				}
				listenersBase = _captureListeners;
			} else {
				if (_bubbleListeners == null) {
					_bubbleListeners = new AesStorage;
				}
				listenersBase = _bubbleListeners;
			}
			
			var listeners:Vector.<Function> = listenersBase[type];
			
			if (listeners == null) {
				listenersBase[type] = Vector.<Function>([listener]);
			} else
			if (listeners.indexOf(listener) < 0) {
				listeners[listeners.length] = listener;
			}
		}
		
		public function removeListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (listener == null) {
				throw new AesArgumentError('listener');
			}
			
			var listenersBase:AesStorage = useCapture ? _captureListeners : _bubbleListeners;
			
			if (listenersBase != null && listenersBase[type] != null) {
				var listeners:Vector.<Function> = listenersBase[type];
				var i:int = listeners.indexOf(listener);
				
				if (i >= 0) {
					const len:int = listeners.length;
					for (var j:int = i + 1; j < len; ++ j) {
						listeners[j - 1] = listeners[j];
					}
					
					if (len > 1) {
						listeners.length = len - 1;
					} else {
						listenersBase.remove(type);
						
						if (listenersBase.isEmpty()) {
							if (useCapture) {
								_captureListeners = null
							} else {
								_bubbleListeners = null;
							}
						}
					}
				}
			}
		}
		
		public function removeListeners(type:String):void
		{
			_bubbleListeners.remove(type);
			_captureListeners.remove(type);
		}
		
		public function clearListeners():void
		{
			_bubbleListeners.clear();
			_captureListeners.clear();
		}
		
		public function dispatchWith(type:String, bubbles:Boolean = false, data:Object = null):void
		{
			var event:AesEvent = AesPool.get(AesEvent) as AesEvent;
			event._type = type;
			event._bubbles = bubbles;
			event._data = data;
			
			dispatchEvent(event);
			
			AesPool.free(event);
		}
		
		public function dispatchEvent(event:AesEvent):void
		{
			if (event == null) {
				throw new AesArgumentError('event');
			}
			
			if (!hasListener(event._type)) {
				return;
			}
			
			event._target = this;
			
			if (!(this is AesBasic)) {
				event._eventPhase = AesEventPhase.AT_TARGET;
				event._currentTarget = this;
				object.invokeEvent(event, false);
				return;
			}
			
			var branch:Vector.<AesBasic> = AesPool.get(Vector.<AesBasic> as Class) as Vector.<AesBasic>;
			var object:AesBasic = this as AesBasic;
			var len:int = 0;
			var i:int;
			
			while (object != null) {
				branch[len ++] = object;
				object = object.parent;
			}
			
			try {
				if (_captureListeners != null && _captureListeners[event._type] != null) {
					// Capture phase
					event._eventPhase = AesEventPhase.CAPTURING_PHASE;
					
					for (i = len - 1; i > 0; -- i) {
						object = branch[i];
						event._currentTarget = object;
						
						if (object.invokeEvent(event, true)) {
							return;
						}
					}
				}
				
				if (_bubbleListeners != null && _bubbleListeners[event._type] != null) {
					// At target
					object = branch[0];
					event._eventPhase = AesEventPhase.AT_TARGET;
					event._currentTarget = this;
					if (object.invokeEvent(event, false)) {
						return;
					}
					
					// Bubbles phases
					if (event._bubbles) {
						event._eventPhase = AesEventPhase.BUBBLING_PHASE;
						
						for (i = 1; i < len; ++ i) {
							object = branch[i];
							event._currentTarget = object;
							
							if (object.invokeEvent(event, false)) {
								return;
							}
						}
					}
				}
			} finally {
				branch.length = 0;
				AesPool.free(branch);
			}
		}
		
		public function hasListener(type:String):Boolean 
		{
			return (_captureListeners != null && _captureListeners[type] != null) || (_bubbleListeners != null && _bubbleListeners[type] != null);
		}
		
		private function invokeEvent(event:AesEvent, capture:Boolean):Boolean
		{
			var listenersBase:AesStorage = capture ? _captureListeners : _bubbleListeners;
			
			if (listenersBase != null) {
				var listeners:Vector.<Function> = listenersBase[event._type];
				
				if (listeners != null) {
					var plisteners:Vector.<Function> = listeners.slice();
					
					const len:int = plisteners.length;
					for (var i:int = 0; i < len; ++ i) {
						plisteners[i].call(null, event);
						
						if (event._stopImmediate) {
							return true;
						}
					}
					
					return event._stop;
				}
			}
			
			return false;
		}
		
	}
}