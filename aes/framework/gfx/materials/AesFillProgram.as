package aes.framework.gfx.materials
{
	import aes.framework.gfx.materials.AesProgram;
	import flash.display3D.Context3D;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesFillProgram extends AesProgram
	{
		
		public function AesFillProgram() 
		{
			const vertexProgramSource:String = STD_VERTEX_PROGRAM + '\n' + [
				'#atr 2 AesColorIn',
				'#var 0 AesColor',
				
				'mov AesColor AesColorIn'
			].join('\n');
			
			const fragmentProgramSource:String = [
				'#var 0 AesColor',
				
				'mov out AesColor'
			].join('\n');
			
			setSource(vertexProgramSource, fragmentProgramSource);
		}
		
		override protected function beforeDraw():void 
		{
			_mesh.draw(_context3d, false, true);
		}
		
	}
}