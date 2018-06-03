package aes.framework.core 
{
	import aes.framework.aes_internal;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.gfx.AesRenderer;
	import aes.framework.gfx.materials.AesProgramManager;
	import aes.framework.utils.AesColor;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public final class AesSpace extends Sprite
	{
		public static var materialManager:AesProgramManager;
		public static var frameId:int = 0;
		
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;
		
		private var _camera:AesCamera;
		private var _state:AesState;
		private var _renderer:AesRenderer;
		private var _isStarted:Boolean = false;
		
		private var _dt:Number;
		
		public var cb:Function;
		public var fps:int = 0;
		
		public function AesSpace(state:AesState, frameRate:int = 30)
		{
			_dt = 1 / frameRate;
			
			switchState(state);
			
			if (stage != null) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void
		{
			if (event != null) {
				removeEventListener(Event.ADDED_TO_STAGE, init);
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			
			_stage3d = stage.stage3Ds[0];
			_stage3d.addEventListener(Event.CONTEXT3D_CREATE, context3dCreateHandler);
			_stage3d.addEventListener(ErrorEvent.ERROR, errorEventHandler);
			_stage3d.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
		}
		
		private function context3dCreateHandler(event:Event):void
		{
			_context3d = _stage3d.context3D;
			
			_context3d.enableErrorChecking = true;
			_context3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 2, false);
			_context3d.setCulling(Context3DTriangleFace.NONE);
			_context3d.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			// _context3d.setFillMode(Context3DFillMode.WIREFRAME);
			
			_camera = new AesCamera(AesColor.WHITE);
			_camera.resize(stage.stageWidth, stage.stageHeight);
			
			_renderer = new AesRenderer(_context3d, _camera);
			materialManager = new AesProgramManager(_context3d);
			
			if (cb !== null) {
				cb.call();
			}
		}
		
		private function errorEventHandler(event:ErrorEvent):void
		{
			trace(event.errorID + ': ' + event.text);
		}
		
		public function start():void
		{
			if (!_isStarted) {
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_isStarted = true;
			}
		}
		
		public function stop():void
		{
			if (_isStarted) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_isStarted = false;
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			fps = getTimer();
			
			++ frameId;
			
			update();
			render();
			
			fps = 1000 / (getTimer() - fps);
			//trace(fps);
		}
		
		public function update():void
		{
			const t:int = getTimer();
			_state.update(_dt);
			trace('Update state: ' + (getTimer() - t));
		}
		
		public function render():void
		{
			var t:int = getTimer();
			_state.render(_renderer, 1);
			trace('Render state: ' + (getTimer() - t));
			
			t = getTimer();
			_renderer.clear();
			_renderer.draw();
			_renderer.present();
			_renderer.finish();
			trace('Render batches: ' + (getTimer() - t));
		}
		
		public function switchState(aState:AesState):void
		{
			if (aState == null) {
				throw new AesArgumentError('aState');
			}
			
			if (_state != null) {
				_state.dispose();
			}
			
			_state = aState;
			_state.create();
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================
		
		public function get state():AesState
		{
			return _state;
		}
		
		public function get camera():AesCamera 
		{
			return _camera;
		}
		
	}
}