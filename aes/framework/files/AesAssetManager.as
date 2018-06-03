package aes.framework.files 
{
	import aes.framework.files.AesFileType;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public final class AesAssetManager extends EventDispatcher
	{
		private var _files:Vector.<AesFile> = new Vector.<AesFile>();
		private var _numFiles:int = 0;
		private var _currentFile:AesFile;
		private var _fileIndex:int;
		private var _loader:Loader = new Loader();
		private var _urlLoader:URLLoader = new URLLoader();
		private var _request:URLRequest = new URLRequest();
		
		
		public function AesAssetManager() 
		{
			addListeners(_loader.contentLoaderInfo);
			addListeners(_urlLoader);
		}
		
		public function indexOf(name:String):int
		{
			for (var i:int = 0; i < _numFiles; ++ i) {
				if (_files[i].name == name) {
					return i;
				}
			}
			
			return -1;
		}
		
		public function add(name:String, url:String, type:String):void
		{
			const i:int = indexOf(name);
			if (i < 0) {
				_files[_numFiles ++] = new AesFile(name, url, type);
			}
		}
		
		public function remove(name:String):void
		{
			const i:int = indexOf(name);
			if (i >= 0) {
				_files[i].dispose();
				_files.splice(i, 1);
				-- _numFiles;
			}
		}
		
		public function get(name:String):*
		{
			const i:int = indexOf(name);
			if (i >= 0) {
				return _files[i].data;
			}
			
			return null;
		}
		
		public function load():void
		{
			_fileIndex = 0;
			loadNextFile();
		}
		
		private function loadNextFile():void
		{
			if (_fileIndex >= _numFiles) {
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_currentFile = _files[_fileIndex ++];
			
			if (_currentFile.loaded || _currentFile.error) {
				loadNextFile();
			}
			
			_request.url = _currentFile.url;
			
			switch (_currentFile.type) {
				
				case AesFileType.IMAGE:
					_loader.load(_request);
					break;
				
				case AesFileType.TEXT:
					_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					_urlLoader.load(_request);
					break;
				
				case AesFileType.SOUND:
					_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					_urlLoader.load(_request);
					break;
				
				default:
					_currentFile.error = true;
					loadNextFile();
			}
		}
		
		private function addListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function removeListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			_currentFile.loaded = true;
			
			switch (_currentFile.type) {
				
				case AesFileType.IMAGE:
					_currentFile.data = (_loader.content as Bitmap).bitmapData;
					break;
				
				case AesFileType.TEXT:
					_currentFile.data = _urlLoader.data;
					break;
				
				case AesFileType.SOUND:
					_currentFile.data = AesSound.fromByteArray(_urlLoader.data as ByteArray);
					break;
			}
			
			loadNextFile();
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace(event.text);
			_currentFile.error = true;
			loadNextFile();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace(event.text);
			_currentFile.error = true;
			loadNextFile();
		}
		
	}
}