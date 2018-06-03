package aes.framework.display 
{
	import aes.framework.aes_internal;
	import aes.framework.display.AesBasic;
	import aes.framework.errors.AesAbstractClassError;
	import aes.framework.gfx.AesMask;
	import aes.framework.gfx.AesRenderer;
	import aes.framework.gfx.AesTextureRegion;
	import aes.framework.utils.AesBounds;
	import aes.framework.utils.AesMath;
	import aes.framework.utils.AesRect;
	import aes.framework.utils.AesVec;
	import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesGroup extends AesBasic
	{
		private var _children:Vector.<AesBasic> = new Vector.<AesBasic>();
		
		
		public function AesGroup()
		{
			super();
		}
		
		public function addChild(child:AesBasic):AesBasic
		{
			return addChildAt(child, _children.length);
		}
		
		public function addChildAt(child:AesBasic, index:int):AesBasic
		{
			if (child.parent == this) {
				return null;
			}
			
			const num:int = _children.length;
			
			if (index < 0 || index > num) {
				throw new RangeError('Индекс ' + index + ' выходить за границы диапазона ' + num);
			}
			
			_children.splice(index, 0, child);
			
			child.removeFromParent();
			child.setParent(this);
			
			return child;
		}
		
		public function removeChild(child:AesBasic, dispose:Boolean = false):AesBasic
		{
			const index:int = _children.indexOf(child);
			
			if (index >= 0) {
				return removeChildAt(index, dispose);
			}
			
			return null;
		}
		
		public function removeChildAt(index:int, dispose:Boolean = false):AesBasic
		{
			const num:int = _children.length;
			
			if (index < 0 || index >= num) {
				throw new RangeError('Индекс ' + index + ' выходить за границы диапазона ' + num);
			}
			
			var child:AesBasic = _children[index];
			
			child.setParent(null);
			_children.splice(index, 1);
			
			if (dispose) {
				child.dispose();
			}
			
			return child;
		}
		
		public function getChildAt(index:int):AesBasic
		{
			var num:int = _children.length;
			
			if (index < 0 || index >= num) {
				throw new RangeError('Индекс ' + index + ' выходить за границы диапазона ' + num);
			}
			
			return _children[index];
		}
		
		override public function hitTest(v:AesVec):AesBasic 
		{
			if (super.hitTest(v) != null) {
				const len:int = _children.length;
				for (var i:int = 0; i < len; ++ i) {
					var target:AesBasic = _children[i].hitTest(v);
					
					if (target != null) return target;
				}
			}
			
			return null;
		}
		
		
		override public function dispose():void
		{
			for (var i:int = _children.length - 1; i >= 0; -- i) {
				_children[i].dispose();
			}
			
			super.dispose();
		}
		
		override public function update(dt:Number):void
		{
			super.update(dt);
			
			for (var i:int = _children.length - 1; i >= 0; -- i) {
				_children[i].update(dt);
			}
		}
		
		override public function render(renderer:AesRenderer, parentAlpha:Number):void 
		{
			super.render(renderer, parentAlpha);
			
			for (var i:int = _children.length - 1; i >= 0; -- i) {
				_children[i].render(renderer, alpha * parentAlpha);
			}
		}
		
		aes_internal override function updateTransform():void 
		{
			super.updateTransform();
			
			for (var i:int = _children.length - 1; i >= 0; -- i) {
				var child:AesBasic = _children[i];
				child.updateTransform();
				_bounds.union(child._bounds);
			}
		}
		
		aes_internal override function calculateBounds():AesBounds
		{
			var bds:AesBounds = super.calculateBounds();
			
			for (var i:int = _children.length - 1; i >= 0; -- i) {
				bds.union(_children[i].bounds);
			}
			
			return bds;
		}
		
		
		/*
		public function sortChildren(sortHandler:Function):void
		{
			
		}
		
		private static function mergeSort(input:Vector.<AesBasic>, sortHandler:Function, index:int, length:int, buffer:Vector.<AesBasic>):void
		{
			if (length > 1) {
				
				var i:int;
				var endIndex:int = index + length;
				var halfLength:int = length * .5;
				var l:int = index;
				var r:int = index + halfLength;
				
				mergeSort(input, sortHandler, index, halfLength, buffer);
				mergeSort(input, sortHandler, index + halfLength, length - halfLength, buffer);
				
				for (i = index; i < endIndex; ++ i) {
					
					if (l < index + halfLength &&
						(r == endIndex || sortHandler(input[l], input[r]) <= 0)
					) {
						buffer[i] = input[l];
						++ l;
					} else {
						buffer[i] = input[r];
						++ r;
					}
				}
				
				for (i = index; i < endIndex; ++ i) {
					input[i] = buffer[int(i - index)];
				}
			}
		}
		*/
		
	}
}