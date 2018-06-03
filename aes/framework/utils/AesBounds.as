package aes.framework.utils 
{
	import aes.framework.errors.AesArgumentError;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesBounds
	{
		public var minX:Number;
		public var minY:Number;
		public var maxX:Number;
		public var maxY:Number;
		
		
		public function AesBounds(minX:Number = 0, minY:Number = 0, maxX:Number = 0, maxY:Number = 0)
		{
			this.minX = minX;
			this.minY = minY;
			this.maxX = minX;
			this.maxY = minY;
		}
		
		public function set(minX:Number, minY:Number, maxX:Number, maxY:Number):AesBounds
		{
			this.minX = minX;
			this.minY = minY;
			this.maxX = maxX;
			this.maxY = maxY;
			
			return this;
		}
		
		public function setZero():AesBounds
		{
			minX = 0;
			minY = 0;
			maxX = 0;
			maxY = 0;
			
			return this;
		}
		
		public function union(bounds:AesBounds):AesBounds
		{
			minX = minX < bounds.minX ? minX : bounds.minX;
			minY = minY < bounds.minY ? minY : bounds.minY;
			maxX = maxX > bounds.maxX ? maxX : bounds.maxX;
			maxY = maxY > bounds.maxY ? maxY : bounds.maxY;
			
			return this;
		}
		
		public function contains(x:Number, y:Number):Boolean
		{
			return !(x < minX || y < minY || x > maxX || y > maxY);
		}
		
		public function containsVec(v:AesVec):Boolean
		{
			return !(v.x < minX || v.y < minY || v.x > maxX || v.y > maxY);
		}
		
		public function intersects(bounds:AesBounds):Boolean
		{
			return !(maxX < bounds.minX || minX > bounds.maxX ||
			         maxY < bounds.minY || minY > bounds.maxY);
		}
		
		
		public function copyFrom(bounds:AesBounds):AesBounds
		{
			if (bounds == null) {
				throw new AesArgumentError('bounds');
			}
			
			minX = bounds.minX;
			minY = bounds.minY;
			maxX = bounds.maxX;
			maxY = bounds.maxY;
			
			return this;
		}
		
		public function toString():String
		{
			return '[AesBounds (minX: ' + minX.toFixed(4) + '; minY: ' + minY.toFixed(4) + '; maxX: ' + maxX.toFixed(4) + '; maxY: ' + maxY.toFixed(4) + ')]';
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================
		
		public function get width():Number
		{
			return maxX - minX;
		}
		
		public function get height():Number
		{
			return maxY - minY;
		}
		
	}
}