package aes.framework.gfx.materials
{
	import aes.framework.errors.AesAbstractMethodError;
	import aes.framework.geom.AesBatch;
	import aes.framework.display.AesMesh;
	import aes.framework.gfx.assembler.AesAgalAssembler;
	import aes.framework.utils.AesMat;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesProgram
	{
		private static var ASSEMBLER:AesAgalAssembler = new AesAgalAssembler();
		
		protected static var AGAL_VERSION:uint = 1;
		protected static const STD_VERTEX_PROGRAM:String = [
			'#atr 0 VertIn',
			'#cst 0 Transform[2]',
			
			'mov out VertIn',
			'dp3 t.x VertIn Transform[0]',
			'dp3 t.y VertIn Transform[1]',
			'add out.x t.x Transform[0].z',
			'add out.y t.y Transform[1].z'
		].join('\n');
		
		
		protected var _context3d:Context3D = null;
		protected var _mesh:AesBatch = null;
		
		private var _vertexProgram:ByteArray;
		private var _fragmentProgram:ByteArray;
		private var _program:Program3D = null;
		private var _transform:AesMat = new AesMat();
		
		public function AesProgram(vertexProgram:ByteArray = null, fragmentProgram:ByteArray = null)
		{
			_vertexProgram = vertexProgram;
			_fragmentProgram = fragmentProgram;
		}
		
		public function setSource(vertexProgramSource:String, fragmentProgramSource:String):void
		{
			dispose();
			
			_vertexProgram = ASSEMBLER.assemble(vertexProgramSource, 'vertex', AGAL_VERSION);
			_fragmentProgram = ASSEMBLER.assemble(fragmentProgramSource, 'fragment', AGAL_VERSION);
		}
		
		public static function fromSource(vertexProgramSource:String, fragmentProgramSource:String):AesProgram
		{
			var material:AesProgram = new AesProgram();
			material.setSource(vertexProgramSource, fragmentProgramSource);
			return material;
		}
		
		public function dispose():void
		{
			_context3d = null;
			_mesh = null;
			
			if (_program != null) {
				_program.dispose();
				_program = null;
			}
			
			if (_vertexProgram != null) {
				_vertexProgram.clear();
			}
			
			if (_fragmentProgram != null) {
				_fragmentProgram.clear();
			}
		}
		
		public function draw(context3d:Context3D, mesh:AesBatch):void
		{
			if (_program == null) {
				_program = context3d.createProgram();
				_program.upload(_vertexProgram, _fragmentProgram);
			}
			
			_context3d = context3d;
			_mesh = mesh;
			
			_context3d.setProgram(_program);
			_context3d.setProgramConstantsFromVector('vertex', 0, _transform.rawData(), 2);
			
			beforeDraw();
			afterDraw();
			
			_context3d.setProgram(null);
			
			_context3d = null;
			_mesh = null;
		}
		
		protected function beforeDraw():void
		{
			//
		}
		
		protected function afterDraw():void
		{
			//
		}
		
		public function set transform(value:AesMat):void 
		{
			_transform.copyFrom(value);
		}
		
	}
}