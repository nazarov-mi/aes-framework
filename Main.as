package
{
	import aes.framework.core.AesSpace;
	import aes.framework.core.AesState;
	import aes.framework.display.AesActor;
	import aes.framework.display.AesBasic;
	import aes.framework.display.AesCanvas;
	import aes.framework.events.AesEvent;
	import aes.framework.events.AesMouseEvent;
	import aes.framework.files.AesAssetManager;
	import aes.framework.files.AesFileType;
	import aes.framework.files.AesSound;
	import aes.framework.gfx.AesAtlas;
	import aes.framework.gfx.assembler.AesAgalAssembler;
	import aes.framework.gfx.assembler.AesOperation;
	import aes.framework.gfx.assembler.AesOperations;
	import aes.framework.gfx.assembler.AesRegistry;
	import aes.framework.utils.AesColor;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesMath;
	import aes.framework.utils.AesPool;
	import aes.framework.utils.AesRect;
	import aes.framework.utils.AesVec;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * @author Назаров М. И.
	 */
	
	public class Main extends Sprite 
	{
		private var fm:AesAssetManager = new AesAssetManager();
		private var aes:AesSpace;
		private var debug:AesCanvas;
		private var objs:Vector.<AesBasic> = new Vector.<AesBasic>();
		
		public function Main() 
		{
			fm.addEventListener(Event.COMPLETE, completeHandler);
			fm.add('tex', 'test/img.png', AesFileType.IMAGE);
			fm.add('snd', 'test/snd.mp3', AesFileType.SOUND);
			fm.load();
		}
		
		private function completeHandler(event:Event):void 
		{
			var st:AesState = new AesState();
			aes = new AesSpace(st);
			addChild(aes);
			aes.start();
			
			var at:AesAtlas = new AesAtlas(fm.get('tex'));
			at.add('tex', 0, 0, 64, 64);
			at.add('tex2', 64, 0, 64, 64);
			
			aes.cb = function ():void {
				// (fm.get('snd') as AesSound).play();
				
				AesSpace.materialManager.add('tex', at);
				
				aes.camera.backgroundColor = AesColor.DARKPINK;
				
				var dp:AesBasic;
				
				const nm:int = 2000;
				for (var i:int = 0; i < nm; ++ i) {
					dp = new AesActor(at.get('tex'));
					st.addChild(dp);
					objs[objs.length] = dp;
					dp.setPosition(400, 300);
					dp.setPivot(25, 25);
					dp.setSize(50, 50);
					
					const a:Number = Math.PI * 2 / nm * i;
					dp.userData.vx = Math.cos(a);
					dp.userData.vy = Math.sin(a);
					dp.angle = a * 180 / Math.PI;
				}
				
				debug = new AesCanvas(at.get('tex'));
				st.addChild(debug);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			const sp:int = 3;
			debug.clear();
			debug.setLineStyle(1, 0xff9900);
			
			for (var i:int = objs.length - 1; i >= 0; -- i) {
				var dp:AesBasic = objs[i];
				
				if (dp.x <= 25 || dp.x >= 775) {
					dp.userData.vx *= -1;
				}
				
				if (dp.y <= 25 || dp.y >= 575) {
					dp.userData.vy *= -1;
				}
				
				dp.x += dp.userData.vx * sp;
				dp.y += dp.userData.vy * sp;
				
				//debug.drawRect(dp.bounds.minX, dp.bounds.minY, dp.bounds.width, dp.bounds.height);
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void 
		{
			const sp:Number = 10;
			
			if (event.keyCode == Keyboard.W) {
				aes.camera.y -= sp;
			}
			if (event.keyCode == Keyboard.A) {
				aes.camera.x -= sp;
			}
			if (event.keyCode == Keyboard.S) {
				aes.camera.y += sp;
			}
			if (event.keyCode == Keyboard.D) {
				aes.camera.x += sp;
			}
			if (event.keyCode == Keyboard.Q) {
				aes.camera.zoom += .2;
			}
			if (event.keyCode == Keyboard.E) {
				aes.camera.zoom -= .2;
			}
		}
		
	}
}