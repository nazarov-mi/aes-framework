package aes.framework.utils
{
	import aes.framework.errors.AesArgumentError;
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesColor
	{
		public static const CLEAR:AesColor    = new AesColor(0x00000000);
		public static const WHITE:AesColor    = new AesColor(0xffffffff);
		public static const BLACK:AesColor    = new AesColor(0xff000000);
		
		public static const RED:AesColor      = new AesColor(0xffF15A5A);
		public static const ORANGE:AesColor   = new AesColor(0xffffa500);
		public static const YELLOW:AesColor   = new AesColor(0xffF0C419);
		public static const GREEN:AesColor    = new AesColor(0xff4EBA6F);
		public static const TEAL:AesColor     = new AesColor(0xff008080);
		public static const BLUE:AesColor     = new AesColor(0xff2D95BF);
		public static const VIOLET:AesColor   = new AesColor(0xff955BA5);
		
		public static const MAROON:AesColor   = new AesColor(0xffb03060);
		public static const BLUEGRAY:AesColor = new AesColor(0xff797989);
		public static const DARKPINK:AesColor = new AesColor(0xff452235);
		
		
		public var a:Number;
		public var r:Number;
		public var g:Number;
		public var b:Number;
		
		
		public function AesColor(color:uint = 0xffffffff)
		{
			set(color);
		}
		
		public function set(color:uint):AesColor
		{
			a = ((color >> 24) & 0xff) / 255;
			r = ((color >> 16) & 0xff) / 255;
			g = ((color >> 8) & 0xff) / 255;
			b = (color & 0xff) / 255;
			
			return this;
		}
		
		public function get():uint
		{
			return ((a * 255) << 24) | ((r * 255) << 16) | ((g * 255) << 8) | (b * 255);
		}
		
		
		public function copyFrom(color:AesColor):AesColor
		{
			if (color == null) {
				throw new AesArgumentError('color');
			}
			
			a = color.a;
			r = color.r;
			g = color.g;
			b = color.b;
			
			return this;
		}
		
		public function rawData():Vector.<Number>
		{
			return Vector.<Number>([r, g, b, a]);
		}
		
		public function toString():String
		{
			return '[AesColor (a: ' + a.toFixed(4) + '; r: ' + r.toFixed(4) + '; g: ' + g.toFixed(4) + '; b: ' + b.toFixed(4) + ')]';
		}
		
	}
}