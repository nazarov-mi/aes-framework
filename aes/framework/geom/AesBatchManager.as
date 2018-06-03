package aes.framework.geom
{
	import aes.framework.aes_internal;
	import aes.framework.core.AesSpace;
	import aes.framework.display.AesMesh;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesPool;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesBatchManager
	{
		private var _batches:Vector.<AesBatch> = new Vector.<AesBatch>();
		private var _currentBatch:AesBatch = null;
		private var _currentBatchId:int = 0;
		
		public function AesBatchManager()
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function clear():void
		{
			const len:int = _batches.length;
			for (var i:int = 0; i < len; ++ i) {
				var batch:AesBatch = _batches[i];
				batch.clear();
				AesPool.free(batch);
			}
			
			_batches.length = 0;
			_currentBatch = null;
			_currentBatchId = 0;
		}
		
		public function checkCurrentBatch(mesh:AesMesh):void
		{
			if (_currentBatch == null || !_currentBatch.canCombineMeshes(mesh)) {
				_currentBatch = AesPool.get(AesBatch) as AesBatch;
				_currentBatch.blendMode = mesh.blendMode;
				_currentBatch.program = mesh.program;
				_currentBatch.region = mesh.region;
				_currentBatchId = _batches.length;
				_batches[_currentBatchId] = _currentBatch;
			}
		}
		
		public function addMesh(mesh:AesMesh, mat:AesMat, alpha:Number):void
		{	
			checkCurrentBatch(mesh);
			_currentBatch.combineFrom(mesh, null, mat, alpha);
			mesh.token.batchId = _currentBatchId;
		}
		
		public function addFromCache(mesh:AesMesh, token:AesMeshToken):void
		{
			checkCurrentBatch(mesh);
			_currentBatch.combineFrom(mesh, token);
			token.batchId = _currentBatchId;
		}
		
		public function get batches():Vector.<AesBatch> 
		{
			return _batches;
		}
		
		public function getBatch(index:int):AesBatch
		{
			return _batches[index];
		}
		
	}
}