package aes.framework.files 
{
	import flash.display.BitmapData;
	import flash.media.Sound;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public class AesFile 
	{
		public var name:String;
		public var url:String;
		public var type:String;
		public var data:Object = null;
		public var loaded:Boolean = false;
		public var error:Boolean = false;
		
		
		public function AesFile(name:String, url:String, type:String)
		{
			this.name = name;
			this.url = url;
			this.type = type;
		}
		
		public function dispose():void
		{
			if (loaded && data != null) {
				switch (type) {
					
					case AesFileType.IMAGE:
						(data as BitmapData).dispose();
						break;
					
					case AesFileType.SOUND:
						(data as AesSound).dispose();
						break;
				}
			}
		}
		
	}
}