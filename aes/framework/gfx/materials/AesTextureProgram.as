package aes.framework.gfx.materials
{
	import aes.framework.aes_internal;
	import aes.framework.display.AesMesh;
	import aes.framework.gfx.materials.AesProgram;
	import aes.framework.utils.AesRect;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DFillMode;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.textures.Texture;
	
	use namespace aes_internal;
	
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesTextureProgram extends AesProgram
	{
		
		public function AesTextureProgram()
		{	
			const vertexProgramSource:String = STD_VERTEX_PROGRAM + '\n' + [
				'#atr 1 AesUvIn',
				'#cst 2 AesUvRect',
				'#var 0 AesUv',
				
				'mul t.uv AesUvIn.uv AesUvRect.zw',
				'add AesUv t.uv AesUvRect.xy'
			].join('\n');
			
			const fragmentProgramSource:String = [
				'#var 0 AesUv',
				'#smp 0 AesTex',
				
				'tex out AesUv.uv AesTex'
			].join('\n');
			
			setSource(vertexProgramSource, fragmentProgramSource);
		}
		
		override protected function beforeDraw():void 
		{
			_context3d.setProgramConstantsFromVector('vertex', 2, _mesh.region.rawData(), 1);
			_context3d.setTextureAt(0, _mesh.region.texture);
			_context3d.setSamplerStateAt(0, Context3DWrapMode.CLAMP, Context3DTextureFilter.NEAREST , Context3DMipFilter.MIPNONE);
			_mesh.draw(_context3d, true);
		}
		
		override protected function afterDraw():void 
		{
			_context3d.setTextureAt(0, null);
		}
		
	}
}