package aes.framework.utils 
{	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMath 
	{
		public static const TO_DEC:Number = 180 / Math.PI;
		public static const TO_RAD:Number = Math.PI / 180;
		public static const MAXN:Number = 1e+22;
		public static const MINN:Number = -1e+22;
		public static const EPS:Number = .0001;
		
		
		public static function nextPowerOf2(n:uint):uint
		{
			-- n;
			n |= (n >> 1);
			n |= (n >> 2);
			n |= (n >> 4);
			n |= (n >> 8);
			n |= (n >> 16);
			return n + 1;
		}
		
		public static function clamp(n:Number, min:Number, max:Number):Number
		{
			return (n < min ? min : (n > max ? max : n));
		}
		
		public static function sign(n:Number):int
		{
			return (n < 0 ? -1 : 1);
		}
		
		public static function containsWithTriangle(v:AesVec, a:AesVec, b:AesVec, c:AesVec):Boolean
		{
			return ((v.x - b.x) * (a.y - b.y) - (a.x - b.x) * (v.y - b.y) < 0 &&
					(v.x - c.x) * (b.y - c.y) - (b.x - c.x) * (v.y - c.y) < 0 &&
					(v.x - a.x) * (c.y - a.y) - (c.x - a.x) * (v.y - a.y) < 0);
		}
		
		public static function switchEndian(rgba:uint):uint
		{
			return ( rgba        & 0xff) << 24 |
			       ((rgba >>  8) & 0xff) << 16 |
			       ((rgba >> 16) & 0xff) <<  8 |
			       ((rgba >> 24) & 0xff);
		}
		
	}
}