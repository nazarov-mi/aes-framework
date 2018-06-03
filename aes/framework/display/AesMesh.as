package aes.framework.display
{
	import aes.framework.aes_internal;
	import aes.framework.core.AesSpace;
	import aes.framework.display.AesBasic;
	import aes.framework.errors.AesArgumentError;
	import aes.framework.geom.AesMeshToken;
	import aes.framework.gfx.AesBlendMode;
	import aes.framework.gfx.AesRenderer;
	import aes.framework.gfx.AesTextureRegion;
	import aes.framework.gfx.materials.AesProgram;
	import aes.framework.utils.AesBounds;
	import aes.framework.utils.AesMat;
	import aes.framework.utils.AesMath;
	import aes.framework.utils.AesPool;
	import aes.framework.utils.AesVec;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMesh extends AesBasic
	{
		public static const MAX_NUM_VERTICES:int = 65535;
		
		protected static const VERTEX_SIZE:int = 20;
		protected static const INDEX_SIZE:int = 2;
		protected static const UV_OFFSET:int = 8;
		protected static const COLOR_OFFSET:int = 16;
		protected static const ALPHA_OFFSET:int = 19;
		
		aes_internal var _vertexData:ByteArray = new ByteArray();
		aes_internal var _indexData:ByteArray = new ByteArray();
		aes_internal var _numVertices:int = 0;
		aes_internal var _numIndices:int = 0;
		aes_internal var _numTriangles:int = 0;
		
		aes_internal var _program:AesProgram;
		aes_internal var _region:AesTextureRegion;
		aes_internal var _blendMode:AesBlendMode = AesBlendMode.NORMAL;
		
		aes_internal var _token:AesMeshToken = new AesMeshToken();
		aes_internal var _lastTokenFrameId:uint = 0xffffffff;
		
		
		public function AesMesh()
		{
			_vertexData.endian = Endian.LITTLE_ENDIAN;
			_indexData.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function clear():void
		{
			_vertexData.clear();
			_indexData.clear();
			_numVertices = 0;
			_numIndices = 0;
			_numTriangles = 0;
			
			setRedraw();
		}
		
		override public function dispose():void 
		{
			clear();
		}
		
		override public function render(renderer:AesRenderer, parentAlpha:Number):void 
		{
			if (!_mustRedraw && _lastTokenFrameId == AesSpace.frameId - 1) {
				renderer.addFromCache(_token);
			} else {
				renderer.addMesh(this, matrix, 1);
			}
			
			_lastTokenFrameId = AesSpace.frameId;
			_mustRedraw = false;
		}
		
		override public function hitTest(v:AesVec):AesBasic 
		{
			if (alpha > 0 && visible && bounds.containsVec(v) && containsVec(v)) {
				return this;
			}
			
			return null
		}
		
		aes_internal override function calculateBounds():AesBounds 
		{
			return getBounds(_bounds, matrix);
		}
		
		
		public function addVertex(x:Number, y:Number, u:Number, v:Number, color:uint = 0xffffffff):void
		{
			color = (color << 8) | ((color >> 24) & 0xff);
			color = AesMath.switchEndian(color);
			
			_vertexData.position = _numVertices * VERTEX_SIZE;
			_vertexData.writeFloat(x);
			_vertexData.writeFloat(y);
			_vertexData.writeFloat(u);
			_vertexData.writeFloat(v);
			_vertexData.writeUnsignedInt(color);
			
			++_numVertices;
			setRedraw();
		}
		
		public function addTriangle(a:uint, b:uint, c:uint, offset:uint = 0):void
		{
			const num:int = _numVertices - offset - 1;
			if (a > num || b > num || c > num) {
				throw new AesArgumentError('индекс a, b или c', 'больше колличества вертексов');
			}
			
			_indexData.position = _numIndices * INDEX_SIZE;
			_indexData.writeShort(a + offset);
			_indexData.writeShort(b + offset);
			_indexData.writeShort(c + offset);
			
			_numIndices += 3;
			++ _numTriangles;
			setRedraw();
		}
		
		public function addRect(x:Number, y:Number, width:Number, height:Number, color:uint = 0xffffffff):void
		{
			const offset:int = _numVertices;
			
			addVertex(x        , y         , 0, 0, color);
			addVertex(x + width, y         , 1, 0, color);
			addVertex(x        , y + height, 0, 1, color);
			addVertex(x + width, y + height, 1, 1, color);
			
			addTriangle(0, 1, 2, offset);
			addTriangle(1, 3, 2, offset);
		}
		
		public function addEllipse(x:Number, y:Number, radiusX:Number, radiusY:Number, color:uint = 0xffffffff, numSides:uint = 10):void
		{
			if (numSides < 3) {
				numSides = 3;
			}
			
			const offset:int = _numVertices;
			const angle:Number = Math.PI * 2 / numSides;
			var i:int;
			
			// Vertices
			for (i = 0; i < numSides; ++ i) {
				const xp:Number = Math.cos(angle * i);
				const yp:Number = Math.sin(angle * i);
				
				addVertex(xp * radiusX + x,
				          yp * radiusY + y,
				          xp * .5 + .5,
				          yp * .5 + .5,
				          color);
			}
			
			// Indices
			-- numSides;
			for (i = 1; i < numSides; ++ i) {
				addTriangle(0, i, i + 1, offset);
			}
		}
		
		public function addLine(xa:Number, ya:Number, xb:Number, yb:Number, thickness:uint = 1, color:uint = 0xffffffff):void
		{
			if (thickness < 1) {
				thickness = 1;
			}
			
			const offset:int = _numVertices;
			var v:AesVec = AesPool.get(AesVec) as AesVec;
			v.set(xb - xa, yb - ya).normalize().scl(thickness * .5);
			
			// Vertices
			addVertex(xa - v.y, ya + v.x, 0, 0, color);
			addVertex(xa + v.y, ya - v.x, 1, 0, color);
			addVertex(xb - v.y, yb + v.x, 0, 1, color);
			addVertex(xb + v.y, yb - v.x, 1, 1, color);
			
			AesPool.free(v);
			
			// Indices
			addTriangle(0, 1, 2, offset);
			addTriangle(1, 3, 2, offset);
		}
		
		public function getIndex(index:uint):uint
		{
			_indexData.position = index * INDEX_SIZE;
			return _indexData.readUnsignedShort();
		}
		
		public function getVertexPos(index:uint, out:AesVec):AesVec
		{
			_vertexData.position = index * VERTEX_SIZE;
			out.x = _vertexData.readFloat();
			out.y = _vertexData.readFloat();
			
			return out;
		}
		
		public function setVertexPos(index:uint, x:Number, y:Number):void
		{
			_vertexData.position = index * VERTEX_SIZE;
			_vertexData.writeFloat(x);
			_vertexData.writeFloat(y);
		}
		
		public function getUV(index:uint, out:AesVec):AesVec
		{
			_vertexData.position = index * VERTEX_SIZE + UV_OFFSET;
			out.x = _vertexData.readFloat();
			out.y = _vertexData.readFloat();
			
			return out;
		}
		
		public function setUV(index:uint, u:Number, v:Number):void
		{
			_vertexData.position = index * VERTEX_SIZE + UV_OFFSET;
			_vertexData.writeFloat(u);
			_vertexData.writeFloat(v);
		}
		
		public function getColor(index:uint):uint
		{
			_vertexData.position = index * VERTEX_SIZE + COLOR_OFFSET;
			const color:uint = AesMath.switchEndian(_vertexData.readUnsignedInt());
			
			return (color >> 8) | ((color << 24) & 0xff);
		}
		
		public function setColor(index:uint, color:uint):void
		{
			color = ((color << 8) && 0xffffff00) | (color >> 24);
			color = AesMath.switchEndian(color);
			
			_vertexData.position = index * VERTEX_SIZE + COLOR_OFFSET;
			_vertexData.writeUnsignedInt(color);
		}
		
		public function getAlpha(index:uint):Number
		{
			return _vertexData[index * VERTEX_SIZE + ALPHA_OFFSET];
		}
		
		public function setAlpha(index:uint, alpha:Number):void
		{
			_vertexData[index * VERTEX_SIZE + ALPHA_OFFSET] = alpha * 255;
		}
		
		public function containsVec(v:AesVec):Boolean
		{
			if (_numIndices > 0) {
				var res:Boolean = false;
				var a:AesVec = AesPool.get(AesVec) as AesVec;
				var b:AesVec = AesPool.get(AesVec) as AesVec;
				var c:AesVec = AesPool.get(AesVec) as AesVec;
				
				for (var i:int = 0; i < _numIndices; i += 3) {
					getVertexPos(getIndex(i    ), a);
					getVertexPos(getIndex(i + 1), b);
					getVertexPos(getIndex(i + 2), c);
					
					if (AesMath.containsWithTriangle(v, a, b, c)) {
						res = true;
						break;
					}
				}
				
				AesPool.free(a);
				AesPool.free(b);
				AesPool.free(c);
				
				return res;
			}
			
			return false;
		}
		
		public function getBounds(out:AesBounds, mat:AesMat = null):AesBounds
		{
			if (_numVertices == 0) {
				if (mat == null) {
					out.setZero();
				} else {
					out.set(mat.x, mat.y, mat.x, mat.y);
				}
			} else {
				var minX:Number = AesMath.MAXN;
				var minY:Number = AesMath.MAXN;
				var maxX:Number = AesMath.MINN;
				var maxY:Number = AesMath.MINN;
				var x:Number, y:Number, i:int;
				
				if (mat == null) {
					for (i = 0; i < _numVertices; ++ i) {
						_vertexData.position = i * VERTEX_SIZE;
						x = _vertexData.readFloat();
						y = _vertexData.readFloat();
						
						if (minX > x) minX = x;
						if (minY > y) minY = y;
						if (maxX < x) maxX = x;
						if (maxY < y) maxY = y;
					}
				} else {
					var n:Number;
					
					for (i = 0; i < _numVertices; ++ i) {
						_vertexData.position = i * VERTEX_SIZE;
						n = _vertexData.readFloat();
						y = _vertexData.readFloat();
						
						x = n * mat.a + y * mat.c + mat.x;
						y = n * mat.b + y * mat.d + mat.y;
						
						if (minX > x) minX = x;
						if (minY > y) minY = y;
						if (maxX < x) maxX = x;
						if (maxY < y) maxY = y;
					}
				}
				
				out.set(minX, minY, maxX, maxY);
			}
			
			return out;
		}
		
		
		//===================
		// GETTERS / SETTERS
		//===================
		
		public function get program():AesProgram { return _program; }
		
		public function set program(value:AesProgram):void 
		{
			if (_program != value) {
				_program = value;
				setRedraw();
			}
		}
		
		public function get region():AesTextureRegion { return _region; }
		
		public function set region(value:AesTextureRegion):void 
		{
			if (_region != value) {
				_region = value;
				setRedraw();
			}
		}
		
		public function get blendMode():AesBlendMode { return _blendMode; }
		
		public function set blendMode(value:AesBlendMode):void 
		{
			if (_blendMode != value) {
				_blendMode = value;
				setRedraw();
			}
		}
		
		public function get token():AesMeshToken { return _token; }
		
		public function get vertexData():ByteArray { return _vertexData; }
		
		public function get indexData():ByteArray { return _indexData; }
		
		public function get numVertices():int { return _numVertices; }
		
		public function get numIndices():int { return _numIndices; }
		
		public function get numTriangles():int { return _numTriangles; }
		
	}
}