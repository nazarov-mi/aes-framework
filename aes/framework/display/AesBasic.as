package aes.framework.display 
{
	import aes.framework.aes_internal;
	import aes.framework.core.AesSpace;
	import aes.framework.errors.AesAbstractClassError;
	import aes.framework.errors.AesAbstractMethodError;
	import aes.framework.events.AesEvent;
	import aes.framework.events.AesEventDispatcher;
	import aes.framework.display.AesMesh;
	import aes.framework.geom.AesMeshToken;
	import aes.framework.gfx.AesMask;
	import aes.framework.gfx.AesRenderer;
	import aes.framework.gfx.AesTextureRegion;
	import aes.framework.gfx.materials.AesProgram;
	import aes.framework.utils.AesBounds;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesVec;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesBasic extends AesEventDispatcher
	{
		private static var ID_COUNTER:int = 0;
		
		public var id:int = ++ ID_COUNTER;
		
		public var visible:Boolean = true;
		public var alpha:Number = 1;
		public var mask:AesMask = null;
		
		public var z:Number = 0;
		public var userData:Object = {};
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _px:Number = 0;
		private var _py:Number = 0;
		private var _angle:Number = 0;
		private var _w:Number = 1;
		private var _h:Number = 1;
		private var _sx:Number = 1;
		private var _sy:Number = 1;
		private var _matrix:AesMat = new AesMat();
		private var _invMatrix:AesMat = new AesMat();
		internal var _bounds:AesBounds = new AesBounds();
		private var _parent:AesGroup = null;
		aes_internal var _mustTransform:Boolean = true;
		aes_internal var _mustRedraw:Boolean = true;
		
		
		public function AesBasic()
		{
			super();
		}
		
		
		//==================
		// Abstract methods
		//==================
		
		public function dispose():void
		{
			//
		}
		
		public function update(dt:Number):void
		{
			//
		}
		
		public function render(renderer:AesRenderer, parentAlpha:Number):void
		{
			//
		}
		
		public function hitTest(v:AesVec):AesBasic
		{
			return null;
		}
		
		aes_internal function calculateBounds():AesBounds
		{
			return null;
		}
		
		
		
		aes_internal function setRedraw():void
		{
			_mustRedraw = true;
		}
		
		aes_internal function setTransform():void
		{
			_mustTransform = true;
			_mustRedraw = true;
		}
		
		aes_internal function setParent(cont:AesGroup):void
		{
			var collector:AesBasic = cont;
			
			while (collector != this && collector != null) {
				collector = collector._parent;
			}
			
			if (collector == this) {
				throw new ArgumentError('Объект не может быть добавлен в качестве дочернего к себе или одному из своих дочерних объектов');
			}
			
			_parent = cont;
			setTransform();
		}
		
		aes_internal function updateTransform():void
		{
			_mustTransform = false;
			_matrix.compose(_x, _y, _px, _py, _angle, _w, _h, _sx, _sy);
			
			if (parent != null) {
				_matrix.mul(parent._matrix);
			}
			
			_invMatrix.copyFrom(_matrix).invert();
			calculateBounds();
		}
		
		public function removeFromParent():void
		{
			if (_parent != null) {
				_parent.removeChild(this);
			}
		}
		
		public function setPosition(xa:Number, ya:Number):void
		{
			if (_x != xa || _y != ya) {
				_x = xa;
				_y = ya;
				setTransform();
			}
		}
		
		public function setPivot(xa:Number, ya:Number):void
		{
			if (_px != xa || _py != ya) {
				_px = xa;
				_py = ya;
				setTransform();
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if (_w != w || _h != h) {
				_w = w;
				_h = h;
				setTransform();
			}
		}
		
		public function setScale(sx:Number, sy:Number):void
		{
			if (_sx != sx || _sy != sy) {
				_sx = sx;
				_sy = sy;
				setTransform();
			}
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================
		
		public function get parent():AesGroup { return _parent; }
		
		public function get matrix():AesMat
		{
			if (_mustTransform) {
				updateTransform();
			}
			
			return _matrix;
		}
		
		public function get invMatrix():AesMat
		{
			if (_mustTransform) {
				updateTransform();
			}
			
			return _invMatrix;
		}
		
		public function get bounds():AesBounds
		{
			if (_mustTransform) {
				updateTransform();
			}
			
			return _bounds;
		}
		
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void
		{
			if (_x != value) {
				_x = value;
				setTransform();
			}
		}
		
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void
		{
			if (_y != value) {
				_y = value;
				setTransform();
			}
		}
		
		
		public function get pivotX():Number { return _px; }
		
		public function set pivotX(value:Number):void 
		{
			if (_px != value) {
				_px = value;
				setTransform();
			}
		}
		
		
		public function get pivotY():Number { return _py; }
		
		public function set pivotY(value:Number):void 
		{
			if (_py != value) {
				_py = value;
				setTransform();
			}
		}
		
		
		public function get angle():Number { return _angle; }
		
		public function set angle(value:Number):void
		{
			if (_angle != value) {
				_angle = value;
				setTransform();
			}
		}
		
		
		public function get width():Number { return _w; }
		
		public function set width(value:Number):void
		{
			if (_w != value) {
				_w = value;
				setTransform();
			}
		}
		
		
		public function get height():Number { return _h; }
		
		public function set height(value:Number):void
		{
			if (_h != value) {
				_h = value;
				setTransform();
			}
		}
		
		
		public function get scaleX():Number { return _sx; }
		
		public function set scaleX(value:Number):void
		{
			if (_sx != value) {
				_sx = value;
				setTransform();
			}
		}
		
		
		public function get scaleY():Number { return _sy; }
		
		public function set scaleY(value:Number):void
		{
			if (_sy != value) {
				_sy = value;
				setTransform();
			}
		}
		
		
		public function set scale(value:Number):void
		{
			if (_sx != value || _sy != value) {
				_sx = value;
				_sy = value;
				setTransform();
			}
		}
		
	}
}