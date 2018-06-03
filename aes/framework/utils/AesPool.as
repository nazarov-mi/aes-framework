package aes.framework.utils
{
	import aes.framework.errors.AesAbstractClassError;
	import aes.framework.errors.AesArgumentError;
	import flash.utils.Dictionary;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesPool
	{
		private static var _pools:Dictionary = new Dictionary();
		
		
		public function AesPool()
		{
			throw new AesAbstractClassError();
		}
		
		/**
		 * Возвращает свободный или создаёт новый экземпляр объекта
		 * @return	Экземпляр объекта
		 */
		public static function get(cls:Class):Object
		{
			var objects:Vector.<Object> = _pools[cls];
			return (objects == null || objects.length == 0 ? new cls() : objects.pop());
		}
		
		/**
		 * Помещает экземпляр объекта в массив свободных объектов
		 * @param	value - экземпляр объект
		 */
		public static function free(object:Object):void
		{
			if (object == null) {
				throw new AesArgumentError('object');
			}
			
			const cls:Class = object.constructor;
			var objects:Vector.<Object> = _pools[cls];
			
			if (objects == null) {
				objects = new Vector.<Object>();
				_pools[cls] = objects;
			}
			
			objects[objects.length] = object;
		}
		
		/**
		 * Очищает массив с объектами
		 */
		public static function clear():void
		{
			for (var key:String in _pools) {
				(_pools[key] as Vector.<Object>).length = 0;
				_pools[key] = null;
				delete _pools[key];
			}
		}
		
	}
}