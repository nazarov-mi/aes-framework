package aes.framework.managers
{
	import aes.framework.core.AesSpace;
	import aes.framework.core.AesState;
	import aes.framework.display.AesBasic;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.events.AesMouseEvent;
	import aes.framework.managers.AesManager;
	import aes.framework.utils.AesPool;
	import aes.framework.utils.AesVec;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import aes.framework.aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	use namespace aes_internal;
	
	public class AesMouseManager extends AesManager
	{
		
		public function AesMouseManager(aes:AesSpace)
		{
			if (stage == null) {
				throw new AesArgumentError('aes');
			}
		}
		
		override public function create():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,  mouseHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,    mouseHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,  mouseHandler);
		}
		
		override public function dispose():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,  mouseHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,    mouseHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,  mouseHandler);
		}
		
		private function mouseHandler(event:MouseEvent):void
		{
			var type:String;
			
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					type = AesMouseEvent.BEGAN;
					_mouseDown = true;
					break;
				
				case MouseEvent.MOUSE_UP:
					type = AesMouseEvent.ENDED;
					_mouseDown = false;
					break;
				
				case MouseEvent.MOUSE_MOVE:
					type = (_mouseDown ? AesMouseEvent.MOVED : AesMouseEvent.HOVER);
					break;
			}
			
			var globalX:Number = event.stageX;
			var globalY:Number = event.stageY;
			
			var target:AesBasic = aes.state.hitTest(globalX, globalY);
			var local:AesVec = AesPool.get(AesVec) as AesVec;
			local.set(globalX, globalY).transform(target.invMatrix);
			
			var mouseEvent:AesMouseEvent = AesPool.get(AesMouseEvent) as AesMouseEvent;
			mouseEvent._type = type;
			mouseEvent._bubbles = true;
			mouseEvent.globalX = globalX;
			mouseEvent.globalY = globalY;
			mouseEvent.localX = local.x;
			mouseEvent.localY = local.y;
			mouseEvent.ctrlKey = event.ctrlKey;
			mouseEvent.altKey = event.altKey;
			mouseEvent.shiftKey = event.shiftKey;
			
			AesPool.free(local);
			
			target.dispatchEvent(mouseEvent);
			AesPool.free(mouseEvent);
		}
		
	}
}