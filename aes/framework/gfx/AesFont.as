package aes.framework.gfx 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * @author Назаров М.И.
	 */
	
	public final class AesFont extends Object
	{
		public var source:BitmapData;
		public var data:Object;
		
		public var lineHeight:int = 12;
		
		public function AesFont(source:BitmapData, data:String)
		{
			this.source = source;
			this.data = JSON.parse(data);
		}
		
		public function copyRect(rect:Rectangle, char:String):Boolean
		{
			const charData:Object = data[char];
			
			if (charData == null) {
				return false;
			}
			
			rect.x = charData.x;
			rect.y = charData.y;
			rect.width = charData.w;
			rect.height = charData.h;
			
			return true;
		}
		
	}
}