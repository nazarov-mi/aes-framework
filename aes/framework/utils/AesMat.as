package aes.framework.utils
{
	import aes.framework.errors.AesArgumentError;
	/**
	 * @author Назаров М. И.
	 */
	
	public class AesMat
	{
		//=============
		//  a | b | x
		// ---+---+---
		//  c | d | y
		// ---+---+---
		//  0 | 0 | 1
		//=============
		
		public var a:Number = 1;
		public var b:Number = 0;
		
		public var c:Number = 0;
		public var d:Number = 1;
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		
		public function AesMat(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, x:Number = 0, y:Number = 0)
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			
			this.x = x;
			this.y = y;
		}
		
		public function set(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, x:Number = 0, y:Number = 0):AesMat
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function identity():AesMat
		{
			a = 1;
			b = 0;
			c = 0;
			d = 1;
			
			x = 0;
			y = 0;
			
			return this;
		}
		
		public function rotateCS(cos:Number, sin:Number):AesMat
		{
			a = cos;
			b = -sin;
			c = sin;
			d = cos;
			
			x = 0;
			y = 0;
			
			return this;
		}
		
		public function rotateRad(rads:Number):AesMat
		{
			return rotateCS(Math.cos(rads), Math.sin(rads));
		}
		
		public function rotate(angle:int):AesMat
		{
			const rads:Number = angle * AesMath.TO_RAD;
			return rotateCS(Math.cos(rads), Math.sin(rads));
		}
		
		public function translate(x:int, y:int):AesMat
		{
			a = 1;
			b = 0;
			c = 0;
			d = 1;
			
			this.x = x;
			this.y = y;
			
			return this;
		}
		
		public function scale(sx:Number, sy:Number):AesMat
		{
			a = sx;
			b = 0;
			c = 0;
			d = sy;
			
			x = 0;
			y = 0;
			
			return this;
		}
		
		
		public function mul(m:AesMat):AesMat
		{
			return set(
				a * m.a + c * m.b,
				b * m.a + d * m.b,
				a * m.c + c * m.d,
				b * m.c + d * m.d,
				m.x * a + m.y * b + x,
				m.x * c + m.y * d + y
			);
		}
		
		public function mulLeft(m:AesMat):AesMat
		{
			return set(
				m.a * a + m.c * b,
				m.b * a + m.d * b,
				m.a * c + m.c * d,
				m.b * c + m.d * d,
				x * m.a + y * m.b + m.x,
				x * m.c + y * m.d + m.y
			);
		}
		
		public function invert():AesMat
		{
			var det:Number = a * d - b * c;
			
			if (det == 0) {
				throw new Error('Невозможно найти обратную матрицу, так как её детерминант равен нулю');
			}
			
			det = 1 / det;
			
			return set(
				d * det,
				b * det,
				c * det,
				a * det,
				(b * y - d * x) * det,
				(c * x - a * y) * det
			);
		}
		
		public function compose(xa:int, ya:int, px:int, py:int, angle:int, w:int, h:int, sx:Number, sy:Number):AesMat
		{
			const rad:Number = angle * AesMath.TO_RAD;
			const cos:Number = Math.cos(rad);
			const sin:Number = Math.sin(rad);
			const wsx:Number = w * sx;
			const hsy:Number = h * sy;
			const spx:Number = -px * sx;
			const spy:Number = -py * sy;
			
			a = wsx *  cos;
			b = wsx *  sin;
			c = hsy * -sin;
			d = hsy *  cos;
			
			x = spx * cos - spy * sin + xa;
			y = spx * sin + spy * cos + ya;
			
			return this;
		}
		
		public function composeOrthographicProjectionMatrix(xa:int, ya:int, width:int, height:int, zoom:Number):AesMat
		{
			const inv_zoom:Number = 1 / zoom;
			
			width *= inv_zoom;
			height *= inv_zoom;
			
			return set(
				2 / width,
				0,
				0,
				-2 / height,
				 (2 * xa - width) / width,
				-(2 * ya - height) / height
			);
		}
		
		public function rawData():Vector.<Number>
		{
			return Vector.<Number>([a, c, x, 0,  b, d, y, 0]);
		}
		
		public function copyFrom(mat:AesMat):AesMat
		{
			if (mat == null) {
				throw new AesArgumentError('mat');
			}
			
			a = mat.a;
			b = mat.b;
			c = mat.c;
			d = mat.d;
			
			x = mat.x;
			y = mat.y;
			
			return this;
		}
		
		public function toString():String
		{
			return '[AesMat3]' +
				'[a: ' + a.toFixed(4) + '; b: ' + b.toFixed(4) + ']' +
				'[c: ' + c.toFixed(4) + '; d: ' + d.toFixed(4) + ']' +
				'[x: ' + x.toFixed(4) + '; y: ' + y.toFixed(4) + ']';
		}
		
	}
}