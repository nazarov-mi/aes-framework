package aes.framework.errors
{
	/**
	 * @author Назаров М.И.
	 */
	
	public final class AesAbstractMethodError extends Error
	{
		
		public function AesAbstractMethodError()
		{
			super('Попытка вызвать абстрактный метод');
			
		}
		
	}
}