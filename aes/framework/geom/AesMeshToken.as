package aes.framework.geom
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesMeshToken
	{
		public var batchId:int = 0;
		public var verticesStart:uint = 0;
		public var verticesLen:uint = 0;
		public var indicesStart:uint = 0;
		public var indicesLen:uint = 0;
		
		public function AesMeshToken()
		{
			super();
		}
		
		public function identity():AesMeshToken
		{
			batchId = 0;
			verticesStart = 0;
			verticesLen = 0;
			indicesStart = 0;
			indicesLen = 0;
			
			return this;
		}
		
	}
}