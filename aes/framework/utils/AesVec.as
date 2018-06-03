package aes.framework.utils
{
	import aes.framework.errors.AesArgumentError;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesVec
	{
		public var x:Number;
		public var y:Number;
		
		public function AesVec(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function set(x:Number, y:Number):AesVec
		{
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function setVec(v:AesVec):AesVec
		{
			x = v.x;
			y = v.y;
			
			return this;
		}
		
		public function setZero():AesVec
		{
			x = 0;
			y = 0;
			
			return this;
		}
		
		public function transform(m:AesMat):AesVec
		{
			const xp:Number = x;
			const yp:Number = y;
			
			x = xp * m.a + yp * m.b + m.x;
			y = xp * m.c + yp * m.d + m.y;
			
			return this;
		}
		
		public function add(v:AesVec):AesVec
		{
			x += v.x;
			y += v.y;
			
			return this;
		}
		
		public function sub(v:AesVec):AesVec
		{
			x -= v.x;
			y -= v.y;
			
			return this;
		}
		
		public function scl(n:Number):AesVec
		{
			x *= n;
			y *= n;
			
			return this;
		}
		
		public function sclxy(xn:Number, yn:Number):AesVec
		{
			x *= xn;
			y *= yn;
			
			return this;
		}
		
		public function dot(v:AesVec):Number
		{
			return x * v.x + y * v.y;
		}
		
		public function cross(v:AesVec):Number
		{
			return x * v.y - v.x * y;
		}
		
		public function lenSqr():Number
		{
			return x * x + y * y;
		}
		
		public function len():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function crossL(n:Number = 1):AesVec
		{	
			return set(y * -n, x * n);
		}
		
		public function crossR(n:Number = 1):AesVec
		{
			return set(y * n, x * -n);
		}
		
		public function normalize():AesVec
		{
			const l:Number = 1 / Math.sqrt(x * x + y * y);
			
			x *= l;
			y *= l;
			
			return this;
		}
		
		public function abs():AesVec
		{
			x *= x < 0 ? -1 : 1;
			y *= y < 0 ? -1 : 1;
			
			return this;
		}
		
		public function copyFrom(v:AesVec):AesVec
		{
			if (v == null) {
				throw new AesArgumentError('v');
			}
			
			x = v.x;
			y = v.y;
			
			return this;
		}
		
		public function toString():String
		{
			return '[AesVec (x: ' + x.toFixed(4) + '; y: ' + y.toFixed(4) + ')]';
		}
		
	}
}