package aes.framework.utils
{
	import flash.utils.Dictionary;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public dynamic class AesStorage extends Dictionary
	{
		
		public function AesStorage(weakKeys:Boolean = true)
		{
			super(weakKeys);
		}
		
		public function set(name:String, value:Object):void
		{
			this[name] = value;
		}
		
		public function get(name:String):Object
		{
			return this[name];
		}
		
		public function getKey(value:Object):String
		{
			for (var key:String in this) {
				if (this[key] == value) {
					return key;
				}
			}
			
			return null;
		}
		
		public function remove(name:String):void
		{
			this[name] = null;
			delete this[name];
		}
		
		public function contains(value:Object):Boolean
		{
			for each (var val:Object in this) {
				if (val == value) {
					return true;
				}
			}
			
			return false;
		}
		
		public function containsKey(key:String):Boolean
		{
			return this[key] != null;
		}
		
		public function clear():void
		{
			for (var key:String in this) {
				this[key] = null;
				delete this[key];
			}
		}
		
		public function size():int
		{
			var i:int = 0;
			
			for each (var val:Object in this) {
				if (val != null) {
					++ i;
				}
			}
			
			return i;
		}
		
		public function isEmpty():Boolean
		{
			var key:* = null;
			for (key in this) break;
			return key == null;
		}
		
		public function toString():String
		{
			var buffer:Array = [];
			
			for (var key:String in this) {
				buffer[buffer.length] = key + ': ' + this[key].toString();
			}
			
			return '[AesStorage (' + buffer.join(', ') + ')]';
		}
		
	}
}