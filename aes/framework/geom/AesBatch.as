package aes.framework.geom
{
	import aes.framework.aes_internal;
	import aes.framework.display.AesBasic;
	import aes.framework.display.AesMesh;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.utils.AesMat;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesBatch extends AesMesh
	{
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _isUpload:Boolean = false;
		
		public function AesBatch()
		{
			super();
		}
		
		override public function clear():void 
		{
			clearBuffers();
			super.clear();
		}
		
		public function clearBuffers():void
		{
			if (_vertexBuffer != null) {
				_vertexBuffer.dispose();
				_vertexBuffer = null;
			}
			
			if (_indexBuffer != null) {
				_indexBuffer.dispose();
				_indexBuffer = null;
			}
			
			_isUpload = false;
		}
		
		public function draw(context3d:Context3D, setUV:Boolean = false, setColor:Boolean = false):void
		{
			if (!_isUpload) {
				clearBuffers();
				
				_vertexBuffer = context3d.createVertexBuffer(_numVertices, 5);
				_vertexBuffer.uploadFromByteArray(_vertexData, 0, 0, _numVertices);
				
				_indexBuffer = context3d.createIndexBuffer(_numIndices);
				_indexBuffer.uploadFromByteArray(_indexData, 0, 0, _numIndices);
				
				_isUpload = true;
			}
			
			context3d.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			if (setUV) {
				context3d.setVertexBufferAt(1, _vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
			}
			
			if (setColor) {
				context3d.setVertexBufferAt(2, _vertexBuffer, 4, Context3DVertexBufferFormat.BYTES_4);
			}
			
			
			context3d.drawTriangles(_indexBuffer, 0, _numTriangles);
			context3d.setVertexBufferAt(0, null);
			context3d.setVertexBufferAt(1, null);
			context3d.setVertexBufferAt(2, null);
		}
		
		public function canCombineMeshes(mesh:AesMesh):Boolean
		{
			if (_numVertices == 0 || mesh._numVertices == 0) return true;
			if (_numVertices + mesh._numVertices > AesMesh.MAX_NUM_VERTICES) return false;
			
			if (_program == mesh._program && _region.texture == mesh._region.texture && _blendMode == mesh._blendMode) return true;
			
			return false;
		}
		
		public function combineFrom(mesh:AesMesh, inToken:AesMeshToken = null, mat:AesMat = null, alpha:Number = 1):AesBatch
		{
			if (mesh == null) {
				throw new AesArgumentError('mesh');
			}
			
			var token:AesMeshToken = mesh._token;
			const verticesStart:int = _numVertices * VERTEX_SIZE
			const indicesStart:int = _numIndices * INDEX_SIZE;
			
			var cVerticesStart:int;
			var cIndicesStart:int;
			var verticesLen:int;
			var indicesLen:int;
			
			if (inToken != null) {
				cVerticesStart = inToken.verticesStart;
				cIndicesStart = inToken.indicesStart;
				verticesLen = inToken.verticesLen;
				indicesLen = inToken.indicesLen;
			} else {
				cVerticesStart = 0;
				cIndicesStart = 0;
				verticesLen = mesh._vertexData.length;
				indicesLen = mesh._indexData.length;				
			}
			
			token.verticesStart = verticesStart;
			token.indicesStart = indicesStart;
			token.verticesLen = verticesLen;
			token.indicesLen = indicesLen;
			
			const offset:int = _numVertices - (cVerticesStart / VERTEX_SIZE);
			var pos:int, len:int;
			
			
			_vertexData.position = verticesStart;
			_vertexData.writeBytes(mesh._vertexData, cVerticesStart, verticesLen);
			
			if (mat != null) {
				var x:Number, y:Number;
				pos = verticesStart;
				len = _vertexData.length;
				
				while (pos < len) {
					_vertexData.position = pos;
					x = _vertexData.readFloat();
					y = _vertexData.readFloat();
					
					_vertexData.position = pos;
					_vertexData.writeFloat(x * mat.a + y * mat.c + mat.x);
					_vertexData.writeFloat(x * mat.b + y * mat.d + mat.y);
					// _vertexData[pos + ALPHA_OFFSET] = alpha;
					
					pos += VERTEX_SIZE;
				}
			}
			
			
			_indexData.position = indicesStart;
			
			if (offset == 0) {
				_indexData.writeBytes(mesh._indexData, cIndicesStart, indicesLen);
			} else {
				var indexAB:uint, indexA:uint, indexB:uint;
				var sourceData:ByteArray = mesh._indexData;
				sourceData.position = cIndicesStart;
				len = indicesLen;
				
				while (len > 1) {
					indexAB = sourceData.readUnsignedInt();
					indexA = ((indexAB & 0xffff0000) >> 16) + offset;
					indexB = ((indexAB & 0x0000ffff)      ) + offset;
					
					_indexData.writeUnsignedInt(indexA << 16 | indexB);
					
					len -= INDEX_SIZE * 2;
				}
				
				if (len > 0) {
					_indexData.writeShort(sourceData.readUnsignedShort() + offset);
				}
			}
			
			_numVertices += verticesLen / VERTEX_SIZE;
			_numIndices += indicesLen / INDEX_SIZE;
			_numTriangles = _numIndices / 3;
			
			return this;
		}
		
	}
}