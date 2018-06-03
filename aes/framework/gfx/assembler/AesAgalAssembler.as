package aes.framework.gfx.assembler
{
	import aes.framework.utils.AesStorage;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesAgalAssembler
	{
		private static const LINE_BREAKER:RegExp = /[\f\n\r\v;]+/g;
		private static const LINE_COMMENT:RegExp = /\/\/[^\n]*\n/g;
		private static const DELIMITERS:RegExp = /[\t ]+/g;
		
		private static const IDENTIFIER:RegExp = /[A-Za-z_][A-Za-z0-9_]*/
		private static const NUMBER:RegExp = /[0-9]/;
		private static const CHARS:RegExp = /[\#\.\[\]]/;
		private static const SEPERATOR:RegExp = /\n/;
		private static const TOKEN:RegExp = new RegExp(IDENTIFIER.source + '|' + NUMBER.source + '|' + CHARS.source + '|' + SEPERATOR.source);
		
		
		private var _fields:AesStorage = new AesStorage();
		private var _byteCode:ByteArray;
		private var _isVertexProgram:Boolean;
		
		private var _tokens:Vector.<String> = new Vector.<String>();
		private var _numTokens:int = 0;
		private var _index:int = 0;
		private var _numTemporaries:int = 0;
		
		public function AesAgalAssembler()
		{
			super();
		}
		
		public function identity():void
		{
			_fields.clear();
			_byteCode = null;
			_tokens.length = 0;
			_numTokens = 0;
			_index = 0;
			_numTemporaries = 0;
		}
		
		public function dispose():void
		{
			identity();
		}
		
		/**
		 * Регистрирует поле под псевдонимом
		 * @param	name - псевдоним
		 * @param   index - индекс
		 * @param	size - размер
		 * @param	registry - реестр
		 * @return Возвращает экземпляр объекта AesField
		 */
		public function addField(name:String, index:uint, size:uint, registry:AesRegistry):AesField
		{	
			if (!_fields.containsKey(name)) {
				var fl:AesField = new AesField(index, size, registry);
				_fields[name] = fl;
				
				return fl;
			}
			
			return null;
		}
		
		/**
		 * Разбирает исходный код шейдера и переводит его на язык AGAL
		 * @param	source - исходный код
		 * @param   type - тип программы
		 * @param	version - версия языка AGAL
		 * @return Возвращает массив байтов
		 */
		public function assemble(source:String, type:String = 'vertex', version:uint = 1):ByteArray
		{
			identity();
			
			_byteCode = new ByteArray();
			_isVertexProgram = (type == 'vertex');
			
			addField('out', 0, 1, AesRegistry.OUTPUT);
			if (!_isVertexProgram) {
				addField('depth', 0, 1, AesRegistry.DEPTH);
			}
			
			_byteCode.clear();
			_byteCode.endian = Endian.LITTLE_ENDIAN;
			_byteCode.writeByte(0xa0);
			_byteCode.writeUnsignedInt(version);
			_byteCode.writeByte(0xa1);
			_byteCode.writeByte(_isVertexProgram ? 0 : 1);
			
			source = clean(source);
			tokenize(source);
			
			while (_index < _numTokens) {
				attemptExp(parseAlias) || ensureExp(parseOperation, 'Неизвестное выражение');
			}
			
			return _byteCode;
		}
		
		/**
		 * Проверяет, являются ли следующие токены командой на регистрацию поля
		 * @return Возвращает true или false
		 */
		private function parseAlias():Boolean
		{
			if (!check('#')) {
				return false;
			}
			
			const registryName:String = ensure(IDENTIFIER);
			
			var registry:AesRegistry;
			switch (registryName.toUpperCase()) {
				
				case 'ATR':
					registry = AesRegistry.ATTRIBUTE;
					break;
				
				case 'CST':
					registry = AesRegistry.CONSTANT;
					break;
				
				case 'VAR':
					registry = AesRegistry.VARYING;
					break;
				
				case 'SMP':
					registry = AesRegistry.SAMPLER;
					break;
				
				default:
					throw new Error('Неизвестное название реестра "' + registryName + '"');
			}
			
			const index:int = int(ensure(NUMBER));
			const name:String = ensure(IDENTIFIER);
			
			var size:int = 1;
			if (check('[')) {
				size = int(ensure(NUMBER));
				ensure(']');
			}
			
			ensureEnd();
			
			if (addField(name, index, size, registry) == null) {
				throw new Error('Поле "' + name + '" уже добавленно');
			}
			
			return true;
		}
		
		/**
		 * Проверяет, являются ли следующие токены оперяцией языка AGAL
		 * @return Возвращает true или false
		 */
		private function parseOperation():Boolean
		{
			const operationName:String = attempt(IDENTIFIER);
			if (operationName == null) {
				return false;
			}
			
			var operation:AesOperation = AesOperations[operationName.toUpperCase()];
			if (operation == null) {
				throw new Error('Неизвестная операция "' + operationName + '"');
			}
			
			if (operation.checkFlag(AesOperationFlag.FRAG_ONLY) && _isVertexProgram) {
				throw new Error('Операция "' + operationName + '" предназначена только для фрагментной программы');
			}
			
			
			_byteCode.writeUnsignedInt(operation.code);
			
			if (operation.checkFlag(AesOperationFlag.NO_DESC)) {
				_byteCode.position = (_byteCode.length += 4);
			} else {
				ensureExp(parseDestField, 'Ожидалось полем для записи результата операции');
			}
			
			if (operation.checkFlag(AesOperationFlag.NO_SOURCE1)) {
				_byteCode.position = (_byteCode.length += 8);
			} else {
				ensureExp(parseField, 'Ожидалось поле с данными для операции');
			}
			
			if (operation.checkFlag(AesOperationFlag.NO_SOURCE2)) {
				_byteCode.position = (_byteCode.length += 8);
			} else {
				ensureExp(parseField, 'Ожидалось поле с данными для операции');
			}
			
			ensureEnd();
			
			return true;
		}
		
		/**
		 * Проверяет, являются ли следующие токены полем для записи результата операции
		 * @return Возвращает true или false
		 */
		private function parseDestField():Boolean
		{
			return parseField(true);
		}
		
		/**
		 * Проверяет, являются ли следующие токены полем с данными для операции
		 * @param	isDestination - тип поля
		 * @return Возвращает true или false
		 */
		private function parseField(isDestination:Boolean = false):Boolean
		{
			const name:String = attempt(IDENTIFIER);
			if (name == null) {
				return false;
			}
			
			var component:int = 0;
			if (check('[')) {
				component = int(ensure(NUMBER));
				ensure(']');
			}
			
			var mask:String = '';
			if (check('.')) {
				mask = ensure(IDENTIFIER);
			}
			
			var fl:AesField = _fields[name] as AesField;
			if (fl == null) {
				fl = addField(name, _numTemporaries ++, 1, AesRegistry.TEMPORARY);
				// throw new Error('Поле "' + name + '" не зарегистрировано');
			}
			
			if (component >= fl.size) {
				throw new Error('Номер компонента поля ' + component + ' выходит за границы его размера ' + fl.size);
			}
			
			if (_isVertexProgram) {
				if (!fl.registry.checkFlag(AesRegistryFlag.VERT)) {
					throw new Error('Поле с типом "' + fl.registry.name + '" не предназначенно для вертексной программы');
				}
			} else {
				if (!fl.registry.checkFlag(AesRegistryFlag.FRAG)) {
					throw new Error('Поле с типом "' + fl.registry.name + '" не предназначенно для фрагментной программы');
				}
			}
			
			if (isDestination) {
				if (!fl.registry.checkFlag(AesRegistryFlag.WRITE)) {
					throw new Error('Запись в реестр "' + fl.registry.name + '" невозможна');
				}
			} else {
				if (!fl.registry.checkFlag(AesRegistryFlag.READ)) {
					throw new Error('Чтение из реестра "' + fl.registry.name + '" невозможно');
				}
			}
			
			writeField(fl, mask, component, isDestination);
			
			return true;
		}
		
		/**
		 * Записывает данные поля в массив байтов
		 * @param	fl - объект, в котором храниться информация о поле (индекс, имя и тд)
		 * @param	mask - маска
		 * @param	component - номер компонента
		 * @param	isDestination - тип поля
		 */
		private function writeField(fl:AesField, mask:String, component:int, isDestination:Boolean):void
		{
			const maskCode:uint = getMaskCode(mask, isDestination);
			
			_byteCode.writeShort(fl.index + component);
			
			if (isDestination) {
				_byteCode.writeByte(maskCode);
				_byteCode.writeByte(fl.registry.code);
			} else
			if (fl.registry == AesRegistry.SAMPLER) {
				_byteCode.writeShort(0);
				_byteCode.writeUnsignedInt(0x5);
			} else {
				_byteCode.writeByte(0);
				_byteCode.writeByte(maskCode);
				_byteCode.writeByte(fl.registry.code);
				_byteCode.writeByte(0);
				_byteCode.writeShort(0);
			}
		}
		
		/**
		 * Возвращает код маски для поля
		 * @param	source - маска
		 * @param	isDestination - тип поля
		 * @return Возвращает код маски
		 */
		private function getMaskCode(source:String, isDestination:Boolean):uint
		{
			if (source == '') {
				return isDestination ? 0xf : 0xe4;
			}
			
			var mask:uint = 0;
			const len:int = source.length;
			
			for (var i:int = 0; i < len; ++ i) {
				var n:uint = 0;
				switch (source.charAt(i)) {
					
					case 'y':
					case 'g':
					case 'v':
						n = 1;
						break;
					
					case 'z':
					case 'b':
						n = 2
						break
					
					case 'w':
					case 'a':
						n = 3;
						break;
				}
				
				if (isDestination) {
					mask |= 1 << n;
				} else {
					mask |= n << (i << 1);
				}
			}
			
			if (!isDestination) {
				for (/* none */; i < 4; ++ i) {
					mask |= n << (i << 1);
				}
			}
			
			return mask;
		}
		
		/**
		 * Очищает код от комментариев и лишних разделителей
		 * @param	source - исходный код
		 * @return Изменённый код
		 */
		private function clean(source:String):String
		{
			var start:int = source.indexOf('/*');
			while (start >= 0) {
				var end:int = source.indexOf('*/', start + 1);
				
				if (end < 0) {
					source = source.substr(0, start);
				} else {
					source = source.substr(0, start) + source.substr(end + 2);
					start = source.indexOf('/*');
				}
			}
			
			source = source.replace(LINE_BREAKER, '\n');
			source = source.replace(LINE_COMMENT, '');
			source = source.replace(DELIMITERS, ' ');
			
			return source;
		}
		
		/**
		 * Удаляет пробелы из начала строки
		 * @param	source - исходная строка
		 * @return Обрезанная строка
		 */
		private function trim(source:String):String
		{
			var i:int = 0;
			while (source.charAt(i) == ' ') {
				++ i;
			}
			
			return source.substr(i);
		}
		
		/**
		 * Ищет токен
		 * @param	source - строка для поиска
		 * @return Токен
		 */
		private function match(source:String):String
		{
			var m:Array = source.match(TOKEN);
			if (m.length > 0 && source.indexOf(m[0]) == 0) {
				return m[0];
			}
			
			return null;
		}
		
		/**
		 * Разбивает исходный код на токины
		 * @param	source - исходный код
		 */
		private function tokenize(source:String):void
		{
			_tokens.length = 0;
			_index = 0;
			
			while (source.length > 0) {
				source = trim(source);
				const token:String = match(source);
				
				if (token == null) {
					throw new SyntaxError('Неизвестный токен');
				}
				
				source = source.substr(token.length);
				_tokens[_tokens.length] = token;
			}
			
			_numTokens = _tokens.length;
		}
		
		/**
		 * Запускает функцию для проверки токенов
		 * В случае неудачи возвращаеться каретку на исходный токен
		 * @param	getter - функция для проверки
		 * @return Возвращает true или false
		 */
		private function attemptExp(getter:Function):Boolean
		{
			const backup:int = _index;
			if (!getter()) {
				_index = backup;
				return false;
			}
			
			return true;
		}
		
		/**
		 * Запускает функцию для проверки токинов
		 * В случае неудачи вызывает ошибку
		 * @param	getter - функция для проверки
		 * @param	error - ошибка
		 * @return Возвращает true или вызывает ошибку
		 */
		private function ensureExp(getter:Function, error:String):Boolean
		{
			if (!getter()) {
				throw new SyntaxError(error);
			}
			
			return true;
		}
		
		/**
		 * Проверяет текущий токен при помощи паттерна
		 * @param	pattern - строка или регулярное выражение для проверки
		 * @return Возвращает true или false
		 */
		private function check(pattern:*):Boolean
		{
			if (_index < _numTokens) {
				const token:String = _tokens[_index];
				if ((pattern is RegExp && token.search(pattern) == 0) || token.indexOf(pattern) == 0) {
					++ _index;
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Проверяет текущий токен при помощи паттерна
		 * @param	pattern - строка или регулярное выражение для проверки
		 * @return Возвращает токен или null
		 */
		private function attempt(pattern:*):String
		{
			if (check(pattern)) {
				return _tokens[_index - 1];
			}
			
			return null;
		}
		
		/**
		 * Проверяет текущий токен при помощи паттерна
		 * В случае неудачи вызывает ошибку
		 * @param	pattern - строка или регулярное выражение для проверки
		 * @return Возвращает true или выбрасывает ошибку
		 */
		private function ensure(pattern:*):String
		{
			if (check(pattern)) {
				return _tokens[_index - 1];
			}
			
			var name:String;
			
			if (pattern == IDENTIFIER) {
				name = 'Identifier';
			} else
			if (pattern == NUMBER) {
				name = 'Number';
			} else
			if (pattern == SEPERATOR) {
				name = 'Seperator';
			} else {
				name = pattern;
			}
			
			throw new SyntaxError('Ожидался "' + name + '"');
		}
		
		/**
		 * Проверяет достигла ли каретка конца программы или является текущий токен концом строки
		 */
		private function ensureEnd():void
		{
			if (_index < _numTokens && !check(SEPERATOR)) {
				throw new SyntaxError('Ожидался конец строки');
			}
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================		
		
		public function get byteCode():ByteArray
		{
			return _byteCode;
		}
		
		public function get isVertexProgram():Boolean
		{
			return _isVertexProgram;
		}
		
	}
}