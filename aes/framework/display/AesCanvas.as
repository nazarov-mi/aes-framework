package aes.framework.display
{
	import aes.framework.display.AesMesh;
	import aes.framework.gfx.AesTextureRegion;
	import aes.framework.utils.AesVec;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesCanvas extends AesMesh
	{
		private var _lastPoint:AesVec = new AesVec();
		private var _lineColor:uint = 0;
		private var _fillColor:uint = 0;
		private var _thickness:uint = 0;
		private var _drawLines:Boolean = false;
		private var _fillShapes:Boolean = false;
		
		public function AesCanvas(region:AesTextureRegion)
		{
			this.region = region;
		}
		
		override public function clear():void
		{
			super.clear();
			_lastPoint.setZero();
			_lineColor = 0;
			_fillColor = 0;
			_thickness = 0;
			_drawLines = false;
			_fillShapes = false;
		}
		
		public function beginFill(color:uint, alpha:Number = 1):void
		{
			_fillColor = (color & 0xffffff) | ((alpha * 255) << 24);
			_fillShapes = true;
		}
		
		public function endFill():void
		{
			_fillShapes = false;
		}
		
		public function setLineStyle(thickness:uint, color:uint = 0, alpha:Number = 1):void
		{
			_thickness = thickness;
			_lineColor = (color & 0xffffff) | ((alpha * 255) << 24);
			_drawLines = _thickness > 0;
		}
		
		public function moveTo(x:int, y:int):void
		{
			_lastPoint.set(x, y);
		}
		
		public function lineTo(x:int, y:int):void
		{
			if (!_drawLines) {
				return;
			}
			
			addLine(_lastPoint.x, _lastPoint.y, x, y, _thickness, _lineColor);
			_lastPoint.set(x, y);
		}
		
		public function curveTo(x:int, y:int, archorX:int, archorY:int, numSides:uint = 6):void
		{
			if (!_drawLines) {
				return;
			}
			
			if (numSides < 1) {
				numSides = 1;
			}
			
			const step:Number = 1 / numSides;
			var t:Number = step;
			var xp:int, yp:int;
			var ox:int = _lastPoint.x;
			var oy:int = _lastPoint.y;
			
			while (t <= 1) {
				xp = (1 - t) * (1 - t) * _lastPoint.x + 2 * t * (1 - t) * archorX + t * t * x;
				yp = (1 - t) * (1 - t) * _lastPoint.y + 2 * t * (1 - t) * archorY + t * t * y;
				
				addLine(ox, oy, xp, yp, _thickness, _lineColor);
				
				ox = xp;
				oy = yp;
				
				t += step;
			}
			
			_lastPoint.set(x, y);
		}
		
		public function drawRect(x:int, y:int, w:int, h:int):void
		{
			if (_fillShapes) {
				addRect(x, y, w, h, _fillColor);
			}
			
			if (_drawLines) {
				addLine(x    , y    , x + w, y    , _thickness, _lineColor);
				addLine(x + w, y    , x + w, y + h, _thickness, _lineColor);
				addLine(x + w, y + h, x    , y + h, _thickness, _lineColor);
				addLine(x    , y + h, x    , y    , _thickness, _lineColor);
			}
		}
		
		public function drawElipse(x:int, y:int, radiusX:uint, radiusY:uint, numSides:uint = 16):void
		{
			if (_fillShapes) {
				addEllipse(x, y, radiusX, radiusY, _fillColor, numSides);
			}
			
			if (_drawLines) {
				const a:Number = Math.PI * 2 / numSides;
				
				moveTo(radiusX + x, y);
				++ numSides;
				for (var i:int = 1; i < numSides; ++ i) {
					lineTo(Math.cos(a * i) * radiusX + x, Math.sin(a * i) * radiusY + y);
				}
			}
		}
		
		public function drawCircle(x:int, y:int, radius:uint, numSides:uint = 16):void
		{
			drawElipse(x, y, radius, radius, numSides);
		}
		
	}
}