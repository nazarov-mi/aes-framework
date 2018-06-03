package aes.framework.gfx 
{
	import aes.framework.aes_internal;
	import aes.framework.core.AesCamera;
	import aes.framework.core.AesSpace;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.geom.AesBatch;
	import aes.framework.geom.AesBatchManager;
	import aes.framework.display.AesMesh;
	import aes.framework.geom.AesMeshToken;
	import aes.framework.gfx.materials.AesFillProgram;
	import aes.framework.gfx.materials.AesProgram;
	import aes.framework.gfx.materials.AesTextureProgram;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesMath;
	import aes.framework.utils.AesPool;
	import aes.framework.utils.AesRect;
	import aes.framework.utils.AesVec;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public final class AesRenderer extends Object
	{
		private var _mat:AesMat = new AesMat();
		private var _defProgram:AesProgram = new AesTextureProgram();
		
		private var _camera:AesCamera = null;
		private var _context3d:Context3D = null;
		private var _batchManager:AesBatchManager = new AesBatchManager();
		private var _cacheManager:AesBatchManager = new AesBatchManager();
		
		public function AesRenderer(context3d:Context3D, camera:AesCamera)
		{
			_context3d = context3d;
			_camera = camera;
		}
		
		public function clear():void
		{
			_context3d.clear(_camera.backgroundColor.r, _camera.backgroundColor.g, _camera.backgroundColor.b);
		}
		
		public function present():void
		{
			_context3d.present();
		}
		
		public function addMesh(mesh:AesMesh, mat:AesMat, alpha:Number):void
		{
			mesh.program = _defProgram;
			_batchManager.addMesh(mesh, mat, alpha);
		}
		
		public function addFromCache(token:AesMeshToken):void
		{
			_batchManager.addFromCache(_cacheManager.getBatch(token.batchId), token);
		}
		
		public function draw():void
		{
			var batches:Vector.<AesBatch> = _batchManager.batches;
			
			const len:int = batches.length;
			for (var i:int = 0; i < len; ++ i) {
				const mesh:AesBatch = batches[i];
				
				mesh.program.transform = _camera.matrix;
				mesh.program.draw(_context3d, mesh);
			}
			
			// trace(i);
		}
		
		public function finish():void
		{
			var tmp:AesBatchManager = _batchManager;
			_batchManager = _cacheManager;
			_cacheManager = tmp;
			
			_batchManager.clear();
		}
		
	}
}