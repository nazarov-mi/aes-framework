package aes.framework.utils 
{
	import aes.framework.errors.AesArgumentError;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesRect
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		
		public function AesRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function identity():AesRect
		{
			this.x = 0;
			this.y = 0;
			this.width = 0;
			this.height = 0;
			
			return this;
		}
		
		public function set(x:Number, y:Number, width:Number, height:Number):AesRect
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			return this;
		}
		
		public function scl(n:Number):AesRect
		{
			x *= n;
			y *= n;
			width *= n;
			height *= n;
			
			return this;
		}
		
		public function sclxy(xn:Number, yn:Number):AesRect
		{
			x *= xn;
			y *= yn;
			width *= xn;
			height *= yn;
			
			return this;
		}
		
		
		public function rawData():Vector.<Number>
		{
			return Vector.<Number>([x, y, width, height]);
		}
		
		public function copyFrom(rect:AesRect):AesRect
		{
			if (rect == null) {
				throw new AesArgumentError('rect');
			}
			
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
			
			return this;
		}
		
		public function toString():String
		{
			return '[AesRect (x: ' + x.toFixed(4) + '; y:' + y.toFixed(4) + '; width: ' + width.toFixed(4) + '; height: ' + height.toFixed(4) + ')]';
		}
		
	}
}